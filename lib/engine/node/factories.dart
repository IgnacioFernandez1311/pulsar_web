import 'package:pulsar_web/pulsar.dart';

TextNode text(String value) => TextNode(value);

typedef HtmlBuilder =
    ElementNode Function({
      Object? key,
      String? classes,
      Map<String, String>? style,
      Map<String, Attribute> attrs,
      List<PulsarNode> children,
    });

HtmlBuilder tag(String name) =>
    ({
      Object? key,
      String? classes,
      Map<String, String>? style,
      Map<String, Attribute> attrs = const {},
      List<PulsarNode> children = const [],
    }) => el(
      name,
      key: key,
      classes: classes,
      style: style,
      attrs: attrs,
      children: children,
    );

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
final a = tag('a');

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
final form = tag('form');
final input = tag('input');
final textarea = tag('textarea');
final button = tag('button');
final select = tag('select');
final option = tag('option');
final optgroup = tag('optgroup');

final label = tag('label');
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
