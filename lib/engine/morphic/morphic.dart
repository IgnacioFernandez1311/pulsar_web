import 'package:pulsar_web/pulsar.dart';

// lib/core/morphic.dart

/// Base type for all morphable nodes in Pulsar.
///
/// A Morphic represents a piece of UI that can evolve (morph)
/// over time without being recreated.
sealed class Morphic {
  final Object? key;
  const Morphic({this.key});
}

/// Text content node
final class TextMorphic extends Morphic {
  final String value;

  const TextMorphic(this.value, {super.key});

  @override
  bool operator ==(Object other) =>
      other is TextMorphic && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// HTML element node
final class ElementMorphic extends Morphic {
  final String tag;
  final Map<String, Attribute> attributes;
  final List<Object> children; // 🔑 Object en lugar de dynamic

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

// ComponentNode ELIMINADO - Components se resuelven directamente
