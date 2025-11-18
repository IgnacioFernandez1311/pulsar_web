import 'package:jinja/jinja.dart';
import 'package:pulsar_web/component.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart';
import 'dart:convert';

mixin LifeCycleMixin {
  void onInit() {}
  void onMounted() {}
  void afterRender() {}
  void onUpdated() {}
  void onDestroy() {}
}

abstract class Renderable with LifeCycleMixin {
  String get name => runtimeType.toString();
  late HTMLElement host;
  static final Environment jinjaEnv = Environment();

  String? instanceId;

  List<Renderable> get imports => <Renderable>[];

  Map<String, dynamic> get unifiedContext {
    final ctx = <String, dynamic>{};

    if (this is Component) {
      final comp = this as Component;

      // 1) props defaults
      ctx.addAll(comp.propsRegistry);

      // 2) props recibidas crudas
      ctx.addAll(comp.propsData);

      // 3) props procesadas (sobrescriben las anteriores)
      ctx.addAll(comp.processedProps);

      // 4) states (tienen prioridad absoluta)
      ctx.addAll(comp.states);
    } else {
      // Para Renderable normal
      ctx.addAll(propsData);
    }

    return ctx;
  }

  Map<String, dynamic> get renderContext => unifiedContext;

  Map<String, dynamic> propsData = <String, dynamic>{};
  Map<String, dynamic> get props => Map<String, dynamic>.from(propsData);

  void receiveProps(Map<String, dynamic> newProps) {
    if (newProps.isEmpty) return;
    propsData.addAll(newProps);
  }

  Future<String> get template;
  Future<String?> get style async => null;
  Map<String, Function> get methodRegistry => <String, Function>{};

  HTMLElement build() {
    if (instanceId != null) {
      final Element? existing = document.querySelector(
        '[data-p-id="$instanceId"]',
      );
      // ignore: invalid_runtime_check_with_js_interop_types
      if (existing != null && existing is HTMLElement) {
        host = existing;
        _bindEvents();
        afterRender();
        return host;
      }
    }
    host = document.createElement('div') as HTMLElement;
    render();
    return host;
  }

  Future<void> render() async {
    String tpl = await template;

    // Content Slot (modificado para preservar el contenido)
    tpl = tpl.replaceAllMapped(
      RegExp(r'<@View\s*/>'),
      (match) => '<div data-slot="content"></div>',
    );

    // Inserciones
    tpl = tpl.replaceAllMapped(
      RegExp(
        r'<([A-Z][A-Za-z0-9_-]*)((?:\s+[a-zA-Z0-9_-]+(?:="[^"]*"|\{\{[^}]*\}\})?)*)?\s*\/>',
      ),
      (match) {
        final componentName = match.group(1)!;
        final propsString = match.group(2) ?? '';

        // Extraer props del string de atributos
        final extractedProps = <String, String>{};
        final propsRegex = RegExp(
          r'([a-zA-Z0-9_-]+)(?:="([^"]*)"|=(\{\{[^}]*\}\}))?',
        );

        for (final prop in propsRegex.allMatches(propsString)) {
          final name = prop.group(1)!;
          final value = prop.group(2) ?? prop.group(3) ?? '';
          extractedProps[name] = value;
        }

        // Crear el div con data-insert y los props extraídos
        final attrs = extractedProps.entries
            .map((e) => '${e.key}="${e.value}"')
            .join(' ');

        return '<div data-insert="$componentName" $attrs></div>';
      },
    );

    final Template jinjaTemplate = jinjaEnv.fromString(tpl);
    final String processedTemplate = jinjaTemplate.render(renderContext);
    host.setHTMLUnsafe(processedTemplate.toJS);

    // CSS por clase (usando _safeId)
    final String? css = await style;
    if (css != null && css.isNotEmpty) {
      final String styleId = "style-${_safeId(runtimeType.toString())}";
      if (document.head?.querySelector("#$styleId") == null) {
        final HTMLStyleElement styleElement = HTMLStyleElement()
          ..id = styleId
          ..textContent = css;
        document.head?.append(styleElement);
      }
    }

    // Manejar slots con contenido
    if (props.containsKey('content')) {
      final Element? contentSlot = host.querySelector('[data-slot="content"]');
      if (contentSlot != null) {
        // ignore: invalid_runtime_check_with_js_interop_types
        if (props['content'] is HTMLElement) {
          contentSlot.replaceWith(props['content'] as HTMLElement);
        }
      }
    }

    // Otros slots
    final Map<String, dynamic> values = Map<String, dynamic>.from(props);
    values.remove('content'); // Ya manejamos el slot de contenido
    values.forEach((String key, dynamic value) {
      // ignore: invalid_runtime_check_with_js_interop_types
      if (value is HTMLElement) {
        final Element? placeholder = host.querySelector('[data-slot="$key"]');
        if (placeholder != null) placeholder.replaceWith(value);
      }
    });

    _bindEvents();
    await _resolveInserts();
    afterRender();
  }

  void setState(void Function() updater) {
    updater();
    render();
  }

  Future<void> _resolveInserts() async {
    // Busca placeholders generados por el parser: <div data-insert="Name" data-props='...'></div>
    final NodeList nodeList = host.querySelectorAll('[data-insert]');
    for (int i = 0; i < nodeList.length; i++) {
      final Node? node = nodeList.item(i);
      if (node == null) continue;
      final Element placeholder = node as Element;
      final String componentName =
          placeholder.getAttribute('data-insert') ?? '';
      final Renderable? child = createImportByName(componentName);
      if (child == null) continue;

      // 1) Obtener props: preferimos data-props JSON; si no existe, recoger atributos
      Map<String, dynamic> incomingProps = <String, dynamic>{};
      final String? propsJson = placeholder.getAttribute('data-props');

      if (propsJson != null && propsJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(propsJson);
          if (decoded is Map<String, dynamic>) {
            incomingProps = Map<String, dynamic>.from(decoded);
          } else if (decoded is Map) {
            incomingProps = Map<String, dynamic>.from(
              decoded.cast<String, dynamic>(),
            );
          }
        } catch (_) {
          // si el json no es válido, caeremos al parseo por atributos
          incomingProps = <String, dynamic>{};
        }
      }

      if (incomingProps.isEmpty) {
        // recoger atributos distintos a data-insert
        final attrs = placeholder.attributes;
        for (int ai = 0; ai < attrs.length; ai++) {
          final attr = attrs.item(ai)!;
          if (attr.name == 'data-insert') continue;
          incomingProps[attr.name] = attr.value;
        }
      }

      // 2) Resolver expresiones dinámicas {{expr}} desde el contexto del padre (this.props)
      final dynRe = RegExp(r'^\{\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\}\}$');
      final keys = incomingProps.keys.toList();
      for (final key in keys) {
        final value = incomingProps[key];
        if (value is String) {
          final m = dynRe.firstMatch(value);
          if (m != null) {
            // Intentar obtener desde las props del padre (this.props)
            final comp = this is Component ? this as Component : null;

            // ignore: unnecessary_null_comparison
            if (m != null) {
              final expr = m.group(1)!.trim();

              late final Map<String, dynamic> unifiedContext;

              if (comp != null) {
                unifiedContext = {...comp.props, ...comp.states};
              } else {
                unifiedContext = {...props};
              }

              incomingProps[key] = unifiedContext[expr];
            }
          }

          // 3) Intentar convertir literales string a bool/int/double si aplica
          final lower = value.toLowerCase();
          if (lower == 'true') {
            incomingProps[key] = true;
            continue;
          } else if (lower == 'false') {
            incomingProps[key] = false;
            continue;
          }

          final intVal = int.tryParse(value);
          if (intVal != null) {
            incomingProps[key] = intVal;
            continue;
          }
          final doubleVal = double.tryParse(value);
          if (doubleVal != null) {
            incomingProps[key] = doubleVal;
            continue;
          }

          // si no se pudo convertir, conservar el string tal cual
          incomingProps[key] = value;
        } else {
          // ya es number/bool/etc, se mantiene
          incomingProps[key] = value;
        }
      }

      // 4) Aplicar props al hijo y construirlo
      child.receiveProps(incomingProps);
      final HTMLElement childEl = child.build();
      placeholder.replaceWith(childEl);
    }
  }

  void _bindEvents() {
    final NodeList nodeList = host.querySelectorAll('[\\@click]');
    for (int i = 0; i < nodeList.length; i++) {
      final Node? element = nodeList.item(i);
      if (element == null) continue;
      final String attr = (element as Element).getAttribute('@click')!;
      final Function? fn = _findMethod(attr);
      if (fn != null) {
        void handler(Event e) => fn(e);
        element.addEventListener('click', handler.toJS);
      }
    }
  }

  Renderable? createImportByName(String name) {
    for (final Renderable renderableFactory in imports) {
      final Renderable instance = renderableFactory;
      if (instance.runtimeType.toString() == name) {
        return instance;
      }
    }
    return null;
  }

  Function? _findMethod(String name) => methodRegistry[name];

  String _safeId(String input) =>
      input.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
}
