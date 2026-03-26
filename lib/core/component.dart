// lib/core/component.dart

import 'package:pulsar_web/engine/morphic/morphic.dart';
import 'package:pulsar_web/engine/runtime/component_runtime.dart';
import 'package:pulsar_web/engine/stylesheet/stylesheet.dart';
import 'package:pulsar_web/engine/renderer/render_context.dart';

/// Base class for all Pulsar components.
///
/// Components are long-lived objects that produce Morphic trees.
/// When state changes via setState(), the component morphs its output.
// lib/core/component.dart

abstract base class Component {
  ComponentRuntime? _runtime;
  bool attached = false;

  ComponentRuntime get runtime {
    final contextComponent = RenderContext.currentComponent;
    if (contextComponent == this) {
      return RenderContext.runtime;
    }

    final r = _runtime;
    if (r == null) {
      throw StateError('Component is not mounted');
    }
    return r;
  }

  // 🔑 NUEVO: Getter público para runtime (para event handlers)
  ComponentRuntime? get componentRuntime => _runtime;

  List<Stylesheet> get styles => const [];

  void attach(ComponentRuntime runtime) {
    if (attached) {
      if (_runtime != runtime) {
        throw StateError('Component already attached to different runtime');
      }
      return;
    }

    attached = true;
    _runtime = runtime;

    for (final style in styles) {
      runtime.styles.use(style);
    }
  }

  void detach() {
    if (!attached) return;

    attached = false;
    _runtime = null;
  }

  void onMorph() {}

  void morph(void Function() updater) {
    updater();
    update();
  }

  void update() {
    if (!attached) {
      throw StateError(
        'Cannot update: component is not mounted. '
        'Make sure component is stored as field, not created inline.',
      );
    }
    runtime.requestUpdate();
  }

  Morphic render();
}
