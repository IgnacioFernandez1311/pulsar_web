import 'package:pulsar_web/pulsar.dart';
import 'package:pulsar_web/engine/morphic/enums.dart';

// ==============================
// Document Structure
// ==============================

final class Html extends ElementBuilder<Html> {
  Html({super.key}) : super('html');

  @override
  Html lang(String value) {
    attr('lang', StringAttribute(value));
    return self;
  }
}

final class Head extends ElementBuilder<Head> {
  Head({super.key}) : super('head');
}

final class Body extends ElementBuilder<Body> {
  Body({super.key}) : super('body');
}

final class Title extends ElementBuilder<Title> {
  Title({super.key}) : super('title');
}

final class Style extends ElementBuilder<Style> {
  Style({super.key}) : super('style');

  Style type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  Style media(String m) {
    attr('media', StringAttribute(m));
    return self;
  }
}

final class Script extends ElementBuilder<Script> {
  Script({super.key}) : super('script');

  Script src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Script type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  Script async([bool a = true]) {
    if (a) attr('async', BooleanAttribute(true));
    return self;
  }

  Script defer([bool d = true]) {
    if (d) attr('defer', BooleanAttribute(true));
    return self;
  }

  Script crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return self;
  }

  Script integrity(String i) {
    attr('integrity', StringAttribute(i));
    return self;
  }
}

final class Noscript extends ElementBuilder<Noscript> {
  Noscript({super.key}) : super('noscript');
}

// ==============================
// Basic Elements
// ==============================

final class Div extends ElementBuilder<Div> {
  Div({super.key}) : super('div');
}

final class Span extends ElementBuilder<Span> {
  Span({super.key}) : super('span');
}

final class P extends ElementBuilder<P> {
  P({super.key}) : super('p');
}

// ==============================
// Headings
// ==============================

final class H1 extends ElementBuilder<H1> {
  H1({super.key}) : super('h1');
}

final class H2 extends ElementBuilder<H2> {
  H2({super.key}) : super('h2');
}

final class H3 extends ElementBuilder<H3> {
  H3({super.key}) : super('h3');
}

final class H4 extends ElementBuilder<H4> {
  H4({super.key}) : super('h4');
}

final class H5 extends ElementBuilder<H5> {
  H5({super.key}) : super('h5');
}

final class H6 extends ElementBuilder<H6> {
  H6({super.key}) : super('h6');
}

// ==============================
// Semantic Sections
// ==============================

final class Header extends ElementBuilder<Header> {
  Header({super.key}) : super('header');
}

final class Footer extends ElementBuilder<Footer> {
  Footer({super.key}) : super('footer');
}

final class Main extends ElementBuilder<Main> {
  Main({super.key}) : super('main');
}

final class Section extends ElementBuilder<Section> {
  Section({super.key}) : super('section');
}

final class Article extends ElementBuilder<Article> {
  Article({super.key}) : super('article');
}

final class Aside extends ElementBuilder<Aside> {
  Aside({super.key}) : super('aside');
}

final class Nav extends ElementBuilder<Nav> {
  Nav({super.key}) : super('nav');
}

final class Address extends ElementBuilder<Address> {
  Address({super.key}) : super('address');
}

final class Hgroup extends ElementBuilder<Hgroup> {
  Hgroup({super.key}) : super('hgroup');
}

final class Search extends ElementBuilder<Search> {
  Search({super.key}) : super('search');
}

// ==============================
// Text Content
// ==============================

final class Blockquote extends ElementBuilder<Blockquote> {
  Blockquote({super.key}) : super('blockquote');

  Blockquote cite(String c) {
    attr('cite', StringAttribute(c));
    return self;
  }
}

final class Pre extends ElementBuilder<Pre> {
  Pre({super.key}) : super('pre');
}

final class Code extends ElementBuilder<Code> {
  Code({super.key}) : super('code');
}

final class Samp extends ElementBuilder<Samp> {
  Samp({super.key}) : super('samp');
}

final class Kbd extends ElementBuilder<Kbd> {
  Kbd({super.key}) : super('kbd');
}

final class Var extends ElementBuilder<Var> {
  Var({super.key}) : super('var');
}

final class Abbr extends ElementBuilder<Abbr> {
  Abbr({super.key}) : super('abbr');

  @override
  Abbr title(String value) {
    attr('title', StringAttribute(value));
    return self;
  }
}

final class Data extends ElementBuilder<Data> {
  Data({super.key}) : super('data');

  Data value(String v) {
    attr('value', StringAttribute(v));
    return self;
  }
}

final class Time extends ElementBuilder<Time> {
  Time({super.key}) : super('time');

  Time datetime(String dt) {
    attr('datetime', StringAttribute(dt));
    return self;
  }
}

final class Q extends ElementBuilder<Q> {
  Q({super.key}) : super('q');

  Q cite(String c) {
    attr('cite', StringAttribute(c));
    return self;
  }
}

final class Cite extends ElementBuilder<Cite> {
  Cite({super.key}) : super('cite');
}

final class Dfn extends ElementBuilder<Dfn> {
  Dfn({super.key}) : super('dfn');
}

// ==============================
// Text Formatting
// ==============================

final class Strong extends ElementBuilder<Strong> {
  Strong({super.key}) : super('strong');
}

final class Em extends ElementBuilder<Em> {
  Em({super.key}) : super('em');
}

final class B extends ElementBuilder<B> {
  B({super.key}) : super('b');
}

final class I extends ElementBuilder<I> {
  I({super.key}) : super('i');
}

final class U extends ElementBuilder<U> {
  U({super.key}) : super('u');
}

final class S extends ElementBuilder<S> {
  S({super.key}) : super('s');
}

final class Small extends ElementBuilder<Small> {
  Small({super.key}) : super('small');
}

final class Mark extends ElementBuilder<Mark> {
  Mark({super.key}) : super('mark');
}

final class Del extends ElementBuilder<Del> {
  Del({super.key}) : super('del');

  Del cite(String c) {
    attr('cite', StringAttribute(c));
    return self;
  }

  Del datetime(String dt) {
    attr('datetime', StringAttribute(dt));
    return self;
  }
}

final class Ins extends ElementBuilder<Ins> {
  Ins({super.key}) : super('ins');

  Ins cite(String c) {
    attr('cite', StringAttribute(c));
    return self;
  }

  Ins datetime(String dt) {
    attr('datetime', StringAttribute(dt));
    return self;
  }
}

final class Sub extends ElementBuilder<Sub> {
  Sub({super.key}) : super('sub');
}

final class Sup extends ElementBuilder<Sup> {
  Sup({super.key}) : super('sup');
}

final class Ruby extends ElementBuilder<Ruby> {
  Ruby({super.key}) : super('ruby');
}

final class Rt extends ElementBuilder<Rt> {
  Rt({super.key}) : super('rt');
}

final class Rp extends ElementBuilder<Rp> {
  Rp({super.key}) : super('rp');
}

final class Bdi extends ElementBuilder<Bdi> {
  Bdi({super.key}) : super('bdi');
}

final class Bdo extends ElementBuilder<Bdo> {
  Bdo({super.key}) : super('bdo');

  Bdo dir(String d) {
    attr('dir', StringAttribute(d));
    return self;
  }
}

final class A extends ElementBuilder<A> {
  A({super.key}) : super('a');

  A href(String url) {
    attr('href', StringAttribute(url));
    return self;
  }

  A target(Target target) {
    attr('target', StringAttribute(target.value));
    return self;
  }

  A targetCustom(String value) {
    attr('target', StringAttribute(value));
    return self;
  }

  A rel(String r) {
    attr('rel', StringAttribute(r));
    return self;
  }

  A download([String? filename]) {
    if (filename != null) {
      attr('download', StringAttribute(filename));
    } else {
      attr('download', BooleanAttribute(true));
    }
    return self;
  }

  A hreflang(String lang) {
    attr('hreflang', StringAttribute(lang));
    return self;
  }

  A type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  A ping(String urls) {
    attr('ping', StringAttribute(urls));
    return self;
  }
}

// ==============================
// Lists
// ==============================

final class Ul extends ElementBuilder<Ul> {
  Ul({super.key}) : super('ul');
}

final class Ol extends ElementBuilder<Ol> {
  Ol({super.key}) : super('ol');

  Ol start(int s) {
    attr('start', StringAttribute('$s'));
    return self;
  }

  Ol reversed([bool r = true]) {
    if (r) attr('reversed', BooleanAttribute(true));
    return self;
  }

  Ol type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }
}

final class Li extends ElementBuilder<Li> {
  Li({super.key}) : super('li');

  Li value(int v) {
    attr('value', StringAttribute('$v'));
    return self;
  }
}

final class Dl extends ElementBuilder<Dl> {
  Dl({super.key}) : super('dl');
}

final class Dt extends ElementBuilder<Dt> {
  Dt({super.key}) : super('dt');
}

final class Dd extends ElementBuilder<Dd> {
  Dd({super.key}) : super('dd');
}

final class Menu extends ElementBuilder<Menu> {
  Menu({super.key}) : super('menu');
}

final class Form extends ElementBuilder<Form> {
  Form({super.key}) : super('form');

  Form action(String a) {
    attr('action', StringAttribute(a));
    return self;
  }

  Form method(FormMethod m) {
    attr('method', StringAttribute(m.value));
    return self;
  }

  Form enctype(String e) {
    attr('enctype', StringAttribute(e));
    return self;
  }

  Form target(String t) {
    attr('target', StringAttribute(t));
    return self;
  }

  Form name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Form novalidate([bool nv = true]) {
    if (nv) attr('novalidate', BooleanAttribute(true));
    return self;
  }

  Form autocomplete(String a) {
    attr('autocomplete', StringAttribute(a));
    return self;
  }
}

final class Label extends ElementBuilder<Label> {
  Label({super.key}) : super('label');

  Label htmlFor(String id) {
    attr('for', StringAttribute(id));
    return self;
  }
}

final class Button extends ElementBuilder<Button> {
  Button({super.key}) : super('button');

  Button type(ButtonType t) {
    attr('type', StringAttribute(t.value));
    return self;
  }

  Button name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Button value(String v) {
    attr('value', StringAttribute(v));
    return self;
  }

  Button disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }

  Button form(String f) {
    attr('form', StringAttribute(f));
    return self;
  }

  Button formaction(String fa) {
    attr('formaction', StringAttribute(fa));
    return self;
  }

  Button formmethod(String fm) {
    attr('formmethod', StringAttribute(fm));
    return self;
  }
}

final class Select extends ElementBuilder<Select> {
  Select({super.key}) : super('select');

  Select name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Select multiple([bool m = true]) {
    if (m) attr('multiple', BooleanAttribute(true));
    return self;
  }

  Select size(int s) {
    attr('size', StringAttribute('$s'));
    return self;
  }

  Select disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }

  Select required([bool r = true]) {
    if (r) attr('required', BooleanAttribute(true));
    return self;
  }

  Select form(String f) {
    attr('form', StringAttribute(f));
    return self;
  }
}

final class Option extends ElementBuilder<Option> {
  Option({super.key}) : super('option');

  Option value(String val) {
    attr('value', StringAttribute(val));
    return self;
  }

  Option selected([bool isSelected = true]) {
    if (isSelected) {
      attr('selected', BooleanAttribute(true));
    }
    return self;
  }

  Option disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }

  Option label(String l) {
    attr('label', StringAttribute(l));
    return self;
  }
}

final class Optgroup extends ElementBuilder<Optgroup> {
  Optgroup({super.key}) : super('optgroup');

  Optgroup label(String l) {
    attr('label', StringAttribute(l));
    return self;
  }

  Optgroup disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }
}

final class Textarea extends ElementBuilder<Textarea> {
  Textarea({super.key}) : super('textarea');

  Textarea name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Textarea rows(int r) {
    attr('rows', StringAttribute('$r'));
    return self;
  }

  Textarea cols(int c) {
    attr('cols', StringAttribute('$c'));
    return self;
  }

  Textarea placeholder(String p) {
    attr('placeholder', StringAttribute(p));
    return self;
  }

  Textarea disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }

  Textarea readonly([bool r = true]) {
    if (r) attr('readonly', BooleanAttribute(true));
    return self;
  }

  Textarea required([bool r = true]) {
    if (r) attr('required', BooleanAttribute(true));
    return self;
  }

  Textarea maxlength(int m) {
    attr('maxlength', StringAttribute('$m'));
    return self;
  }

  Textarea minlength(int m) {
    attr('minlength', StringAttribute('$m'));
    return self;
  }

  Textarea wrap(String w) {
    attr('wrap', StringAttribute(w));
    return self;
  }

  Textarea autocomplete(String a) {
    attr('autocomplete', StringAttribute(a));
    return self;
  }

  Textarea form(String f) {
    attr('form', StringAttribute(f));
    return self;
  }
}

final class Fieldset extends ElementBuilder<Fieldset> {
  Fieldset({super.key}) : super('fieldset');

  Fieldset disabled([bool d = true]) {
    if (d) attr('disabled', BooleanAttribute(true));
    return self;
  }

  Fieldset form(String f) {
    attr('form', StringAttribute(f));
    return self;
  }

  Fieldset name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }
}

final class Legend extends ElementBuilder<Legend> {
  Legend({super.key}) : super('legend');
}

final class Datalist extends ElementBuilder<Datalist> {
  Datalist({super.key}) : super('datalist');
}

final class Output extends ElementBuilder<Output> {
  Output({super.key}) : super('output');

  Output htmlFor(String f) {
    attr('for', StringAttribute(f));
    return self;
  }

  Output form(String f) {
    attr('form', StringAttribute(f));
    return self;
  }

  Output name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }
}

final class Progress extends ElementBuilder<Progress> {
  Progress({super.key}) : super('progress');

  Progress value(num v) {
    attr('value', StringAttribute('$v'));
    return self;
  }

  Progress max(num m) {
    attr('max', StringAttribute('$m'));
    return self;
  }
}

final class Meter extends ElementBuilder<Meter> {
  Meter({super.key}) : super('meter');

  Meter value(num v) {
    attr('value', StringAttribute('$v'));
    return self;
  }

  Meter min(num m) {
    attr('min', StringAttribute('$m'));
    return self;
  }

  Meter max(num m) {
    attr('max', StringAttribute('$m'));
    return self;
  }

  Meter low(num l) {
    attr('low', StringAttribute('$l'));
    return self;
  }

  Meter high(num h) {
    attr('high', StringAttribute('$h'));
    return self;
  }

  Meter optimum(num o) {
    attr('optimum', StringAttribute('$o'));
    return self;
  }
}

// ==============================
// Tables
// ==============================

final class Table extends ElementBuilder<Table> {
  Table({super.key}) : super('table');
}

final class Caption extends ElementBuilder<Caption> {
  Caption({super.key}) : super('caption');
}

final class Colgroup extends ElementBuilder<Colgroup> {
  Colgroup({super.key}) : super('colgroup');

  Colgroup span(int s) {
    attr('span', StringAttribute('$s'));
    return self;
  }
}

final class Thead extends ElementBuilder<Thead> {
  Thead({super.key}) : super('thead');
}

final class Tbody extends ElementBuilder<Tbody> {
  Tbody({super.key}) : super('tbody');
}

final class Tfoot extends ElementBuilder<Tfoot> {
  Tfoot({super.key}) : super('tfoot');
}

final class Tr extends ElementBuilder<Tr> {
  Tr({super.key}) : super('tr');
}

final class Th extends ElementBuilder<Th> {
  Th({super.key}) : super('th');

  Th colspan(int c) {
    attr('colspan', StringAttribute('$c'));
    return self;
  }

  Th rowspan(int r) {
    attr('rowspan', StringAttribute('$r'));
    return self;
  }

  Th scope(String s) {
    attr('scope', StringAttribute(s));
    return self;
  }

  Th headers(String h) {
    attr('headers', StringAttribute(h));
    return self;
  }

  Th abbr(String a) {
    attr('abbr', StringAttribute(a));
    return self;
  }
}

final class Td extends ElementBuilder<Td> {
  Td({super.key}) : super('td');

  Td colspan(int c) {
    attr('colspan', StringAttribute('$c'));
    return self;
  }

  Td rowspan(int r) {
    attr('rowspan', StringAttribute('$r'));
    return self;
  }

  Td headers(String h) {
    attr('headers', StringAttribute(h));
    return self;
  }
}

// ==============================
// Media Elements
// ==============================

final class Figure extends ElementBuilder<Figure> {
  Figure({super.key}) : super('figure');
}

final class Figcaption extends ElementBuilder<Figcaption> {
  Figcaption({super.key}) : super('figcaption');
}

final class Picture extends ElementBuilder<Picture> {
  Picture({super.key}) : super('picture');
}

final class Video extends ElementBuilder<Video> {
  Video({super.key}) : super('video');

  Video src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Video controls([bool c = true]) {
    if (c) attr('controls', BooleanAttribute(true));
    return self;
  }

  Video autoplay([bool a = true]) {
    if (a) attr('autoplay', BooleanAttribute(true));
    return self;
  }

  Video loop([bool l = true]) {
    if (l) attr('loop', BooleanAttribute(true));
    return self;
  }

  Video muted([bool m = true]) {
    if (m) attr('muted', BooleanAttribute(true));
    return self;
  }

  Video poster(String p) {
    attr('poster', StringAttribute(p));
    return self;
  }

  Video width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  Video height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }

  Video preload(String p) {
    attr('preload', StringAttribute(p));
    return self;
  }

  Video crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return self;
  }
}

final class Audio extends ElementBuilder<Audio> {
  Audio({super.key}) : super('audio');

  Audio src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Audio controls([bool c = true]) {
    if (c) attr('controls', BooleanAttribute(true));
    return self;
  }

  Audio autoplay([bool a = true]) {
    if (a) attr('autoplay', BooleanAttribute(true));
    return self;
  }

  Audio loop([bool l = true]) {
    if (l) attr('loop', BooleanAttribute(true));
    return self;
  }

  Audio muted([bool m = true]) {
    if (m) attr('muted', BooleanAttribute(true));
    return self;
  }

  Audio preload(String p) {
    attr('preload', StringAttribute(p));
    return self;
  }

  Audio crossorigin(String c) {
    attr('crossorigin', StringAttribute(c));
    return self;
  }
}

final class Canvas extends ElementBuilder<Canvas> {
  Canvas({super.key}) : super('canvas');

  Canvas width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  Canvas height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }
}

final class Svg extends ElementBuilder<Svg> {
  Svg({super.key}) : super('svg');

  Svg width(String w) {
    attr('width', StringAttribute(w));
    return self;
  }

  Svg height(String h) {
    attr('height', StringAttribute(h));
    return self;
  }

  Svg viewBox(String vb) {
    attr('viewBox', StringAttribute(vb));
    return self;
  }

  Svg xmlns(String ns) {
    attr('xmlns', StringAttribute(ns));
    return self;
  }
}

final class Math extends ElementBuilder<Math> {
  Math({super.key}) : super('math');

  Math xmlns(String ns) {
    attr('xmlns', StringAttribute(ns));
    return self;
  }
}

// ==============================
// Embedded Content
// ==============================

final class Iframe extends ElementBuilder<Iframe> {
  Iframe({super.key}) : super('iframe');

  Iframe src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Iframe srcdoc(String sd) {
    attr('srcdoc', StringAttribute(sd));
    return self;
  }

  Iframe name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  Iframe sandbox(String s) {
    attr('sandbox', StringAttribute(s));
    return self;
  }

  Iframe allow(String a) {
    attr('allow', StringAttribute(a));
    return self;
  }

  Iframe width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  Iframe height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }

  Iframe loading(String l) {
    attr('loading', StringAttribute(l));
    return self;
  }

  Iframe referrerpolicy(String rp) {
    attr('referrerpolicy', StringAttribute(rp));
    return self;
  }
}

final class Embed extends ElementBuilder<Embed> {
  Embed({super.key}) : super('embed');

  Embed src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }

  Embed type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  Embed width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  Embed height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }
}

final class ObjectTag extends ElementBuilder<ObjectTag> {
  ObjectTag({super.key}) : super('object');

  ObjectTag type(String t) {
    attr('type', StringAttribute(t));
    return self;
  }

  ObjectTag name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }

  ObjectTag width(int w) {
    attr('width', StringAttribute('$w'));
    return self;
  }

  ObjectTag height(int h) {
    attr('height', StringAttribute('$h'));
    return self;
  }
}

final class Portal extends ElementBuilder<Portal> {
  Portal({super.key}) : super('portal');

  Portal src(String s) {
    attr('src', StringAttribute(s));
    return self;
  }
}

// ==============================
// Interactive Elements
// ==============================

final class Details extends ElementBuilder<Details> {
  Details({super.key}) : super('details');

  Details open([bool o = true]) {
    if (o) attr('open', BooleanAttribute(true));
    return self;
  }
}

final class Summary extends ElementBuilder<Summary> {
  Summary({super.key}) : super('summary');
}

final class Dialog extends ElementBuilder<Dialog> {
  Dialog({super.key}) : super('dialog');

  Dialog open([bool o = true]) {
    if (o) attr('open', BooleanAttribute(true));
    return self;
  }
}

// ==============================
// Web Components
// ==============================

final class Template extends ElementBuilder<Template> {
  Template({super.key}) : super('template');
}

final class Slot extends ElementBuilder<Slot> {
  Slot({super.key}) : super('slot');

  Slot name(String n) {
    attr('name', StringAttribute(n));
    return self;
  }
}
