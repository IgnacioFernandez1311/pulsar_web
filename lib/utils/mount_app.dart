import 'package:universal_web/web.dart';
import 'package:pulsar_web/core/component.dart';
import 'package:pulsar_web/engine/runtime/component_runtime.dart';

import 'package:pulsar_web/engine/renderer/web_renderer.dart';

void mountApp(Component root, {String selector = '#app'}) {
  final container = document.querySelector(selector);

  if (container == null) {
    throw Exception('Mount point not found: $selector');
  }

  final renderer = WebRenderer(container);
  final runtime = ComponentRuntime(renderer);

  runtime.mount(root);
}
