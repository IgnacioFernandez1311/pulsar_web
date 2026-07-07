import 'package:pulsar_web/pulsar.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  Component? rootComponent;
  Morphic? _currentTree;
  bool _mounted = false;

  final Map<Component, Morphic> _componentTrees = {};
  final Map<Component, Node> _componentNodes = {};

  /// Maps each resolved Morphic root to the Component that produced it.
  /// Built during resolveNode, consumed during createDom to register
  /// component DOM nodes without needing a second resolve pass.
  final Map<Morphic, Component> _morphicOwners = {};

  ComponentRuntime(this.renderer);

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  void mount(Component root) {
    if (_mounted) {
      throw StateError('ComponentRuntime is already mounted');
    }

    rootComponent = root;
    root.attach(this);

    RenderContext.run(this, () {
      final tree = resolveNode(root.render());
      _currentTree = tree;
      _componentTrees[root] = tree;
      _morphicOwners[tree] = root;

      final dom = createDom(tree, componentOwner: root);
      _componentNodes[root] = dom;

      renderer.mount(tree);
      _mounted = true;
    });
  }

  void unmount() {
    if (!_mounted) return;

    renderer.unmount();
    rootComponent = null;
    _currentTree = null;
    _componentTrees.clear();
    _componentNodes.clear();
    _morphicOwners.clear();
    _mounted = false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Update
  // ─────────────────────────────────────────────────────────────────────────

  void requestUpdateFor(Component component) {
    if (!_mounted) return;

    if (component == rootComponent) {
      _requestRootUpdate();
      return;
    }

    final domNode = _componentNodes[component];
    final prevTree = _componentTrees[component];

    if (domNode == null || prevTree == null) {
      _requestRootUpdate();
      return;
    }

    RenderContext.run(this, () {
      RenderContext.runWithComponent(component, () {
        final nextTree = resolveNode(component.render());
        patch(domNode, prevTree, nextTree);
        _componentTrees[component] = nextTree;
        component.onMorph();
      });
    });
  }

  void _requestRootUpdate() {
    if (!_mounted) return;

    RenderContext.run(this, () {
      final nextTree = resolveNode(rootComponent!.render());
      renderer.update(_currentTree!, nextTree);
      _currentTree = nextTree;
      _componentTrees[rootComponent!] = nextTree;
      rootComponent?.onMorph();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Registry
  // ─────────────────────────────────────────────────────────────────────────

  void registerComponentTree(Component component, Morphic tree) {
    _componentTrees.putIfAbsent(component, () => tree);
    _morphicOwners.putIfAbsent(tree, () => component);
  }

  void registerComponentDomNode(Component component, Node dom) {
    _componentNodes.putIfAbsent(component, () => dom);
  }

  Component? ownerOf(Morphic tree) => _morphicOwners[tree];

  void unregisterComponent(Component component) {
    _componentNodes.remove(component);
    _componentTrees.remove(component);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// resolveNode
// ─────────────────────────────────────────────────────────────────────────────

/// Resolves a Morphic tree by expanding all [Component] instances found.
///
/// [FragmentMorphic] nodes are preserved in the resolved tree — they are
/// NOT flattened here. Flattening happens at the DOM level in [createDom]
/// and [_patchChildren] in diff.dart, where the parent element context is
/// available. Preserving fragments in the resolved tree lets the differ
/// compare prev/next fragments at the same position accurately.
Morphic resolveNode(dynamic node) {
  // ── Component ────────────────────────────────────────────────────────────
  if (node is Component) {
    node.attach(RenderContext.runtime);

    final rendered = RenderContext.runWithComponent(node, () {
      return node.render();
    });

    final resolved = resolveNode(rendered);
    RenderContext.runtime.registerComponentTree(node, resolved);
    return resolved;
  }

  // ── FragmentMorphic ──────────────────────────────────────────────────────
  if (node is FragmentMorphic) {
    final resolvedChildren = <Morphic>[];
    for (final child in node.children) {
      resolvedChildren.add(resolveNode(child));
    }
    return FragmentMorphic(children: resolvedChildren, key: node.key);
  }

  // ── ElementMorphic ───────────────────────────────────────────────────────
  if (node is ElementMorphic) {
    final resolvedChildren = <Morphic>[];
    for (final child in node.children) {
      if (child == null) continue;
      final resolved = resolveNode(child);
      resolvedChildren.add(resolved);
    }
    return ElementMorphic(
      tag: node.tag,
      attributes: node.attributes,
      children: resolvedChildren,
      key: node.key,
    );
  }

  // ── Primitives ───────────────────────────────────────────────────────────
  if (node is TextMorphic) return node;
  if (node is String) return TextMorphic(node);
  if (node is int || node is double) return TextMorphic(node.toString());

  throw UnsupportedError('Unknown node type: ${node.runtimeType}');
}
