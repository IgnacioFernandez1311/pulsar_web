import 'package:jinja/jinja.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart';

abstract class Renderable {
  late HTMLElement host;
  static final Environment jinjaEnv = Environment();

  List<Renderable Function()> get imports => [];

  Map<String, dynamic> get props => {};
  Future<String> get template;
  Future<String?> get style async => null;
  Map<String, Function> get methodRegistry => {};

  HTMLElement build() {
    host = document.createElement('div') as HTMLElement;
    render();
    return host;
  }

  Future<void> render() async {
    String tpl = await template;

    // Inserciones
    tpl = tpl.replaceAllMapped(
      RegExp(r'{%\s*insert\s+"([^"]+)"\s*%}'),
      (match) => '<div data-insert="${match.group(1)!}"></div>',
    );

    // Content Slot
    tpl = tpl.replaceAllMapped(
      RegExp(r'{%\s*content\s*%}'),
      (match) => '<div data-slot="content"></div>',
    );

    final Template jinjaTemplate = jinjaEnv.fromString(tpl);
    final String processedTemplate = jinjaTemplate.render(props);
    host.setHTMLUnsafe(processedTemplate.toJS);

    // CSS por clase
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

    // Slots
    final Map<String, dynamic> values = props;
    values.forEach((key, value) {
      // ignore: invalid_runtime_check_with_js_interop_types
      if (value is HTMLElement) {
        final placeholder = host.querySelector('[data-slot="$key"]');
        if (placeholder != null) placeholder.replaceWith(value);
      }
    });

    _bindEvents();
    await _resolveInserts();
    afterRender();
  }

  void afterRender() {}
  void setState(void Function() updater) {
    updater();
    render();
  }

  Future<void> _resolveInserts() async {
    final NodeList nodeList = host.querySelectorAll('[data-insert]');
    for (int i = 0; i < nodeList.length; i++) {
      final placeholder = nodeList.item(i);
      if (placeholder == null) continue;
      final String name = (placeholder as Element).getAttribute('data-insert')!;
      final Renderable? child = _createImport(name);
      if (child != null) {
        final HTMLElement childEl = child.build();
        placeholder.replaceWith(childEl);
      }
    }
  }

  void _bindEvents() {
    final NodeList nodeList = host.querySelectorAll('[\\@click]');
    for (int i = 0; i < nodeList.length; i++) {
      final element = nodeList.item(i);
      if (element == null) continue;
      final String attr = (element as Element).getAttribute('@click')!;
      final fn = _findMethod(attr);
      if (fn != null) {
        void handler(Event e) => fn(e);
        element.addEventListener('click', handler.toJS);
      }
    }
  }

  Renderable? _createImport(String name) {
    for (final renderableFactory in imports) {
      final instance = renderableFactory();
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