import 'package:pulsar_web/pulsar.dart';

// ==============================
// Void Elements (sin children)
// ==============================

class Img extends VoidElement {
  Img({super.key}) : super('img');

  Img src(String url) {
    attr('src', StringAttribute(url));
    return this;
  }

  Img alt(String text) {
    attr('alt', StringAttribute(text));
    return this;
  }

  Img width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  Img height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }

  Img loading(String l) {
    attr('loading', StringAttribute(l));
    return this;
  }

  Img decoding(String d) {
    attr('decoding', StringAttribute(d));
    return this;
  }

  Img srcset(String ss) {
    attr('srcset', StringAttribute(ss));
    return this;
  }

  Img sizes(String s) {
    attr('sizes', StringAttribute(s));
    return this;
  }

  Img crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return this;
  }

  Img referrerpolicy(String rp) {
    attr('referrerpolicy', StringAttribute(rp));
    return this;
  }

  Img ismap([bool im = true]) {
    if (im) attr('ismap', BooleanAttribute(true));
    return this;
  }

  Img usemap(String um) {
    attr('usemap', StringAttribute(um));
    return this;
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

class Input extends VoidElement {
  Input({super.key}) : super('input');

  Input type(InputType t) {
    attr('type', StringAttribute(t.value));
    return this;
  }

  Input placeholder(String text) {
    attr('placeholder', StringAttribute(text));
    return this;
  }

  Input value(String val) {
    attr('value', StringAttribute(val));
    return this;
  }

  Input name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Input disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }

  Input checked([bool c = true]) {
    if (c) attr('checked', BooleanAttribute(true));
    return this;
  }

  Input required([bool r = true]) {
    if (r) attr('required', BooleanAttribute(true));
    return this;
  }

  Input readonly([bool r = true]) {
    if (r) attr('readonly', BooleanAttribute(true));
    return this;
  }

  Input min(String m) {
    attr('min', StringAttribute(m));
    return this;
  }

  Input max(String m) {
    attr('max', StringAttribute(m));
    return this;
  }

  Input step(String s) {
    attr('step', StringAttribute(s));
    return this;
  }

  Input pattern(String p) {
    attr('pattern', StringAttribute(p));
    return this;
  }

  Input maxlength(int m) {
    attr('maxlength', StringAttribute('$m'));
    return this;
  }

  Input minlength(int m) {
    attr('minlength', StringAttribute('$m'));
    return this;
  }

  Input size(int s) {
    attr('size', StringAttribute('$s'));
    return this;
  }

  Input autocomplete(String a) {
    attr('autocomplete', StringAttribute(a));
    return this;
  }

  Input autofocus([bool af = true]) {
    if (af) attr('autofocus', BooleanAttribute(true));
    return this;
  }

  Input multiple([bool m = true]) {
    if (m) attr('multiple', BooleanAttribute(true));
    return this;
  }

  Input accept(String a) {
    attr('accept', StringAttribute(a));
    return this;
  }

  Input capture(String c) {
    attr('capture', StringAttribute(c));
    return this;
  }

  Input list(String l) {
    attr('list', StringAttribute(l));
    return this;
  }

  Input form(String f) {
    attr('form', StringAttribute(f));
    return this;
  }

  Input formaction(String fa) {
    attr('formaction', StringAttribute(fa));
    return this;
  }

  Input formmethod(String fm) {
    attr('formmethod', StringAttribute(fm));
    return this;
  }

  Input formenctype(String fe) {
    attr('formenctype', StringAttribute(fe));
    return this;
  }

  Input formnovalidate([bool fnv = true]) {
    if (fnv) attr('formnovalidate', BooleanAttribute(true));
    return this;
  }

  Input formtarget(String ft) {
    attr('formtarget', StringAttribute(ft));
    return this;
  }
}

class Hr extends VoidElement {
  Hr({super.key}) : super('hr');
}

class Br extends VoidElement {
  Br({super.key}) : super('br');
}

class Wbr extends VoidElement {
  Wbr({super.key}) : super('wbr');
}

// ==============================
// Document Metadata
// ==============================

class Meta extends VoidElement {
  Meta({super.key}) : super('meta');

  Meta name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Meta content(String c) {
    attr('content', StringAttribute(c));
    return this;
  }

  Meta charset(String c) {
    attr('charset', StringAttribute(c));
    return this;
  }

  Meta httpEquiv(String he) {
    attr('http-equiv', StringAttribute(he));
    return this;
  }

  Meta property(String p) {
    attr('property', StringAttribute(p));
    return this;
  }
}

class Link extends VoidElement {
  Link({super.key}) : super('link');

  Link rel(String r) {
    attr('rel', StringAttribute(r));
    return this;
  }

  Link href(String h) {
    attr('href', StringAttribute(h));
    return this;
  }

  Link type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  Link media(String m) {
    attr('media', StringAttribute(m));
    return this;
  }

  Link hreflang(String hl) {
    attr('hreflang', StringAttribute(hl));
    return this;
  }

  Link sizes(String s) {
    attr('sizes', StringAttribute(s));
    return this;
  }

  Link crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return this;
  }

  Link integrity(String i) {
    attr('integrity', StringAttribute(i));
    return this;
  }

  Link referrerpolicy(String rp) {
    attr('referrerpolicy', StringAttribute(rp));
    return this;
  }

  Link as(String a) {
    attr('as', StringAttribute(a));
    return this;
  }
}

class Base extends VoidElement {
  Base({super.key}) : super('base');

  Base href(String h) {
    attr('href', StringAttribute(h));
    return this;
  }

  Base target(String t) {
    attr('target', StringAttribute(t));
    return this;
  }
}

// ==============================
// Media Source Elements
// ==============================

class Source extends VoidElement {
  Source({super.key}) : super('source');

  Source src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Source type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  Source srcset(String ss) {
    attr('srcset', StringAttribute(ss));
    return this;
  }

  Source sizes(String s) {
    attr('sizes', StringAttribute(s));
    return this;
  }

  Source media(String m) {
    attr('media', StringAttribute(m));
    return this;
  }

  Source width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  Source height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }
}

class Track extends VoidElement {
  Track({super.key}) : super('track');

  Track src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Track kind(String k) {
    attr('kind', StringAttribute(k));
    return this;
  }

  Track srclang(String sl) {
    attr('srclang', StringAttribute(sl));
    return this;
  }

  Track label(String l) {
    attr('label', StringAttribute(l));
    return this;
  }

  Track defaultTrack([bool d = true]) {
    if (d) attr('default', BooleanAttribute(true));
    return this;
  }
}

class Path extends VoidElement {
  Path({super.key}) : super('path');

  Path d(String value) {
    attr('d', StringAttribute(value));
    return this;
  }
}

// SVG polyline
class Polyline extends VoidElement {
  Polyline({super.key}) : super('polyline');

  Polyline points(String value) {
    attr('points', StringAttribute(value));
    return this;
  }
}

// ==============================
// Table Structure
// ==============================

class Col extends VoidElement {
  Col({super.key}) : super('col');

  Col span(int s) {
    attr('span', StringAttribute('$s'));
    return this;
  }
}

// ==============================
// Embedded Objects
// ==============================

class Param extends VoidElement {
  Param({super.key}) : super('param');

  Param name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Param value(String v) {
    attr('value', StringAttribute(v));
    return this;
  }
}

// ==============================
// Image Maps
// ==============================

class Area extends VoidElement {
  Area({super.key}) : super('area');

  Area alt(String a) {
    attr('alt', StringAttribute(a));
    return this;
  }

  Area coords(String c) {
    attr('coords', StringAttribute(c));
    return this;
  }

  Area shape(String s) {
    attr('shape', StringAttribute(s));
    return this;
  }

  Area href(String h) {
    attr('href', StringAttribute(h));
    return this;
  }

  Area target(String t) {
    attr('target', StringAttribute(t));
    return this;
  }

  Area download([String? filename]) {
    if (filename != null) {
      attr('download', StringAttribute(filename));
    } else {
      attr('download', BooleanAttribute(true));
    }
    return this;
  }

  Area ping(String p) {
    attr('ping', StringAttribute(p));
    return this;
  }

  Area rel(String r) {
    attr('rel', StringAttribute(r));
    return this;
  }
}
