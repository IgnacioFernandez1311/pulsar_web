import 'package:pulsar_web/engine/node/node.dart';
import 'package:pulsar_web/engine/runtime/component_runtime.dart';
import 'package:pulsar_web/engine/stylesheet/stylesheet.dart';

abstract class Component {
  ComponentRuntime? _runtime;
  bool _attached = false;

  ComponentRuntime get runtime {
    final r = _runtime;
    if (r == null) {
      throw StateError('Component is not Mounted');
    }
    return r;
  }

  List<Stylesheet> get styles => const [];

  void attach(ComponentRuntime runtime) {
    if (_attached) return;

    _attached = true;
    _runtime = runtime;

    for (final style in styles) {
      runtime.styles.use(style);
    }

    onMount();
  }

  void onMount() {}
  void onUnmount() {}
  void onUpdate() {}

  void setState(void Function() updater) {
    updater();
    update();
  }

  void update() {
    runtime.requestUpdate();
  }

  PulsarNode render();
}
