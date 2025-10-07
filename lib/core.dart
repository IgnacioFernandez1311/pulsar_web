import 'package:pulsar/pulsar.dart';
import 'package:web/web.dart';
import 'dart:js_interop';
import 'package:jinja/jinja.dart';

abstract class Component {
  late HTMLElement host;
  String tagName = "div";
  Map<String, dynamic> props();
  Future<String> template();
  Future<String?> style() async => null;
  Map<String, Function> get methodRegistry => {};
  static final Environment jinjaEnv = Environment();

  void afterRender() {}

  HTMLElement build() {
    host = document.createElement(tagName) as HTMLElement;
    _render();
    return host;
  }

  void setState(void Function() updater) {
    updater();
    _render();
  }

  Future<void> _render() async {
    String tpl = await template();

    tpl = tpl.replaceAllMapped(
      RegExp(r'{%\s*insert\s+"([^"]+)"\s*%}'),
      (match) => '<div data-insert="${match.group(1)!}"></div>',
    );

    final Template jinjaTemplate = jinjaEnv.fromString(tpl);
    final String proccessedTemplate = jinjaTemplate.render(props());
    host.setHTMLUnsafe(proccessedTemplate.toJS);

    final String? css = await style();
    if (css != null && css.isNotEmpty) {
      final String styleId = "style-${runtimeType.toString()}";
      if (document.head?.querySelector("#$styleId") == null) {
        final HTMLStyleElement styleElement = HTMLStyleElement()
          ..id = styleId
          ..textContent = css;
        document.head?.append(styleElement);
      }
    }

    final Map<String, dynamic> values = props();
    values.forEach((key, value) {
      // ignore: invalid_runtime_check_with_js_interop_types
      if (value is HTMLElement) {
        final placeholder = host.querySelector('[data-slot="$key"]');
        if (placeholder != null) {
          placeholder.replaceWith(value);
        }
      }
    });

    _bindEvents();
    afterRender();
    await _resolveInserts();
  }

  void _bindEvents() {
    final NodeList nodeList = host.querySelectorAll('[\\@click]');
    final List elements = [
      for (int i = 0; i < nodeList.length; i++) nodeList.item(i),
    ];

    for (final element in elements) {
      if (element == null) continue;
      final String attr = element.getAttribute('@click');
      final fn = _findMethod(attr);
      void methodHandle(Event event) {
        fn!(event);
      }

      if (fn != null) {
        element.addEventListener('click', methodHandle.toJS);
      } else {
        print('Metodo "$attr" no encontrado en "$runtimeType"');
      }
    }
  }

  Future<void> _resolveInserts() async {
    final NodeList nodeList = host.querySelectorAll('[data-insert]');
    final List placeholders = [
      for (int i = 0; i < nodeList.length; i++) nodeList.item(i),
    ];

    for (final placeholder in placeholders) {
      final String name = placeholder.getAttribute('data-insert');
      final Component? child = Registry.create(name);
      if (child != null) {
        final HTMLElement childElement = child.build();
        placeholder.replaceWith(childElement);
      }
    }
  }

  Function? _findMethod(String name) {
    return methodRegistry[name];
  }

  /*
  String _interpolate(String template) {
    final values = props();
    return template.replaceAllMapped(RegExp(r'{{\s*(\w+)\s*}}'), (match) {
      final String key = match.group(1)!;
      final value = values[key];
      if (value is HTMLElement) {
        return '<div data-slot="$key"></div>';
      }
      return value?.toString() ?? '';
    });
  }
*/
}

/// Function to load templates and styles from a url. The base directory is always considered the web/ directory.
Future<String> loadFile(String path) async {
  final Response response = await window.fetch(path.toJS).toDart;
  final JSString text = await response.text().toDart;
  return text.toDart;
}

void runApp(List<Component> components, {Provider? componentProvider}) {
  for (final Component component in components) {
    document.body?.append(component.build());
  }
  componentProvider?.registerComponents();
}
