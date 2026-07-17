import 'package:pulsar_web/pulsar.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  Component? rootComponent;
  Morphic? _currentTree;
  bool _mounted = false;

  final Map<Component, Morphic> _componentTrees = {};
  final Map<Component, Node> _componentNodes = {};

  ComponentRuntime(this.renderer);

  // Lifecycle
  void mount(Component root) {
    if (_mounted) {
      throw StateError('ComponentRuntime is already mounted');
    }

    rootComponent = root;
    root.attach(this);

    RenderContext.run(this, () {
      // Phase 1 — resolve the Morphic tree.
      // resolveNode returns a typed ResolveResult — success or failure is
      // explicit, never hidden in exception propagation.
      final result = resolveNode(ComponentRenderNode(root));

      switch (result) {
        case ResolveSuccess(:final tree, :final owners):
          _currentTree = tree;
          _componentTrees[root] = tree;

          // Phase 2 — create the real DOM.
          // owners is passed explicitly so createDom can register each
          // component's root DOM node without touching shared mutable state.
          final dom = createDom(tree, componentOwner: root, owners: owners);
          _componentNodes[root] = dom;

          renderer.mount(tree);
          _mounted = true;

        case ResolveFailure(
          :final error,
          :final stackTrace,
          :final failedComponent,
        ):
          throw StateError(
            'Failed to mount '
            '${failedComponent?.runtimeType ?? root.runtimeType}: '
            '$error\n$stackTrace',
          );
      }
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

  // Update

  /// Granular update — re-renders and diffs only [component]'s subtree.
  /// The browser only sees changes inside the single DOM node that belongs
  /// to [component]. Nothing outside it is touched.
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
        final result = resolveNode(ComponentRenderNode(component));

        switch (result) {
          case ResolveSuccess(:final tree):
            patch(domNode, prevTree, tree);
            _componentTrees[component] = tree;
            component.onMorph();

          case ResolveFailure(:final error, :final failedComponent):
            // Granular update failure is non-fatal — the component stays in
            // its last valid state. Log and continue.
            // ignore: avoid_print
            print(
              'Pulsar: morph failed for '
              '${failedComponent?.runtimeType ?? component.runtimeType}: '
              '$error',
            );
        }
      });
    });
  }

  void _requestRootUpdate() {
    if (!_mounted) return;

    RenderContext.run(this, () {
      final result = resolveNode(ComponentRenderNode(rootComponent!));

      switch (result) {
        case ResolveSuccess(:final tree):
          renderer.update(_currentTree!, tree);
          _currentTree = tree;
          _componentTrees[rootComponent!] = tree;
          rootComponent?.onMorph();

        case ResolveFailure(:final error):
          // ignore: avoid_print
          print('Pulsar: root update failed: $error');
      }
    });
  }

  // Registry
  void registerComponentTree(Component component, Morphic tree) {
    // Always update — putIfAbsent would leave child components with a stale
    // prevTree after a parent morph, causing the next requestUpdateFor to
    // diff against the wrong snapshot.
    _componentTrees[component] = tree;
  }

  void registerComponentDomNode(Component component, Node dom) {
    // DOM nodes never change while a component is mounted.
    _componentNodes.putIfAbsent(component, () => dom);
  }

  void unregisterComponent(Component component) {
    _componentNodes.remove(component);
    _componentTrees.remove(component);
  }
}

// resolveNode

/// Resolves a [RenderNode] into a fully resolved [Morphic] tree.
///
/// Returns a [ResolveResult] — success or failure is explicit in the type.
/// The [owners] map in [ResolveSuccess] pairs each component's root [Morphic]
/// to its [Component], built here and passed to [createDom] explicitly so
/// DOM registration requires no shared mutable state.
///
/// ## Two-phase separation
///
/// This function never creates DOM. [createDom] never resolves components.
/// Keeping these phases separate ensures that each component's registered
/// DOM node is always the exact node inserted into the document.
ResolveResult resolveNode(RenderNode node) {
  final owners = <Morphic, Component>{};
  try {
    final tree = _resolve(node, owners);
    return ResolveSuccess(tree, owners);
  } catch (e, st) {
    final failed = node is ComponentRenderNode ? node.component : null;
    return ResolveFailure(error: e, stackTrace: st, failedComponent: failed);
  }
}

Morphic _resolve(RenderNode node, Map<Morphic, Component> owners) {
  return switch (node) {
    ComponentRenderNode(:final component) => _resolveComponent(
      component,
      owners,
    ),
    MorphicRenderNode(:final morphic) => _resolveMorphic(morphic, owners),
    TextRenderNode(:final value) => TextMorphic(value),
    NumberRenderNode(:final value) => TextMorphic(value.toString()),
  };
}

Morphic _resolveComponent(Component component, Map<Morphic, Component> owners) {
  component.attach(RenderContext.runtime);

  final rendered = RenderContext.runWithComponent(component, () {
    return component.render();
  });

  final resolved = _resolveMorphic(rendered, owners);

  // Register tree snapshot and owner mapping.
  RenderContext.runtime.registerComponentTree(component, resolved);
  owners[resolved] = component;

  return resolved;
}

Morphic _resolveMorphic(Morphic morphic, Map<Morphic, Component> owners) {
  return switch (morphic) {
    TextMorphic() => morphic,

    FragmentMorphic(:final children, :final key) => FragmentMorphic(
      children: _resolveChildren(children, owners),
      key: key,
    ),

    ElementMorphic(
      :final tag,
      :final attributes,
      :final children,
      :final key,
    ) =>
      ElementMorphic(
        tag: tag,
        attributes: attributes,
        children: _resolveChildren(children, owners),
        key: key,
      ),
  };
}

/// Converts [List<Object>] children (which may contain [Component] instances
/// alongside [Morphic] nodes) into a fully resolved [List<Morphic>].
///
/// Each child is wrapped in the appropriate [RenderNode] variant and passed
/// to [_resolve]. If an unexpected type survives past [MorphicChildren.normalize],
/// a clear [StateError] is thrown — it is a bug in the normalization layer,
/// not an unknown user input.
List<Morphic> _resolveChildren(
  List<Object> children,
  Map<Morphic, Component> owners,
) {
  final resolved = <Morphic>[];

  for (final child in children) {
    final node = switch (child) {
      Component c => ComponentRenderNode(c),
      Morphic m => MorphicRenderNode(m),
      String s => TextRenderNode(s),
      num n => NumberRenderNode(n),
      _ => throw StateError(
        'Unexpected child type after normalization: ${child.runtimeType}. '
        'This is a bug in MorphicChildren.normalize.',
      ),
    };
    resolved.add(_resolve(node, owners));
  }

  return resolved;
}
