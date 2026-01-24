import 'package:pulsar_web/core/component.dart';
import 'package:pulsar_web/engine/node/node.dart';
import 'package:pulsar_web/engine/renderer/renderer.dart';
import 'package:pulsar_web/engine/stylesheet/style_registry.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  Component? _rootComponent;
  PulsarNode? _currentTree;
  bool _mounted = false;

  ComponentRuntime(this.renderer);

  /// Montaje inicial
  void mount(Component root) {
    if (_mounted) {
      throw StateError('ComponentRuntime is already mounted');
    }

    _rootComponent = root;
    root.attach(this);

    final tree = root.render();

    renderer.mount(tree);
    _currentTree = tree;
    _mounted = true;
  }

  /// Pedido de actualización desde un Component
  void requestUpdate(Component component) {
    if (!_mounted) {
      throw StateError('ComponentRuntime is not mounted');
    }

    // Por ahora, solo permitimos update del root
    if (component != _rootComponent) return;

    final prevTree = _currentTree!;
    final nextTree = component.render();

    renderer.update(prevTree, nextTree);
    _currentTree = nextTree;
  }
}
