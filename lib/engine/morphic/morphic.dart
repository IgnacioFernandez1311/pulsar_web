import 'package:pulsar_web/pulsar.dart';

/// Base type for all morphable nodes in Pulsar.
///
/// A Morphic represents a piece of UI that can evolve (morph)
/// over time without being recreated.
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
/// as siblings into the parent DOM node. It is the Morphic representation
/// of [Fragment] — a way to group multiple nodes without introducing a
/// wrapper element in the HTML output.
///
/// ## Example
///
/// ```dart
/// // Fragment in render() — no extra div wrapper in the DOM
/// Fragment()([
///   Span()(['First']),
///   Span()(['Second']),
/// ])
/// ```
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
