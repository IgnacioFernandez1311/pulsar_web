import 'package:pulsar_web/pulsar.dart';

TextNode text(String value) => TextNode(value);

typedef HtmlBuilder =
    ElementNode Function({
      Object? key,
      String? classes,
      EventCallback? onClick,
      EventCallback? onDoubleClick,
      EventCallback? onMouseEnter,
      EventCallback? onMouseLeave,
      EventCallback? onMouseMove,
      EventCallback? onMouseDown,
      EventCallback? onMouseUp,
      EventCallback? onFocus,
      EventCallback? onBlur,
      EventCallback? onKeyDown,
      EventCallback? onKeyUp,
      EventCallback? onInput,
      EventCallback? onChange,
      Map<String, String>? style,
      Map<String, Attribute> attrs,
      List<PulsarNode> children,
    });

HtmlBuilder tag(String name) =>
    ({
      Object? key,
      String? classes,
      EventCallback? onClick,
      EventCallback? onDoubleClick,
      EventCallback? onMouseEnter,
      EventCallback? onMouseLeave,
      EventCallback? onMouseMove,
      EventCallback? onMouseDown,
      EventCallback? onMouseUp,
      EventCallback? onFocus,
      EventCallback? onBlur,
      EventCallback? onKeyDown,
      EventCallback? onKeyUp,
      EventCallback? onInput,
      EventCallback? onChange,
      EventCallback? onSubmit,
      Map<String, String>? style,
      String? id,
      String? title,
      String? role,
      int? tabIndex,
      bool? hidden,

      // Accessibility
      String? ariaLabel,
      String? ariaRole,
      bool? ariaHidden,

      // Data
      Map<String, String>? data,
      Map<String, Attribute> attrs = const {},
      List<PulsarNode> children = const [],
    }) => el(
      name,
      key: key,
      classes: classes,
      onClick: onClick,
      onDoubleClick: onDoubleClick,
      onMouseEnter: onMouseEnter,
      onMouseLeave: onMouseLeave,
      onMouseMove: onMouseMove,
      onMouseDown: onMouseDown,
      onMouseUp: onMouseUp,
      onFocus: onFocus,
      onBlur: onBlur,
      onKeyDown: onKeyDown,
      onKeyUp: onKeyUp,
      onInput: onInput,
      onChange: onChange,
      onSubmit: onSubmit,
      style: style,
      id: id,
      title: title,
      role: role,
      tabIndex: tabIndex,
      hidden: hidden,

      // Accessibility
      ariaLabel: ariaLabel,
      ariaRole: ariaRole,
      ariaHidden: ariaHidden,

      // Data
      data: data,
      attrs: attrs,
      children: children,
    );

ElementNode el(
  String tag, {
  Object? key,

  // Styling
  String? classes,
  Map<String, String>? style,

  // Events
  EventCallback? onClick,
  EventCallback? onDoubleClick,
  EventCallback? onMouseEnter,
  EventCallback? onMouseLeave,
  EventCallback? onMouseMove,
  EventCallback? onMouseDown,
  EventCallback? onMouseUp,
  EventCallback? onFocus,
  EventCallback? onBlur,
  EventCallback? onKeyDown,
  EventCallback? onKeyUp,
  EventCallback? onInput,
  EventCallback? onChange,
  EventCallback? onSubmit,

  // Generic attributes
  String? id,
  String? title,
  String? role,
  int? tabIndex,
  bool? hidden,

  // Accessibility
  String? ariaLabel,
  String? ariaRole,
  bool? ariaHidden,

  // Data attributes
  Map<String, String>? data,

  // Escape hatch
  Map<String, Attribute>? attrs = const {},

  // Children
  List<PulsarNode> children = const [],
}) {
  final merged = <String, Attribute>{};

  // User-provided attributes first (lowest priority)
  if (attrs != null) {
    merged.addAll(attrs);
  }

  // Classes & style
  if (classes != null) {
    merged['class'] = ClassAttribute(classes);
  }

  if (style != null) {
    merged['style'] = StyleAttribute(style);
  }

  // Generic attributes
  if (id != null) {
    merged['id'] = StringAttribute(id);
  }

  if (title != null) {
    merged['title'] = StringAttribute(title);
  }

  if (role != null) {
    merged['role'] = StringAttribute(role);
  }

  if (tabIndex != null) {
    merged['tabindex'] = StringAttribute(tabIndex.toString());
  }

  if (hidden == true) {
    merged['hidden'] = BooleanAttribute(true);
  }

  // Accessibility (ARIA)
  if (ariaLabel != null) {
    merged['aria-label'] = StringAttribute(ariaLabel);
  }

  if (ariaRole != null) {
    merged['aria-role'] = StringAttribute(ariaRole);
  }

  if (ariaHidden != null) {
    merged['aria-hidden'] = BooleanAttribute(ariaHidden);
  }

  // Data attributes (data-*)
  if (data != null) {
    for (final entry in data.entries) {
      merged['data-${entry.key}'] = StringAttribute(entry.value);
    }
  }

  // Event binding helper
  void bind(String name, EventCallback? cb) {
    if (cb != null) {
      merged[name] = EventAttribute(cb);
    }
  }

  // Events
  bind('onClick', onClick);
  bind('onDblClick', onDoubleClick);
  bind('onMouseEnter', onMouseEnter);
  bind('onMouseLeave', onMouseLeave);
  bind('onMouseMove', onMouseMove);
  bind('onMouseDown', onMouseDown);
  bind('onMouseUp', onMouseUp);
  bind('onFocus', onFocus);
  bind('onBlur', onBlur);
  bind('onKeyDown', onKeyDown);
  bind('onKeyUp', onKeyUp);
  bind('onInput', onInput);
  bind('onChange', onChange);
  bind('onSubmit', onSubmit);

  return ElementNode(
    tag: tag,
    attributes: merged,
    children: children,
    key: key,
  );
}

// Layout and Structure tags
final html = tag('html');
final head = tag('head');
final body = tag('body');

final header = tag('header');
final footer = tag('footer');
final mainTag = tag('main');
final section = tag('section');
final article = tag('article');
final nav = tag('nav');
final aside = tag('aside');
final div = tag('div');

// Head and Metadata tags
final title = tag('title');
final meta = tag('meta');
final link = tag('link');
final base = tag('base');
final styleTag = tag('style');

// Text and inline content tags
final h1 = tag('h1');
final h2 = tag('h2');
final h3 = tag('h3');
final h4 = tag('h4');
final h5 = tag('h5');
final h6 = tag('h6');

final p = tag('p');
final span = tag('span');
ElementNode a({
  Object? key,
  String? href,
  String? target,
  String? rel,
  bool download = false,

  String? classes,
  Map<String, String>? style,

  EventCallback? onClick,

  Map<String, Attribute>? attrs,
  List<PulsarNode> children = const [],
}) {
  return el(
    'a',
    key: key,
    classes: classes,
    style: style,
    onClick: onClick,
    attrs: {
      if (href != null) 'href': StringAttribute(href),
      if (target != null) 'target': StringAttribute(target),
      if (rel != null) 'rel': StringAttribute(rel),
      if (download) 'download': BooleanAttribute(true),
      ...?attrs,
    },
    children: children,
  );
}

final strong = tag('strong');
final em = tag('em');
final b = tag('b');
final i = tag('i');
final u = tag('u');
final small = tag('small');
final mark = tag('mark');
final code = tag('code');
final pre = tag('pre');

final blockquote = tag('blockquote');
final q = tag('q');
final cite = tag('cite');
final abbr = tag('abbr');
final data = tag('data');
final time = tag('time');
final address = tag('address');

final br = tag('br');
final hr = tag('hr');

// List tags
final ul = tag('ul');
final ol = tag('ol');
final li = tag('li');

final dl = tag('dl');
final dt = tag('dt');
final dd = tag('dd');

// Media and embed tags
final img = tag('img');
final picture = tag('picture');
final source = tag('source');

final video = tag('video');
final audio = tag('audio');
final track = tag('track');

final figure = tag('figure');
final figcaption = tag('figcaption');

final canvas = tag('canvas');
final svg = tag('svg');
final iframe = tag('iframe');
final embed = tag('embed');
final object = tag('object');
final param = tag('param');

// Forms tags
ElementNode form({
  Object? key,
  String? action,
  String method = 'get',

  String? classes,
  Map<String, String>? style,

  EventCallback? onSubmit,

  Map<String, Attribute>? attrs,
  List<PulsarNode> children = const [],
}) {
  return el(
    'form',
    key: key,
    classes: classes,
    style: style,
    onSubmit: onSubmit,
    attrs: {
      if (action != null) 'action': StringAttribute(action),
      'method': StringAttribute(method),
      ...?attrs,
    },
    children: children,
  );
}

ElementNode input({
  Object? key,

  String type = 'text',
  String? name,
  String? value,
  String? placeholder,
  bool? checked,
  bool disabled = false,
  bool required = false,

  String? classes,
  Map<String, String>? style,

  EventCallback? onInput,
  EventCallback? onChange,
  EventCallback? onFocus,
  EventCallback? onBlur,

  Map<String, Attribute>? attrs,
}) {
  return el(
    'input',
    key: key,
    classes: classes,
    style: style,
    onInput: onInput,
    onChange: onChange,
    onFocus: onFocus,
    onBlur: onBlur,
    attrs: {
      'type': StringAttribute(type),
      if (name != null) 'name': StringAttribute(name),
      if (value != null) 'value': StringAttribute(value),
      if (placeholder != null) 'placeholder': StringAttribute(placeholder),
      if (checked != null) 'checked': BooleanAttribute(checked),
      if (disabled) 'disabled': BooleanAttribute(true),
      if (required) 'required': BooleanAttribute(true),
      ...?attrs,
    },
  );
}

final textarea = tag('textarea');
final button = tag('button');
final select = tag('select');
final option = tag('option');
final optgroup = tag('optgroup');

ElementNode label({
  Object? key,
  String? htmlFor,

  String? classes,
  Map<String, String>? style,

  Map<String, Attribute>? attrs,
  List<PulsarNode> children = const [],
}) {
  return el(
    'label',
    key: key,
    classes: classes,
    style: style,
    attrs: {if (htmlFor != null) 'for': StringAttribute(htmlFor), ...?attrs},
    children: children,
  );
}

final fieldset = tag('fieldset');
final legend = tag('legend');

final datalist = tag('datalist');
final output = tag('output');
final progress = tag('progress');
final meter = tag('meter');

// Tables tags
final table = tag('table');
final caption = tag('caption');

final thead = tag('thead');
final tbody = tag('tbody');
final tfoot = tag('tfoot');

final tr = tag('tr');
final th = tag('th');
final td = tag('td');

final colgroup = tag('colgroup');
final col = tag('col');

// Interactive Semantic tags
final details = tag('details');
final summary = tag('summary');
final dialog = tag('dialog');

// Script tags
final script = tag('script');
final noscript = tag('noscript');

// Other tags
final slot = tag('slot'); // web components
final template = tag('template');
final map = tag('map');
final area = tag('area');
