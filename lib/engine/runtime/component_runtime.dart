import 'package:pulsar_web/pulsar.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  Component? rootComponent;
  Morphic? _currentTree;
  bool _mounted = false;

  /// Maps each mounted Component to its current resolved Morphic tree.
  /// Used as the "prev" snapshot for local diffing on morph.
  final Map<Component, Morphic> _componentTrees = {};

  /// Maps each mounted Component to its root DOM node.
  /// patch() operates directly on this node — no traversal needed.
  final Map<Component, Node> _componentNodes = {};

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
      // resolveNode registers each Component's tree as it recurses.
      // createDom registers each Component's DOM node as it recurses.
      final tree = resolveNode(root.render(), owner: root);
      _currentTree = tree;

      final dom = createDom(tree, componentOwner: root);
      _componentTrees[root] = tree;
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
    _mounted = false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Update
  // ─────────────────────────────────────────────────────────────────────────

  /// Granular update — re-renders and diffs only [component]'s subtree.
  ///
  /// This is the primary update path. It never touches the root tree or
  /// any sibling component. The browser only sees changes inside the
  /// single DOM node that belongs to [component].
  void requestUpdateFor(Component component) {
    if (!_mounted) return;

    if (component == rootComponent) {
      _requestRootUpdate();
      return;
    }

    final domNode = _componentNodes[component];
    final prevTree = _componentTrees[component];

    // Not yet registered: component called morph() before its first
    // resolveNode pass completed. Fall back gracefully.
    if (domNode == null || prevTree == null) {
      _requestRootUpdate();
      return;
    }

    RenderContext.run(this, () {
      RenderContext.runWithComponent(component, () {
        final nextTree = resolveNode(component.render(), owner: component);

        // Diff directly against the component's own DOM node.
        // No other part of the DOM is examined or mutated.
        patch(domNode, prevTree, nextTree);

        _componentTrees[component] = nextTree;
        component.onMorph();
      });
    });
  }

  /// Full-tree update. Only used for the root component and as a safety
  /// fallback. In normal operation every morph goes through [requestUpdateFor].
  void _requestRootUpdate() {
    if (!_mounted) return;

    RenderContext.run(this, () {
      final nextTree = resolveNode(
        rootComponent!.render(),
        owner: rootComponent!,
      );
      renderer.update(_currentTree!, nextTree);
      _currentTree = nextTree;
      _componentTrees[rootComponent!] = nextTree;
      rootComponent?.onMorph();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Registry — internal, called by resolveNode and createDom
  // ─────────────────────────────────────────────────────────────────────────

  /// Stores the Morphic tree for a component.
  /// Called by [resolveNode] as soon as a component's render output is resolved.
  void registerComponentTree(Component component, Morphic tree) {
    _componentTrees.putIfAbsent(component, () => tree);
  }

  /// Stores the root DOM node for a component.
  /// Called by [createDom] once the Element for a component's root is created.
  void registerComponentDomNode(Component component, Node dom) {
    _componentNodes.putIfAbsent(component, () => dom);
  }

  void unregisterComponent(Component component) {
    _componentNodes.remove(component);
    _componentTrees.remove(component);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// resolveNode
// ─────────────────────────────────────────────────────────────────────────────

/// Resolves a Morphic tree, expanding any [Component] instances found.
///
/// The optional [owner] parameter identifies which [Component] is responsible
/// for the top-level node being resolved. It is only meaningful at the call
/// site in [ComponentRuntime.mount] and [requestUpdateFor] — it should NOT be
/// forwarded when recursing into children, because each child [Component] will
/// register itself independently when the recursion reaches it.
Morphic resolveNode(dynamic node, {Component? owner}) {
  // ── Component ────────────────────────────────────────────────────────────
  if (node is Component) {
    node.attach(RenderContext.runtime);

    final rendered = RenderContext.runWithComponent(node, () {
      return node.render();
    });

    // Resolve the component's own subtree. The component is the owner of
    // its render output — not whatever called resolveNode on it.
    final resolved = resolveNode(rendered, owner: node);

    // Register the tree. The matching DOM node will arrive via createDom.
    RenderContext.runtime.registerComponentTree(node, resolved);

    // Create and register the DOM node immediately, while we still know
    // which component this subtree belongs to.
    final dom = createDom(resolved, componentOwner: node);
    RenderContext.runtime.registerComponentDomNode(node, dom);

    return resolved;
  }

  // ── ElementMorphic ───────────────────────────────────────────────────────
  if (node is ElementMorphic) {
    final resolvedChildren = <Morphic>[];

    for (final child in node.children) {
      try {
        // Do not forward owner — children register themselves.
        final resolved = resolveNode(child);
        resolvedChildren.add(resolved);
      } catch (e) {
        continue;
      }
    }

    return ElementMorphic(
      tag: node.tag,
      attributes: node.attributes,
      children: resolvedChildren,
      key: node.key,
    );
  }

  // ── TextMorphic ──────────────────────────────────────────────────────────
  if (node is TextMorphic) {
    return node;
  }

  // ── String ───────────────────────────────────────────────────────────────
  if (node is String) {
    return TextMorphic(node);
  }

  throw UnsupportedError('Unknown node type: ${node.runtimeType}');
}
