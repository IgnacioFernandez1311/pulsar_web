import 'package:pulsar_web/pulsar.dart';

// ==============================
// Document Structure
// ==============================

class Html extends ContentElement {
  Html({super.key}) : super('html');

  @override
  Html lang(String value) {
    attr('lang', StringAttribute(value));
    return this;
  }
}

class Head extends ContentElement {
  Head({super.key}) : super('head');
}

class Body extends ContentElement {
  Body({super.key}) : super('body');
}

class Title extends ContentElement {
  Title({super.key}) : super('title');
}

class Style extends ContentElement {
  Style({super.key}) : super('style');

  Style type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  Style media(String m) {
    attr('media', StringAttribute(m));
    return this;
  }
}

class Script extends ContentElement {
  Script({super.key}) : super('script');

  Script src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Script type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  Script async([bool a = true]) {
    if (a) attr('async', BooleanAttribute(true));
    return this;
  }

  Script defer([bool d = true]) {
    if (d) attr('defer', BooleanAttribute(true));
    return this;
  }

  Script crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return this;
  }

  Script integrity(String i) {
    attr('integrity', StringAttribute(i));
    return this;
  }
}

class Noscript extends ContentElement {
  Noscript({super.key}) : super('noscript');
}

// ==============================
// Basic Elements
// ==============================

class Div extends ContentElement {
  Div({super.key}) : super('div');
}

class Span extends ContentElement {
  Span({super.key}) : super('span');
}

class P extends ContentElement {
  P({super.key}) : super('p');
}

// ==============================
// Headings
// ==============================

class H1 extends ContentElement {
  H1({super.key}) : super('h1');
}

class H2 extends ContentElement {
  H2({super.key}) : super('h2');
}

class H3 extends ContentElement {
  H3({super.key}) : super('h3');
}

class H4 extends ContentElement {
  H4({super.key}) : super('h4');
}

class H5 extends ContentElement {
  H5({super.key}) : super('h5');
}

class H6 extends ContentElement {
  H6({super.key}) : super('h6');
}

// ==============================
// Semantic Sections
// ==============================

class Header extends ContentElement {
  Header({super.key}) : super('header');
}

class Footer extends ContentElement {
  Footer({super.key}) : super('footer');
}

class Main extends ContentElement {
  Main({super.key}) : super('main');
}

class Section extends ContentElement {
  Section({super.key}) : super('section');
}

class Article extends ContentElement {
  Article({super.key}) : super('article');
}

class Aside extends ContentElement {
  Aside({super.key}) : super('aside');
}

class Nav extends ContentElement {
  Nav({super.key}) : super('nav');
}

class Address extends ContentElement {
  Address({super.key}) : super('address');
}

class Hgroup extends ContentElement {
  Hgroup({super.key}) : super('hgroup');
}

class Search extends ContentElement {
  Search({super.key}) : super('search');
}

// ==============================
// Text Content
// ==============================

class Blockquote extends ContentElement {
  Blockquote({super.key}) : super('blockquote');

  Blockquote cite(String c) {
    attr('cite', StringAttribute(c));
    return this;
  }
}

class Pre extends ContentElement {
  Pre({super.key}) : super('pre');
}

class Code extends ContentElement {
  Code({super.key}) : super('code');
}

class Samp extends ContentElement {
  Samp({super.key}) : super('samp');
}

class Kbd extends ContentElement {
  Kbd({super.key}) : super('kbd');
}

class Var extends ContentElement {
  Var({super.key}) : super('var');
}

class Abbr extends ContentElement {
  Abbr({super.key}) : super('abbr');

  @override
  Abbr title(String value) {
    attr('title', StringAttribute(value));
    return this;
  }
}

class Data extends ContentElement {
  Data({super.key}) : super('data');

  Data value(String v) {
    attr('value', StringAttribute(v));
    return this;
  }
}

class Time extends ContentElement {
  Time({super.key}) : super('time');

  Time datetime(String dt) {
    attr('datetime', StringAttribute(dt));
    return this;
  }
}

class Q extends ContentElement {
  Q({super.key}) : super('q');

  Q cite(String c) {
    attr('cite', StringAttribute(c));
    return this;
  }
}

class Cite extends ContentElement {
  Cite({super.key}) : super('cite');
}

class Dfn extends ContentElement {
  Dfn({super.key}) : super('dfn');
}

// ==============================
// Text Formatting
// ==============================

class Strong extends ContentElement {
  Strong({super.key}) : super('strong');
}

class Em extends ContentElement {
  Em({super.key}) : super('em');
}

class B extends ContentElement {
  B({super.key}) : super('b');
}

class I extends ContentElement {
  I({super.key}) : super('i');
}

class U extends ContentElement {
  U({super.key}) : super('u');
}

class S extends ContentElement {
  S({super.key}) : super('s');
}

class Small extends ContentElement {
  Small({super.key}) : super('small');
}

class Mark extends ContentElement {
  Mark({super.key}) : super('mark');
}

class Del extends ContentElement {
  Del({super.key}) : super('del');

  Del cite(String c) {
    attr('cite', StringAttribute(c));
    return this;
  }

  Del datetime(String dt) {
    attr('datetime', StringAttribute(dt));
    return this;
  }
}

class Ins extends ContentElement {
  Ins({super.key}) : super('ins');

  Ins cite(String c) {
    attr('cite', StringAttribute(c));
    return this;
  }

  Ins datetime(String dt) {
    attr('datetime', StringAttribute(dt));
    return this;
  }
}

class Sub extends ContentElement {
  Sub({super.key}) : super('sub');
}

class Sup extends ContentElement {
  Sup({super.key}) : super('sup');
}

class Ruby extends ContentElement {
  Ruby({super.key}) : super('ruby');
}

class Rt extends ContentElement {
  Rt({super.key}) : super('rt');
}

class Rp extends ContentElement {
  Rp({super.key}) : super('rp');
}

class Bdi extends ContentElement {
  Bdi({super.key}) : super('bdi');
}

class Bdo extends ContentElement {
  Bdo({super.key}) : super('bdo');

  Bdo dir(String d) {
    attr('dir', StringAttribute(d));
    return this;
  }
}

// ==============================
// Links and Navigation
// ==============================

/// Link and form target contexts.
///
/// Provides type-safe values for the `target` attribute of `<a>` and `<form>` elements.
///
/// Usage:
/// ```dart
/// A().href('/page').target(Target.blank)
/// Form().action('/submit').target(Target.self)
/// ```
enum Target {
  /// Opens in a new tab or window.
  blank('_blank'),

  /// Opens in the same frame (default behavior).
  self('_self'),

  /// Opens in the parent frame.
  parent('_parent'),

  /// Opens in the full window, breaking out of all frames.
  top('_top');

  /// The HTML attribute value.
  final String value;

  const Target(this.value);
}

class A extends ContentElement {
  A({super.key}) : super('a');

  A href(String url) {
    attr('href', StringAttribute(url));
    return this;
  }

  A target(Target target) {
    attr('target', StringAttribute(target.value));
    return this;
  }

  A targetCustom(String value) {
    attr('target', StringAttribute(value));
    return this;
  }

  A rel(String r) {
    attr('rel', StringAttribute(r));
    return this;
  }

  A download([String? filename]) {
    if (filename != null) {
      attr('download', StringAttribute(filename));
    } else {
      attr('download', BooleanAttribute(true));
    }
    return this;
  }

  A hreflang(String lang) {
    attr('hreflang', StringAttribute(lang));
    return this;
  }

  A type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  A ping(String urls) {
    attr('ping', StringAttribute(urls));
    return this;
  }
}

// ==============================
// Lists
// ==============================

class Ul extends ContentElement {
  Ul({super.key}) : super('ul');
}

class Ol extends ContentElement {
  Ol({super.key}) : super('ol');

  Ol start(int s) {
    attr('start', StringAttribute('$s'));
    return this;
  }

  Ol reversed([bool r = true]) {
    if (r) attr('reversed', BooleanAttribute(true));
    return this;
  }

  Ol type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }
}

class Li extends ContentElement {
  Li({super.key}) : super('li');

  Li value(int v) {
    attr('value', StringAttribute('$v'));
    return this;
  }
}

class Dl extends ContentElement {
  Dl({super.key}) : super('dl');
}

class Dt extends ContentElement {
  Dt({super.key}) : super('dt');
}

class Dd extends ContentElement {
  Dd({super.key}) : super('dd');
}

class Menu extends ContentElement {
  Menu({super.key}) : super('menu');
}

// ==============================
// Forms
// ==============================

/// HTTP methods for form submission.
///
/// Provides type-safe values for the `method` attribute of `<form>` elements.
///
/// Usage:
/// ```dart
/// Form().method(FormMethod.post)
/// Form().method(FormMethod.get)
/// ```
enum FormMethod {
  /// GET method - form data sent in URL query string.
  ///
  /// Use for idempotent operations (searches, filters).
  /// Data is visible in URL and browser history.
  get('get'),

  /// POST method - form data sent in request body.
  ///
  /// Use for operations that modify data (create, update, delete).
  /// Data is not visible in URL.
  post('post'),

  /// DIALOG method - closes dialog and submits form data to dialog opener.
  ///
  /// Only works when form is inside a `<dialog>` element.
  dialog('dialog');

  /// The HTML attribute value.
  final String value;

  const FormMethod(this.value);
}

class Form extends ContentElement {
  Form({super.key}) : super('form');

  Form action(String a) {
    attr('action', StringAttribute(a));
    return this;
  }

  Form method(FormMethod m) {
    attr('method', StringAttribute(m.value));
    return this;
  }

  Form enctype(String e) {
    attr('enctype', StringAttribute(e));
    return this;
  }

  Form target(String t) {
    attr('target', StringAttribute(t));
    return this;
  }

  Form name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Form novalidate([bool nv = true]) {
    if (nv) attr('novalidate', BooleanAttribute(true));
    return this;
  }

  Form autocomplete(String a) {
    attr('autocomplete', StringAttribute(a));
    return this;
  }
}

class Label extends ContentElement {
  Label({super.key}) : super('label');

  Label htmlFor(String id) {
    attr('for', StringAttribute(id));
    return this;
  }
}

/// HTML button types.
///
/// Provides type-safe values for the `type` attribute of `<button>` elements.
///
/// Usage:
/// ```dart
/// Button().type(ButtonType.submit)
/// Button().type(ButtonType.reset)
/// ```
enum ButtonType {
  /// Submit button - submits the form.
  submit('submit'),

  /// Reset button - resets form fields to initial values.
  reset('reset'),

  /// Generic button - no default behavior.
  button('button');

  /// The HTML attribute value.
  final String value;

  const ButtonType(this.value);
}

class Button extends ContentElement {
  Button({super.key}) : super('button');

  Button type(ButtonType t) {
    attr('type', StringAttribute(t.value));
    return this;
  }

  Button name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Button value(String v) {
    attr('value', StringAttribute(v));
    return this;
  }

  Button disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }

  Button form(String f) {
    attr('form', StringAttribute(f));
    return this;
  }

  Button formaction(String fa) {
    attr('formaction', StringAttribute(fa));
    return this;
  }

  Button formmethod(String fm) {
    attr('formmethod', StringAttribute(fm));
    return this;
  }
}

class Select extends ContentElement {
  Select({super.key}) : super('select');

  Select name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Select multiple([bool m = true]) {
    if (m) attr('multiple', BooleanAttribute(true));
    return this;
  }

  Select size(int s) {
    attr('size', StringAttribute('$s'));
    return this;
  }

  Select disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }

  Select required([bool r = true]) {
    if (r) attr('required', BooleanAttribute(true));
    return this;
  }

  Select form(String f) {
    attr('form', StringAttribute(f));
    return this;
  }
}

class Option extends ContentElement {
  Option({super.key}) : super('option');

  Option value(String val) {
    attr('value', StringAttribute(val));
    return this;
  }

  Option selected([bool isSelected = true]) {
    if (isSelected) {
      attr('selected', BooleanAttribute(true));
    }
    return this;
  }

  Option disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }

  Option label(String l) {
    attr('label', StringAttribute(l));
    return this;
  }
}

class Optgroup extends ContentElement {
  Optgroup({super.key}) : super('optgroup');

  Optgroup label(String l) {
    attr('label', StringAttribute(l));
    return this;
  }

  Optgroup disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }
}

class Textarea extends ContentElement {
  Textarea({super.key}) : super('textarea');

  Textarea name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Textarea rows(int r) {
    attr('rows', StringAttribute('$r'));
    return this;
  }

  Textarea cols(int c) {
    attr('cols', StringAttribute('$c'));
    return this;
  }

  Textarea placeholder(String p) {
    attr('placeholder', StringAttribute(p));
    return this;
  }

  Textarea disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }

  Textarea readonly([bool r = true]) {
    if (r) attr('readonly', BooleanAttribute(true));
    return this;
  }

  Textarea required([bool r = true]) {
    if (r) attr('required', BooleanAttribute(true));
    return this;
  }

  Textarea maxlength(int m) {
    attr('maxlength', StringAttribute('$m'));
    return this;
  }

  Textarea minlength(int m) {
    attr('minlength', StringAttribute('$m'));
    return this;
  }

  Textarea wrap(String w) {
    attr('wrap', StringAttribute(w));
    return this;
  }

  Textarea autocomplete(String a) {
    attr('autocomplete', StringAttribute(a));
    return this;
  }

  Textarea form(String f) {
    attr('form', StringAttribute(f));
    return this;
  }
}

class Fieldset extends ContentElement {
  Fieldset({super.key}) : super('fieldset');

  Fieldset disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return this;
  }

  Fieldset form(String f) {
    attr('form', StringAttribute(f));
    return this;
  }

  Fieldset name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }
}

class Legend extends ContentElement {
  Legend({super.key}) : super('legend');
}

class Datalist extends ContentElement {
  Datalist({super.key}) : super('datalist');
}

class Output extends ContentElement {
  Output({super.key}) : super('output');

  Output htmlFor(String f) {
    attr('for', StringAttribute(f));
    return this;
  }

  Output form(String f) {
    attr('form', StringAttribute(f));
    return this;
  }

  Output name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }
}

class Progress extends ContentElement {
  Progress({super.key}) : super('progress');

  Progress value(num v) {
    attr('value', StringAttribute('$v'));
    return this;
  }

  Progress max(num m) {
    attr('max', StringAttribute('$m'));
    return this;
  }
}

class Meter extends ContentElement {
  Meter({super.key}) : super('meter');

  Meter value(num v) {
    attr('value', StringAttribute('$v'));
    return this;
  }

  Meter min(num m) {
    attr('min', StringAttribute('$m'));
    return this;
  }

  Meter max(num m) {
    attr('max', StringAttribute('$m'));
    return this;
  }

  Meter low(num l) {
    attr('low', StringAttribute('$l'));
    return this;
  }

  Meter high(num h) {
    attr('high', StringAttribute('$h'));
    return this;
  }

  Meter optimum(num o) {
    attr('optimum', StringAttribute('$o'));
    return this;
  }
}

// ==============================
// Tables
// ==============================

class Table extends ContentElement {
  Table({super.key}) : super('table');
}

class Caption extends ContentElement {
  Caption({super.key}) : super('caption');
}

class Colgroup extends ContentElement {
  Colgroup({super.key}) : super('colgroup');

  Colgroup span(int s) {
    attr('span', StringAttribute('$s'));
    return this;
  }
}

class Thead extends ContentElement {
  Thead({super.key}) : super('thead');
}

class Tbody extends ContentElement {
  Tbody({super.key}) : super('tbody');
}

class Tfoot extends ContentElement {
  Tfoot({super.key}) : super('tfoot');
}

class Tr extends ContentElement {
  Tr({super.key}) : super('tr');
}

class Th extends ContentElement {
  Th({super.key}) : super('th');

  Th colspan(int c) {
    attr('colspan', StringAttribute('$c'));
    return this;
  }

  Th rowspan(int r) {
    attr('rowspan', StringAttribute('$r'));
    return this;
  }

  Th scope(String s) {
    attr('scope', StringAttribute(s));
    return this;
  }

  Th headers(String h) {
    attr('headers', StringAttribute(h));
    return this;
  }

  Th abbr(String a) {
    attr('abbr', StringAttribute(a));
    return this;
  }
}

class Td extends ContentElement {
  Td({super.key}) : super('td');

  Td colspan(int c) {
    attr('colspan', StringAttribute('$c'));
    return this;
  }

  Td rowspan(int r) {
    attr('rowspan', StringAttribute('$r'));
    return this;
  }

  Td headers(String h) {
    attr('headers', StringAttribute(h));
    return this;
  }
}

// ==============================
// Media Elements
// ==============================

class Figure extends ContentElement {
  Figure({super.key}) : super('figure');
}

class Figcaption extends ContentElement {
  Figcaption({super.key}) : super('figcaption');
}

class Picture extends ContentElement {
  Picture({super.key}) : super('picture');
}

class Video extends ContentElement {
  Video({super.key}) : super('video');

  Video src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Video controls([bool c = true]) {
    if (c) attr('controls', BooleanAttribute(true));
    return this;
  }

  Video autoplay([bool a = true]) {
    if (a) attr('autoplay', BooleanAttribute(true));
    return this;
  }

  Video loop([bool l = true]) {
    if (l) attr('loop', BooleanAttribute(true));
    return this;
  }

  Video muted([bool m = true]) {
    if (m) attr('muted', BooleanAttribute(true));
    return this;
  }

  Video poster(String p) {
    attr('poster', StringAttribute(p));
    return this;
  }

  Video width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  Video height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }

  Video preload(String p) {
    attr('preload', StringAttribute(p));
    return this;
  }

  Video crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return this;
  }
}

class Audio extends ContentElement {
  Audio({super.key}) : super('audio');

  Audio src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Audio controls([bool c = true]) {
    if (c) attr('controls', BooleanAttribute(true));
    return this;
  }

  Audio autoplay([bool a = true]) {
    if (a) attr('autoplay', BooleanAttribute(true));
    return this;
  }

  Audio loop([bool l = true]) {
    if (l) attr('loop', BooleanAttribute(true));
    return this;
  }

  Audio muted([bool m = true]) {
    if (m) attr('muted', BooleanAttribute(true));
    return this;
  }

  Audio preload(String p) {
    attr('preload', StringAttribute(p));
    return this;
  }

  Audio crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return this;
  }
}

class Canvas extends ContentElement {
  Canvas({super.key}) : super('canvas');

  Canvas width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  Canvas height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }
}

class Svg extends ContentElement {
  Svg({super.key}) : super('svg');

  Svg width(String w) {
    attr('width', StringAttribute(w));
    return this;
  }

  Svg height(String h) {
    attr('height', StringAttribute(h));
    return this;
  }

  Svg viewBox(String vb) {
    attr('viewBox', StringAttribute(vb));
    return this;
  }

  Svg xmlns(String ns) {
    attr('xmlns', StringAttribute(ns));
    return this;
  }
}

class Math extends ContentElement {
  Math({super.key}) : super('math');

  Math xmlns(String ns) {
    attr('xmlns', StringAttribute(ns));
    return this;
  }
}

// ==============================
// Embedded Content
// ==============================

class Iframe extends ContentElement {
  Iframe({super.key}) : super('iframe');

  Iframe src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Iframe srcdoc(String sd) {
    attr('srcdoc', StringAttribute(sd));
    return this;
  }

  Iframe name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  Iframe sandbox(String s) {
    attr('sandbox', StringAttribute(s));
    return this;
  }

  Iframe allow(String a) {
    attr('allow', StringAttribute(a));
    return this;
  }

  Iframe width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  Iframe height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }

  Iframe loading(String l) {
    attr('loading', StringAttribute(l));
    return this;
  }

  Iframe referrerpolicy(String rp) {
    attr('referrerpolicy', StringAttribute(rp));
    return this;
  }
}

class Embed extends ContentElement {
  Embed({super.key}) : super('embed');

  Embed src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }

  Embed type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  Embed width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  Embed height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }
}

class ObjectTag extends ContentElement {
  ObjectTag({super.key}) : super('object');

  ObjectTag type(String t) {
    attr('type', StringAttribute(t));
    return this;
  }

  ObjectTag name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }

  ObjectTag width(int w) {
    attr('width', StringAttribute('$w'));
    return this;
  }

  ObjectTag height(int h) {
    attr('height', StringAttribute('$h'));
    return this;
  }
}

class Portal extends ContentElement {
  Portal({super.key}) : super('portal');

  Portal src(String s) {
    attr('src', StringAttribute(s));
    return this;
  }
}

// ==============================
// Interactive Elements
// ==============================

class Details extends ContentElement {
  Details({super.key}) : super('details');

  Details open([bool o = true]) {
    if (o) attr('open', BooleanAttribute(true));
    return this;
  }
}

class Summary extends ContentElement {
  Summary({super.key}) : super('summary');
}

class Dialog extends ContentElement {
  Dialog({super.key}) : super('dialog');

  Dialog open([bool o = true]) {
    if (o) attr('open', BooleanAttribute(true));
    return this;
  }
}

// ==============================
// Web Components
// ==============================

class Template extends ContentElement {
  Template({super.key}) : super('template');
}

class Slot extends ContentElement {
  Slot({super.key}) : super('slot');

  Slot name(String n) {
    attr('name', StringAttribute(n));
    return this;
  }
}
