// lib/core/fragment.dart

import 'package:pulsar_web/pulsar.dart';

/// A grouping element that renders no DOM node.
///
/// [Fragment] follows the same fluent call() API as every other
/// [ElementBuilder] in Pulsar — but instead of producing an [ElementMorphic]
/// with a tag, it produces a [FragmentMorphic] whose children are inserted
/// directly as siblings into the parent DOM node.
///
/// This makes [Fragment] the correct tool whenever you need to return
/// multiple nodes from a getter or conditional without adding a wrapper
/// element to the HTML output.
///
/// ## Usage
///
/// ```dart
/// // In a getter — multiple siblings without a wrapper div
/// Morphic get actions => Fragment()([
///   Button().onClick(save)(['Save']),
///   Button().onClick(cancel)(['Cancel']),
/// ]);
///
/// // In render() with a conditional
/// @override
/// Morphic render() => Div()([
///   H1()(['Title']),
///   if (isExpanded) details,  // details is a Fragment
/// ]);
/// ```
///
/// ## What Fragment is NOT
///
/// Fragment is not a performance optimization. It is a structural tool.
/// Use it when the absence of a wrapper element is semantically meaningful
/// (e.g. inside a `<ul>` where only `<li>` children are valid, or inside
/// a flex container where an extra div would break layout).
///
/// If a wrapper element is acceptable, prefer a plain [Div] or [Span].
final class Fragment {
  final Object? key;

  const Fragment({this.key});

  /// Produces a [FragmentMorphic] containing [children].
  ///
  /// Children follow the same normalization rules as [ElementBuilder]:
  /// strings become [TextMorphic], numbers become [TextMorphic],
  /// [Morphic] nodes are included as-is, and nested [Iterable]s are flattened.
  FragmentMorphic call([List<dynamic>? children]) {
    final normalized = _normalizeChildren(children ?? const []);
    return FragmentMorphic(children: normalized, key: key);
  }

  List<Morphic> _normalizeChildren(List<dynamic> children) {
    final result = <Morphic>[];

    for (final child in children) {
      if (child == null) {
        continue;
      } else if (child is String) {
        result.add(TextMorphic(child));
      } else if (child is num) {
        result.add(TextMorphic(child.toString()));
      } else if (child is Morphic) {
        result.add(child);
      } else if (child is Iterable) {
        result.addAll(_normalizeChildren(child.toList()));
      } else {
        throw ArgumentError(
          'Invalid Fragment child type: ${child.runtimeType}. '
          'Expected String, num, Morphic, Iterable, or null.',
        );
      }
    }

    return result;
  }
}
