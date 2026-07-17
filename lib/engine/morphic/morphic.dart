import 'package:pulsar_web/pulsar.dart';

// Morphic — Resolved tree

/// Base type for all morphable nodes in Pulsar.
///
/// A [Morphic] represents a piece of UI that can evolve (morph) over time
/// without being recreated. The sealed hierarchy ensures that [resolveNode]
/// and [createDom] handle every possible case exhaustively — unknown node
/// types are compile-time errors, not runtime surprises.
sealed class Morphic {
  final Object? key;
  const Morphic({this.key});
}

/// Text content node.
final class TextMorphic extends Morphic {
  final String value;

  const TextMorphic(this.value, {super.key});

  @override
  bool operator ==(Object other) =>
      other is TextMorphic && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// HTML element node.
final class ElementMorphic extends Morphic {
  final String tag;
  final Map<String, Attribute> attributes;

  /// Children are [List<Object>] to accommodate both resolved [Morphic]
  /// nodes and unresolved [Component] instances. [resolveNode] expands
  /// components into [Morphic] before the tree reaches [createDom] or
  /// [patch]. [Component] instances should never survive past resolution.
  final List<Object> children;

  const ElementMorphic({
    required this.tag,
    this.attributes = const {},
    this.children = const [],
    super.key,
  });

  @override
  bool operator ==(Object other) {
    if (other is! ElementMorphic) return false;
    return tag == other.tag &&
        _mapEquals(attributes, other.attributes) &&
        _listEquals(children, other.children);
  }

  @override
  int get hashCode => Object.hash(tag, attributes.length, children.length);

  bool _mapEquals(Map<String, Object> a, Map<String, Object> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listEquals(List<Object> a, List<Object> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// A grouping node that produces no DOM element.
///
/// [FragmentMorphic] holds a list of children that are inserted directly
/// as siblings into the parent DOM node — no wrapper element is added to
/// the HTML output.
///
/// ## Diffing
///
/// [FragmentMorphic] is preserved in the resolved tree so that
/// [_patchChildren] can diff it correctly against a previous fragment
/// at the same position, updating only the children that changed.
final class FragmentMorphic extends Morphic {
  final List<Morphic> children;

  const FragmentMorphic({required this.children, super.key});

  @override
  bool operator ==(Object other) {
    if (other is! FragmentMorphic) return false;
    if (children.length != other.children.length) return false;
    for (int i = 0; i < children.length; i++) {
      if (children[i] != other.children[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(runtimeType, children.length);
}

// ─────────────────────────────────────────────────────────────────────────────
// RenderNode — entrada tipada a resolveNode
// ─────────────────────────────────────────────────────────────────────────────

/// Everything that can appear as a child in a Pulsar render tree.
///
/// [RenderNode] replaces [dynamic] as the input type of [resolveNode].
/// The sealed hierarchy gives the compiler full exhaustiveness checking —
/// adding a new node type without updating every switch is a compile error,
/// not a runtime surprise.
sealed class RenderNode {
  const RenderNode();
}

/// A [Component] with long-lived identity.
/// Resolved by attaching, calling [Component.render], and recursing.
final class ComponentRenderNode extends RenderNode {
  final Component component;
  const ComponentRenderNode(this.component);
}

/// A [Morphic] node already produced by an [ElementBuilder] or [Fragment].
/// May still contain unresolved [Component] instances in its children.
final class MorphicRenderNode extends RenderNode {
  final Morphic morphic;
  const MorphicRenderNode(this.morphic);
}

/// Plain text — becomes a [TextMorphic] during resolution.
final class TextRenderNode extends RenderNode {
  final String value;
  const TextRenderNode(this.value);
}

/// A number — becomes a [TextMorphic] during resolution.
final class NumberRenderNode extends RenderNode {
  final num value;
  const NumberRenderNode(this.value);
}

// ─────────────────────────────────────────────────────────────────────────────
// ResolveResult — resultado tipado de resolveNode
// ─────────────────────────────────────────────────────────────────────────────

/// The result of resolving a [RenderNode] into a [Morphic] tree.
///
/// Errors are part of the model — not hidden in exception propagation.
/// This enables error boundaries in the future: a component can catch
/// [ResolveFailure] from its children and render a fallback instead of
/// crashing the whole tree.
sealed class ResolveResult {
  const ResolveResult();
}

/// Successful resolution.
///
/// [tree] is the fully resolved [Morphic] tree.
/// [owners] maps each component's root [Morphic] to its [Component] —
/// built during [resolveNode] and passed explicitly to [createDom] so that
/// component DOM nodes are registered without any shared mutable state.
final class ResolveSuccess extends ResolveResult {
  final Morphic tree;
  final Map<Morphic, Component> owners;

  const ResolveSuccess(this.tree, this.owners);
}

/// Failed resolution.
///
/// Reserved for genuine errors — bugs in a component's [render] method.
/// Expected domain outcomes (empty list, false condition) never reach here.
final class ResolveFailure extends ResolveResult {
  final Object error;
  final StackTrace stackTrace;
  final Component? failedComponent;

  const ResolveFailure({
    required this.error,
    required this.stackTrace,
    this.failedComponent,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// _ValidChild — validación exhaustiva en la frontera de entrada
// ─────────────────────────────────────────────────────────────────────────────

/// Internal sealed hierarchy for child validation.
///
/// [_ValidChild.from] converts any raw Dart value into a typed variant.
/// Unknown types are rejected at this boundary — not silently ignored
/// somewhere inside the engine. The sealed class ensures [MorphicChildren]
/// handles every case exhaustively.
sealed class _ValidChild {
  const _ValidChild();

  factory _ValidChild.from(Object child) {
    return switch (child) {
      String s => _StringChild(s),
      num n => _NumChild(n),
      bool b => _BoolChild(b),
      Morphic m => _MorphicChild(m),
      Component c => _ComponentChild(c),
      Iterable<dynamic> i => _IterableChild(i),
      Object? Function() f => _FunctionChild(f),
      _ => throw ArgumentError(
        'Invalid child type in Pulsar: ${child.runtimeType}. '
        'Allowed types: String, num, bool, Morphic, Component, '
        'Iterable, or a Function() that returns one of the above.',
      ),
    };
  }
}

final class _StringChild extends _ValidChild {
  final String v;
  const _StringChild(this.v);
}

final class _NumChild extends _ValidChild {
  final num v;
  const _NumChild(this.v);
}

final class _BoolChild extends _ValidChild {
  final bool v;
  const _BoolChild(this.v);
}

final class _MorphicChild extends _ValidChild {
  final Morphic v;
  const _MorphicChild(this.v);
}

final class _ComponentChild extends _ValidChild {
  final Component v;
  const _ComponentChild(this.v);
}

final class _IterableChild extends _ValidChild {
  final Iterable<dynamic> v;
  const _IterableChild(this.v);
}

final class _FunctionChild extends _ValidChild {
  final Object? Function() v;
  const _FunctionChild(this.v);
}

// ─────────────────────────────────────────────────────────────────────────────
// MorphicChildren — normalizador de children
// ─────────────────────────────────────────────────────────────────────────────

/// Normalizes raw Dart child values into a flat [List<Object>] suitable
/// for [ElementMorphic.children] and [FragmentMorphic.children].
///
/// ## What normalize does NOT do
///
/// It does NOT resolve [Component] instances. Components are stored as-is
/// and resolved later by [resolveNode] inside [ComponentRuntime], where the
/// [RenderContext] is active and the runtime registry is available.
/// Resolving components here would bypass the entire lifecycle system.
///
/// ## Supported child types
///
/// - [String] → [TextMorphic]
/// - [num] → [TextMorphic]
/// - [bool] → no-op (used for `condition && element` and `isOpen ?? component`)
/// - [Morphic] → stored as-is
/// - [Component] → stored as-is, resolved later by [resolveNode]
/// - [Iterable] → flattened recursively
/// - [Function()] → called, result normalized recursively
abstract final class MorphicChildren {
  static List<Object> normalize(List<dynamic>? children) {
    if (children == null || children.isEmpty) return const [];

    final result = <Object>[];

    for (final child in children) {
      if (child == null) continue;

      final valid = _ValidChild.from(child as Object);

      switch (valid) {
        case _StringChild(:final v):
          result.add(TextMorphic(v));

        case _NumChild(:final v):
          result.add(TextMorphic(v.toString()));

        case _BoolChild(:final v):
          // Used for conditional rendering patterns:
          //   isOpen ?? someComponent  →  produces bool in the list
          //   if (condition) element   →  produces true/element or nothing
          // false → skip entirely. true → no-op, the actual value follows.
          if (!v) continue;

        case _MorphicChild(:final v):
          result.add(v);

        case _ComponentChild(:final v):
          // Store without resolving. resolveNode will attach, call render(),
          // and register this component with the runtime on the next pass.
          result.add(v);

        case _IterableChild(:final v):
          result.addAll(normalize(v.toList()));

        case _FunctionChild(:final v):
          // Call the function and normalize its return value recursively.
          // Enables lazy children: () => condition ? Span()(['x']) : null
          final returned = v();
          if (returned != null) {
            result.addAll(normalize([returned]));
          }
      }
    }

    return result;
  }
}
