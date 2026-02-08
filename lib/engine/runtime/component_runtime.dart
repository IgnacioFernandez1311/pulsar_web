import 'package:pulsar_web/pulsar.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  Component? rootComponent;
  PulsarNode? _currentTree;
  bool _mounted = false;

  ComponentRuntime(this.renderer);

  void mount(Component root) {
    if (_mounted) {
      throw StateError('ComponentRuntime is already mounted');
    }

    rootComponent = root;
    root.attach(this);

    RenderContext.run(this, () {
      final tree = resolveNode(root.render());
      _currentTree = tree;
      renderer.mount(tree);
      _mounted = true;
    });
  }

  void unmount() {
    if (!_mounted) return;

    rootComponent?.onUnmount();
    renderer.unmount();

    rootComponent = null;
    _currentTree = null;
    _mounted = false;
  }

  /// 🔑 UPDATE GLOBAL
  void requestUpdate() {
    if (!_mounted) return;

    RenderContext.run(this, () {
      final nextTree = resolveNode(rootComponent!.render());
      renderer.update(_currentTree!, nextTree);
      _currentTree = nextTree;
      rootComponent?.onUpdate();
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
