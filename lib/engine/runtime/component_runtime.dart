// lib/engine/runtime/component_runtime.dart

import 'package:pulsar_web/pulsar.dart';

final class ComponentRuntime {
  final Renderer renderer;
  final StyleRegistry styles = StyleRegistry();

  Component? rootComponent;
  Morphic? _currentTree;
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

    renderer.unmount();
    rootComponent = null;
    _currentTree = null;
    _mounted = false;
  }

  /// Update global (triggers morphing)
  void requestUpdate() {
    if (!_mounted) return;

    RenderContext.run(this, () {
      final nextTree = resolveNode(rootComponent!.render());
      renderer.update(_currentTree!, nextTree);
      _currentTree = nextTree;
      rootComponent?.onMorph();
    });
  }
}

/// Resolve a Morphic tree, expanding any Components found.
///
/// Components are NOT nodes - they produce nodes.
/// This function recursively resolves Components to their
/// rendered Morphic output.
Morphic resolveNode(dynamic node) {
  // Component → attach y resolve to Morphic
  if (node is Component) {
    node.attach(RenderContext.runtime);

    final rendered = RenderContext.runWithComponent(node, () {
      return node.render();
    });

    return resolveNode(rendered);
  }

  // ElementMorphic → resolve children recursively
  if (node is ElementMorphic) {
    final resolvedChildren = <Morphic>[]; // 🔑 Garantizamos List<Morphic>

    for (final child in node.children) {
      // child puede ser Component, Morphic, String, etc.
      try {
        final resolved = resolveNode(child);
        resolvedChildren.add(resolved);
      } catch (e) {
        // Skip invalid children
        continue;
      }
    }

    // 🔑 Retornar ElementMorphic con children resueltos (List<Morphic>)
    // Pero el tipo es List<Object> para compatibilidad
    return ElementMorphic(
      tag: node.tag,
      attributes: node.attributes,
      children: resolvedChildren, // List<Morphic> es subtipo de List<Object>
      key: node.key,
    );
  }

  // TextMorphic → no resolution needed
  if (node is TextMorphic) {
    return node;
  }

  // String → convert to TextMorphic
  if (node is String) {
    return TextMorphic(node);
  }

  throw UnsupportedError('Unknown node type: ${node.runtimeType}');
}
