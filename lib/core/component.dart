import 'package:pulsar_web/engine/node/node.dart';
import 'package:pulsar_web/engine/runtime/component_runtime.dart';
import 'package:pulsar_web/engine/stylesheet/stylesheet.dart';

abstract class Component {
  ComponentRuntime? _runtime;

  List<Stylesheet> get styles => const [];

  void attach(ComponentRuntime runtime) {
    _runtime = runtime;

    for (final Stylesheet style in styles) {
      runtime.styles.use(style);
    }
  }

  void setState(void Function() updater) {
    updater();
    update();
  }

  void update() {
    final runtime = _runtime;
    if (runtime == null) {
      throw StateError(
        'Component is not mounted. Did you forget to call mountApp()?',
      );
    }
    runtime.requestUpdate(this);
  }

  PulsarNode render();
}
