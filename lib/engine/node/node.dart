import 'package:pulsar_web/pulsar.dart';

sealed class PulsarNode {
  final Object? key;
  const PulsarNode({this.key});
}

final class TextNode extends PulsarNode {
  final String value;
  const TextNode(this.value, {super.key});

  @override
  bool operator ==(Object other) => other is TextNode && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

final class ElementNode extends PulsarNode {
  final String tag;
  final Map<String, Attribute> attributes;
  final List<PulsarNode> children;

  const ElementNode({
    required this.tag,
    this.attributes = const {},
    this.children = const [],
    super.key,
  });

  @override
  bool operator ==(Object other) {
    if (other is! ElementNode) return false;
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

final class ComponentNode extends PulsarNode {
  final Component component;

  PulsarNode? rendered;

  ComponentNode({required this.component, super.key});

  PulsarNode render() {
    rendered = component.render();
    return rendered!;
  }
}
