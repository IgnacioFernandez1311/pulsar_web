import 'package:pulsar_web/pulsar.dart';

// ==============================
// Void Elements (sin children)
// ==============================

final class Img extends ElementBuilder<Img> {
  Img({super.key}) : super('img', isVoid: true);

  Img src(String url) {
    attr('src', StringAttribute(url));
    return self;
  }

  Img alt(String text) {
    attr('alt', StringAttribute(text));
    return self;
  }

  Img width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  Img height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }

  Img loading(String l) {
    attr('loading', StringAttribute(l));
    return self;
  }

  Img decoding(String d) {
    attr('decoding', StringAttribute(d));
    return self;
  }

  Img srcset(String ss) {
    attr('srcset', StringAttribute(ss));
    return self;
  }

  Img sizes(String s) {
    attr('sizes', StringAttribute(s));
    return self;
  }

  Img crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return self;
  }

  Img referrerpolicy(Referrer rp) {
    attr('referrerpolicy', StringAttribute(rp.value));
    return self;
  }

  Img ismap([bool im = true]) {
    if (im) attr('ismap', BooleanAttribute(true));
    return self;
  }

  Img usemap(String um) {
    attr('usemap', StringAttribute(um));
    return self;
  }
}

/// HTML5 input types.
///
/// Provides type-safe values for the `type` attribute of `<input>` elements.
///
/// Usage:
/// ```dart
/// Input().type(InputType.email)
/// Input().type(InputType.password)
/// ```
enum InputType {
  /// Single-line text field.
  text('text'),

  /// Password field (characters are masked).
  password('password'),

  /// Email address field with validation.
  email('email'),

  /// Telephone number field.
  tel('tel'),

  /// URL field with validation.
  url('url'),

  /// Search field.
  search('search'),

  /// Numeric input field.
  number('number'),

  /// Range slider.
  range('range'),

  /// Date picker (year, month, day).
  date('date'),

  /// Time picker (hours, minutes).
  time('time'),

  /// Date and time picker (local timezone).
  datetimeLocal('datetime-local'),

  /// Month picker (year, month).
  month('month'),

  /// Week picker (year, week number).
  week('week'),

  /// Color picker.
  color('color'),

  /// Checkbox.
  checkbox('checkbox'),

  /// Radio button.
  radio('radio'),

  /// File upload button.
  file('file'),

  /// Submit button.
  submit('submit'),

  /// Reset button.
  reset('reset'),

  /// Generic button.
  button('button'),

  /// Hidden field (not displayed).
  hidden('hidden'),

  /// Image as submit button.
  image('image');

  /// The HTML attribute value.
  final String value;

  const InputType(this.value);
}

final class Input extends ElementBuilder<Input> {
  Input({super.key}) : super('input', isVoid: true);

  Input type(InputType t) {
    attr('type', StringAttribute(t.value));
    return self;
  }

  Input placeholder(String text) {
    attr('placeholder', StringAttribute(text));
    return self;
  }

  Input value(String val) {
    attr('value', StringAttribute(val));
    return self;
  }

  Input name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Input disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }

  Input checked([bool c = true]) {
    if (c) attr('checked', BooleanAttribute(true));
    return self;
  }

  Input required([bool r = true]) {
    if (r) attr('required', BooleanAttribute(true));
    return self;
  }

  Input readonly([bool r = true]) {
    if (r) attr('readonly', BooleanAttribute(true));
    return self;
  }

  Input min(String m) {
    attr('min', StringAttribute(m));
    return self;
  }

  Input max(String m) {
    attr('max', StringAttribute(m));
    return self;
  }

  Input step(String s) {
    attr('step', StringAttribute(s));
    return self;
  }

  Input pattern(String p) {
    attr('pattern', StringAttribute(p));
    return self;
  }

  Input maxlength(int m) {
    attr('maxlength', StringAttribute('$m'));
    return self;
  }

  Input minlength(int m) {
    attr('minlength', StringAttribute('$m'));
    return self;
  }

  Input size(int s) {
    attr('size', StringAttribute('$s'));
    return self;
  }

  Input autocomplete(String a) {
    attr('autocomplete', StringAttribute(a));
    return self;
  }

  Input autofocus([bool af = true]) {
    if (af) attr('autofocus', BooleanAttribute(true));
    return self;
  }

  Input multiple([bool m = true]) {
    if (m) attr('multiple', BooleanAttribute(true));
    return self;
  }

  Input accept(String a) {
    attr('accept', StringAttribute(a));
    return self;
  }

  Input capture(String c) {
    attr('capture', StringAttribute(c));
    return self;
  }

  Input list(String l) {
    attr('list', StringAttribute(l));
    return self;
  }

  Input form(String f) {
    attr('form', StringAttribute(f));
    return self;
  }

  Input formaction(String fa) {
    attr('formaction', StringAttribute(fa));
    return self;
  }

  Input formmethod(String fm) {
    attr('formmethod', StringAttribute(fm));
    return self;
  }

  Input formenctype(String fe) {
    attr('formenctype', StringAttribute(fe));
    return self;
  }

  Input formnovalidate([bool fnv = true]) {
    if (fnv) attr('formnovalidate', BooleanAttribute(true));
    return self;
  }

  Input formtarget(String ft) {
    attr('formtarget', StringAttribute(ft));
    return self;
  }
}

final class Hr extends ElementBuilder<Hr> {
  Hr({super.key}) : super('hr', isVoid: true);
}

final class Br extends ElementBuilder<Br> {
  Br({super.key}) : super('br', isVoid: true);
}

final class Wbr extends ElementBuilder<Wbr> {
  Wbr({super.key}) : super('wbr', isVoid: true);
}

// ==============================
// Document Metadata
// ==============================

final class Meta extends ElementBuilder<Meta> {
  Meta({super.key}) : super('meta', isVoid: true);

  Meta name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Meta content(String c) {
    attr('content', StringAttribute(c));
    return self;
  }

  Meta charset(String c) {
    attr('charset', StringAttribute(c));
    return self;
  }

  Meta httpEquiv(String he) {
    attr('http-equiv', StringAttribute(he));
    return self;
  }

  Meta property(String p) {
    attr('property', StringAttribute(p));
    return self;
  }
}

final class Link extends ElementBuilder<Link> {
  Link({super.key}) : super('link', isVoid: true);

  Link rel(String r) {
    attr('rel', StringAttribute(r));
    return self;
  }

  Link href(String h) {
    attr('href', StringAttribute(h));
    return self;
  }

  Link type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  Link media(String m) {
    attr('media', StringAttribute(m));
    return self;
  }

  Link hreflang(String hl) {
    attr('hreflang', StringAttribute(hl));
    return self;
  }

  Link sizes(String s) {
    attr('sizes', StringAttribute(s));
    return self;
  }

  Link crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return self;
  }

  Link integrity(String i) {
    attr('integrity', StringAttribute(i));
    return self;
  }

  Link referrerpolicy(String rp) {
    attr('referrerpolicy', StringAttribute(rp));
    return self;
  }

  Link as(String a) {
    attr('as', StringAttribute(a));
    return self;
  }
}

final class Base extends ElementBuilder<Base> {
  Base({super.key}) : super('base', isVoid: true);

  Base href(String h) {
    attr('href', StringAttribute(h));
    return self;
  }

  Base target(String t) {
    attr('target', StringAttribute(t));
    return self;
  }
}

// ==============================
// Media Source Elements
// ==============================

final class Source extends ElementBuilder<Source> {
  Source({super.key}) : super('source', isVoid: true);

  Source src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Source type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  Source srcset(String ss) {
    attr('srcset', StringAttribute(ss));
    return self;
  }

  Source sizes(String s) {
    attr('sizes', StringAttribute(s));
    return self;
  }

  Source media(String m) {
    attr('media', StringAttribute(m));
    return self;
  }

  Source width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  Source height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }
}

final class Track extends ElementBuilder<Track> {
  Track({super.key}) : super('track', isVoid: true);

  Track src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Track kind(String k) {
    attr('kind', StringAttribute(k));
    return self;
  }

  Track srclang(String sl) {
    attr('srclang', StringAttribute(sl));
    return self;
  }

  Track label(String l) {
    attr('label', StringAttribute(l));
    return self;
  }

  Track defaultTrack([bool d = true]) {
    if (d) attr('default', BooleanAttribute(true));
    return self;
  }
}

final class Path extends ElementBuilder<Path> {
  Path({super.key}) : super('path', isVoid: true);

  Path d(String value) {
    attr('d', StringAttribute(value));
    return self;
  }
}

// SVG polyline
final class Polyline extends ElementBuilder<Polyline> {
  Polyline({super.key}) : super('polyline', isVoid: true);

  Polyline points(String value) {
    attr('points', StringAttribute(value));
    return self;
  }
}

// ==============================
// Table Structure
// ==============================

final class Col extends ElementBuilder<Col> {
  Col({super.key}) : super('col', isVoid: true);

  Col span(int s) {
    attr('span', StringAttribute('$s'));
    return self;
  }
}

// ==============================
// Embedded Objects
// ==============================

final class Param extends ElementBuilder<Param> {
  Param({super.key}) : super('param', isVoid: true);

  Param name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Param value(String v) {
    attr('value', StringAttribute(v));
    return self;
  }
}

// ==============================
// Image Maps
// ==============================

final class Area extends ElementBuilder<Area> {
  Area({super.key}) : super('area', isVoid: true);

  Area alt(String a) {
    attr('alt', StringAttribute(a));
    return self;
  }

  Area coords(String c) {
    attr('coords', StringAttribute(c));
    return self;
  }

  Area shape(String s) {
    attr('shape', StringAttribute(s));
    return self;
  }

  Area href(String h) {
    attr('href', StringAttribute(h));
    return self;
  }

  Area target(String t) {
    attr('target', StringAttribute(t));
    return self;
  }

  Area download([String? filename]) {
    if (filename != null) {
      attr('download', StringAttribute(filename));
    } else {
      attr('download', BooleanAttribute(true));
    }
    return self;
  }

  Area ping(String p) {
    attr('ping', StringAttribute(p));
    return self;
  }

  Area rel(String r) {
    attr('rel', StringAttribute(r));
    return self;
  }
}
