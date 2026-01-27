import 'package:pulsar_web/engine/runtime/component_runtime.dart';

final class RenderContext {
  static ComponentRuntime? _current;

  static ComponentRuntime get runtime {
    final r = _current;
    if (r == null) {
      throw StateError('No active RenderContext');
    }
    return r;
  }

  static T run<T>(ComponentRuntime runtime, T Function() callback) {
    final prev = _current;
    _current = runtime;
    try {
      return callback();
    } finally {
      _current = prev;
    }
  }
}
