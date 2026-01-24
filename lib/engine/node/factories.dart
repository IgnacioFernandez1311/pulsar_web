import './node.dart';
import '../attribute/attribute.dart';

TextNode text(String value) => TextNode(value);

ElementNode el(
  String tag, {
  Object? key,
  String? classes,
  Map<String, String>? style,
  Map<String, Attribute>? attrs = const {},
  List<PulsarNode> children = const [],
}) {
  final merged = <String, Attribute>{};

  if (attrs != null) merged.addAll(attrs);

  if (classes != null) {
    merged['class'] = ClassAttribute(classes);
  }

  if (style != null) {
    merged['style'] = StyleAttribute(style);
  }

  return ElementNode(
    tag: tag,
    attributes: merged,
    children: children,
    key: key,
  );
}

ElementNode div({
  Object? key,
  String? classes,
  Map<String, String>? style,
  Map<String, Attribute> attrs = const {},
  List<PulsarNode> children = const [],
}) => el(
  'div',
  attrs: attrs,
  children: children,
  key: key,
  classes: classes,
  style: style,
);

ElementNode button({
  Object? key,
  String? classes,
  Map<String, String>? style,
  Map<String, Attribute> attrs = const {},
  List<PulsarNode> children = const [],
}) => el(
  'button',
  attrs: attrs,
  children: children,
  key: key,
  classes: classes,
  style: style,
);
