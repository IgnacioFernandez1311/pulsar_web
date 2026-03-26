import 'package:pulsar_web/engine/runtime/component_runtime.dart';
import 'package:pulsar_web/pulsar.dart';

class RenderContext {
  static ComponentRuntime? _runtime;
  static Component? _currentComponent;

  static ComponentRuntime get runtime {
    final r = _runtime;
    if (r == null) {
      throw StateError('No RenderContext active');
    }
    return r;
  }

  static Component? get currentComponent => _currentComponent;

  static T run<T>(ComponentRuntime runtime, T Function() fn) {
    final previous = _runtime;
    final previousComponent = _currentComponent;

    _runtime = runtime;

    try {
      return fn();
    } finally {
      _runtime = previous;
      _currentComponent = previousComponent;
    }
  }

  // 🔑 FIX: runWithComponent mantiene el runtime actual
  static T runWithComponent<T>(Component component, T Function() fn) {
    final previous = _currentComponent;
    _currentComponent = component;

    try {
      return fn();
    } finally {
      _currentComponent = previous;
    }
    // NOTE: NO tocamos _runtime, se mantiene del contexto parent
  }
}
