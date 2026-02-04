import 'package:pulsar_web/pulsar.dart';

// ==============================
// Core
// ==============================

typedef Children = List<PulsarNode>;

ElementNode el(
  String tag, {
  Object? key,
  Map<String, Attribute>? attrs,
  String? classes,
  Map<String, String>? style,
  EventCallback? onClick,
  Children children = const [],
}) {
  final attributes = <String, Attribute>{};

  if (classes != null) {
    attributes['class'] = ClassAttribute(classes);
  }

  if (style != null) {
    attributes['style'] = StyleAttribute(style);
  }

  if (onClick != null) {
    attributes['onClick'] = EventAttribute(onClick);
  }

  if (attrs != null) {
    attributes.addAll(attrs);
  }

  return ElementNode(
    tag: tag,
    key: key,
    attributes: attributes,
    children: children,
  );
}

typedef HtmlBuilder =
    ElementNode Function({
      Object? key,
      Map<String, Attribute>? attrs,
      String? classes,
      Map<String, String>? style,
      EventCallback? onClick,
      Children children,
    });

HtmlBuilder tag(String name) {
  return ({
    Object? key,
    Map<String, Attribute>? attrs,
    String? classes,
    Map<String, String>? style,
    EventCallback? onClick,
    Children children = const [],
  }) {
    return el(
      name,
      key: key,
      attrs: attrs,
      classes: classes,
      style: style,
      onClick: onClick,
      children: children,
    );
  };
}

// ==============================
// Text
// ==============================

TextNode text(String value, {Object? key}) => TextNode(value, key: key);

// ==============================
// Generic tags
// ==============================

final div = tag('div');
final span = tag('span');
final p = tag('p');
final hr = tag('hr');
final section = tag('section');
final header = tag('header');
final footer = tag('footer');
final mainTag = tag('main');
final article = tag('article');
final nav = tag('nav');
final ul = tag('ul');
final ol = tag('ol');
final li = tag('li');
final h1 = tag('h1');
final h2 = tag('h2');
final h3 = tag('h3');
final h4 = tag('h4');
final h5 = tag('h5');
final h6 = tag('h6');
final button = tag('button');
final textarea = tag('textarea');
final label = tag('label');
final pre = tag('pre');
final code = tag('code');

// ==============================
// Specialized tags
// ==============================

// ---- <a>
ElementNode a({
  Object? key,
  required String href,
  String? target,
  String? rel,
  bool download = false,

  String? classes,
  Map<String, String>? style,
  EventCallback? onClick,
  Map<String, Attribute>? attrs,

  Children children = const [],
}) {
  return el(
    'a',
    key: key,
    classes: classes,
    style: style,
    onClick: onClick,
    attrs: {
      'href': StringAttribute(href),
      if (target != null) 'target': StringAttribute(target),
      if (rel != null) 'rel': StringAttribute(rel),
      if (download) 'download': BooleanAttribute(true),
      ...?attrs,
    },
    children: children,
  );
}

// ---- <img>
ElementNode img({
  Object? key,
  required String src,
  String? alt,
  int? width,
  int? height,
  bool lazy = false,

  String? classes,
  Map<String, String>? style,
  Map<String, Attribute>? attrs,
}) {
  return el(
    'img',
    key: key,
    classes: classes,
    style: style,
    attrs: {
      'src': StringAttribute(src),
      if (alt != null) 'alt': StringAttribute(alt),
      if (width != null) 'width': StringAttribute(width.toString()),
      if (height != null) 'height': StringAttribute(height.toString()),
      if (lazy) 'loading': StringAttribute('lazy'),
      ...?attrs,
    },
    children: const [],
  );
}

// ---- <input>
ElementNode input({
  Object? key,
  String type = 'text',
  String? value,
  String? placeholder,
  bool disabled = false,

  String? classes,
  Map<String, String>? style,
  EventCallback? onInput,
  Map<String, Attribute>? attrs,
}) {
  return el(
    'input',
    key: key,
    classes: classes,
    style: style,
    onClick: onInput,
    attrs: {
      'type': StringAttribute(type),
      if (value != null) 'value': StringAttribute(value),
      if (placeholder != null) 'placeholder': StringAttribute(placeholder),
      if (disabled) 'disabled': BooleanAttribute(true),
      ...?attrs,
    },
    children: const [],
  );
}

// ---- <form>
ElementNode form({
  Object? key,
  String? action,
  String method = 'get',

  String? classes,
  Map<String, String>? style,
  EventCallback? onSubmit,
  Map<String, Attribute>? attrs,

  Children children = const [],
}) {
  return el(
    'form',
    key: key,
    classes: classes,
    style: style,
    onClick: onSubmit,
    attrs: {
      if (action != null) 'action': StringAttribute(action),
      'method': StringAttribute(method),
      ...?attrs,
    },
    children: children,
  );
}

// ---- <meta>
ElementNode meta({
  String? name,
  String? content,
  String? charset,
  String? httpEquiv,
}) {
  return el(
    'meta',
    attrs: {
      if (name != null) 'name': StringAttribute(name),
      if (content != null) 'content': StringAttribute(content),
      if (charset != null) 'charset': StringAttribute(charset),
      if (httpEquiv != null) 'http-equiv': StringAttribute(httpEquiv),
    },
    children: const [],
  );
}

// ---- <link>
ElementNode link({
  required String rel,
  required String href,
  String? type,
  String? media,
}) {
  return el(
    'link',
    attrs: {
      'rel': StringAttribute(rel),
      'href': StringAttribute(href),
      if (type != null) 'type': StringAttribute(type),
      if (media != null) 'media': StringAttribute(media),
    },
    children: const [],
  );
}

// ---- <script>
ElementNode script({
  String? src,
  bool async = false,
  bool defer = false,
  String? type,
  String? content,
}) {
  return el(
    'script',
    attrs: {
      if (src != null) 'src': StringAttribute(src),
      if (type != null) 'type': StringAttribute(type),
      if (async) 'async': BooleanAttribute(true),
      if (defer) 'defer': BooleanAttribute(true),
    },
    children: content != null ? [text(content)] : const [],
  );
}
