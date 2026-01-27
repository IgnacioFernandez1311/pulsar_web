import 'package:pulsar_web/pulsar.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  final ComponentRuntime? parent;
  final List<ComponentRuntime> children = [];

  Component? rootComponent;
  PulsarNode? _currentTree;
  bool _mounted = false;

  ComponentRuntime(this.renderer, {this.parent});

  /// Montaje inicial
  void mount(Component root) {
    if (_mounted) {
      throw StateError('ComponentRuntime is already mounted');
    }

    rootComponent = root;
    root.attach(this);

    RenderContext.run(this, () {
      final rawTree = root.render();
      final tree = resolveNode(rawTree);
      _currentTree = tree;
      renderer.mount(tree);
      _mounted = true;
    });
  }

  /// Pedido de actualización desde un Component
  void requestUpdate(Component component) {
    if (!_mounted) {
      throw StateError('ComponentRuntime is not mounted');
    }

    RenderContext.run(this, () {
      final rawTree = rootComponent!.render();
      final nextTree = resolveNode(rawTree);
      renderer.update(_currentTree!, nextTree);
      _currentTree = nextTree;
    });
  }
}

PulsarNode resolveNode(PulsarNode node) {
  if (node is ComponentNode) {
    node.component.attach(RenderContext.runtime);
    return resolveNode(node.component.render());
  }

  if (node is ElementNode) {
    return ElementNode(
      tag: node.tag,
      attributes: node.attributes,
      children: node.children.map(resolveNode).toList(),
      key: node.key,
    );
  }

  return node; // TextNode
}
