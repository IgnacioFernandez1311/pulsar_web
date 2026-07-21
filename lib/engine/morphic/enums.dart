// lib/core/enums.dart

/// HTML enums for type-safe attribute values.
///
/// This file contains all enum types used across HTML elements
/// to provide compile-time type safety and IDE autocomplete.
library;

// ══════════════════════════════════════════════════════════════════════════════
// Form & Input Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Form submission methods.
enum FormMethod {
  /// Submit via HTTP GET (default).
  get('get'),

  /// Submit via HTTP POST.
  post('post'),

  /// Submit via HTTP dialog method (for dialog forms).
  dialog('dialog');

  final String value;
  const FormMethod(this.value);
}

/// Form encoding types.
enum FormEnctype {
  /// URL-encoded (default): application/x-www-form-urlencoded
  urlencoded('application/x-www-form-urlencoded'),

  /// Multipart form data (required for file uploads): multipart/form-data
  multipart('multipart/form-data'),

  /// Plain text: text/plain
  textPlain('text/plain');

  final String value;
  const FormEnctype(this.value);
}

/// Autocomplete modes.
enum Autocomplete {
  /// Enable autocomplete.
  on('on'),

  /// Disable autocomplete.
  off('off');

  final String value;
  const Autocomplete(this.value);
}

/// Input mode hints for virtual keyboards.
enum InputMode {
  /// No virtual keyboard (for custom input methods).
  none('none'),

  /// Standard text keyboard.
  text('text'),

  /// Decimal numeric keyboard (with decimal separator).
  decimal('decimal'),

  /// Numeric keyboard (integers only).
  numeric('numeric'),

  /// Telephone number keyboard.
  tel('tel'),

  /// Search-optimized keyboard.
  search('search'),

  /// Email-optimized keyboard (with @ key).
  email('email'),

  /// URL-optimized keyboard (with / and .com keys).
  url('url');

  final String value;
  const InputMode(this.value);
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

/// Text wrapping modes for textarea.
enum TextWrap {
  /// Insert line breaks in submitted value.
  hard('hard'),

  /// Do not insert line breaks (default).
  soft('soft');

  final String value;
  const TextWrap(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Media Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Media preload strategies.
enum Preload {
  /// Do not preload.
  none('none'),

  /// Preload metadata only (duration, dimensions).
  metadata('metadata'),

  /// Preload entire file.
  auto('auto');

  final String value;
  const Preload(this.value);
}

/// Cross-origin request modes.
enum CrossOrigin {
  /// Send credentials only for same-origin requests.
  anonymous('anonymous'),

  /// Always send credentials (cookies, auth headers).
  useCredentials('use-credentials');

  final String value;
  const CrossOrigin(this.value);
}

/// Image/iframe loading strategies.
enum Loading {
  /// Load immediately (default).
  eager('eager'),

  /// Defer loading until near viewport.
  lazy('lazy');

  final String value;
  const Loading(this.value);
}

/// Image decoding strategies.
enum Decoding {
  /// Synchronous decoding.
  sync('sync'),

  /// Asynchronous decoding.
  async('async'),

  /// Browser decides (default).
  auto('auto');

  final String value;
  const Decoding(this.value);
}

/// Track kinds for video/audio subtitles and captions.
enum TrackKind {
  /// Subtitles (translation for those who understand audio).
  subtitles('subtitles'),

  /// Captions (transcription + sound effects for deaf/hard of hearing).
  captions('captions'),

  /// Descriptions (text descriptions of visual content for blind users).
  descriptions('descriptions'),

  /// Chapter markers.
  chapters('chapters'),

  /// Metadata track (not displayed).
  metadata('metadata');

  final String value;
  const TrackKind(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Link & Navigation Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Link relationship types.
enum Rel {
  /// Alternate version of the document.
  alternate('alternate'),

  /// Author of the document.
  author('author'),

  /// Bookmark (permanent URL for the document).
  bookmark('bookmark'),

  /// Canonical URL for the document.
  canonical('canonical'),

  /// DNS prefetch hint.
  dnsPrefetch('dns-prefetch'),

  /// Link to external site.
  external('external'),

  /// Help documentation.
  help('help'),

  /// Icon for the page.
  icon('icon'),

  /// License for the content.
  license('license'),

  /// Next document in sequence.
  next('next'),

  /// Do not follow this link (for SEO).
  nofollow('nofollow'),

  /// Do not open in new context.
  noopener('noopener'),

  /// Do not send referrer.
  noreferrer('noreferrer'),

  /// Pingback URL.
  pingback('pingback'),

  /// Preconnect to origin.
  preconnect('preconnect'),

  /// Prefetch resource.
  prefetch('prefetch'),

  /// Preload resource.
  preload('preload'),

  /// Previous document in sequence.
  prev('prev'),

  /// Search interface for the site.
  search('search'),

  /// Stylesheet link.
  stylesheet('stylesheet'),

  /// Tag/keyword for the document.
  tag('tag');

  final String value;
  const Rel(this.value);
}

/// Referrer policy for links and resources.
enum Referrer {
  /// Never send referrer.
  noReferrer('no-referrer'),

  /// Send full URL for same-origin, no referrer for cross-origin when downgrading.
  noReferrerWhenDowngrade('no-referrer-when-downgrade'),

  /// Send only origin (no path).
  origin('origin'),

  /// Send full URL for same-origin, origin for cross-origin.
  originWhenCrossOrigin('origin-when-cross-origin'),

  /// Send referrer only for same-origin requests.
  sameOrigin('same-origin'),

  /// Send origin for same-origin, no referrer when downgrading.
  strictOrigin('strict-origin'),

  /// Send full URL for same-origin, origin for cross-origin when not downgrading.
  strictOriginWhenCrossOrigin('strict-origin-when-cross-origin'),

  /// Always send full URL (unsafe).
  unsafeUrl('unsafe-url');

  final String value;
  const Referrer(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Script & Resource Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Script types.
enum ScriptType {
  /// ES6 module script.
  module('module'),

  /// Import map for module resolution.
  importmap('importmap'),

  /// Speculation rules for prefetching.
  speculationrules('speculationrules');

  final String value;
  const ScriptType(this.value);
}

/// Resource types for preload hints.
enum ResourceType {
  /// Audio file.
  audio('audio'),

  /// Document (iframe).
  document('document'),

  /// Embedded content (embed, object).
  embed('embed'),

  /// Fetch request.
  fetch('fetch'),

  /// Font file.
  font('font'),

  /// Image.
  image('image'),

  /// JavaScript.
  script('script'),

  /// CSS stylesheet.
  style('style'),

  /// Track (subtitles).
  track('track'),

  /// Video.
  video('video'),

  /// Web Worker.
  worker('worker');

  final String value;
  const ResourceType(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Table Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Table header cell scope.
enum Scope {
  /// Header for a row.
  row('row'),

  /// Header for a column.
  col('col'),

  /// Header for a row group.
  rowgroup('rowgroup'),

  /// Header for a column group.
  colgroup('colgroup');

  final String value;
  const Scope(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// List Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Ordered list numbering types.
enum ListType {
  /// Decimal numbers (1, 2, 3, ...).
  decimal('1'),

  /// Lowercase letters (a, b, c, ...).
  lowerAlpha('a'),

  /// Uppercase letters (A, B, C, ...).
  upperAlpha('A'),

  /// Lowercase Roman numerals (i, ii, iii, ...).
  lowerRoman('i'),

  /// Uppercase Roman numerals (I, II, III, ...).
  upperRoman('I');

  final String value;
  const ListType(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// IFrame & Embed Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Sandbox permissions for iframes.
enum Sandbox {
  /// Allow form submission.
  allowForms('allow-forms'),

  /// Allow modal dialogs.
  allowModals('allow-modals'),

  /// Allow orientation lock.
  allowOrientationLock('allow-orientation-lock'),

  /// Allow pointer lock API.
  allowPointerLock('allow-pointer-lock'),

  /// Allow popups.
  allowPopups('allow-popups'),

  /// Allow popups to escape sandbox.
  allowPopupsToEscapeSandbox('allow-popups-to-escape-sandbox'),

  /// Allow presentation API.
  allowPresentation('allow-presentation'),

  /// Allow same-origin access (DANGEROUS if combined with scripts).
  allowSameOrigin('allow-same-origin'),

  /// Allow JavaScript execution.
  allowScripts('allow-scripts'),

  /// Allow top-level navigation.
  allowTopNavigation('allow-top-navigation'),

  /// Allow top navigation by user activation only.
  allowTopNavigationByUserActivation('allow-top-navigation-by-user-activation'),

  /// Allow downloads.
  allowDownloads('allow-downloads');

  final String value;
  const Sandbox(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Image Map Enums
// ══════════════════════════════════════════════════════════════════════════════

/// Area shape types for image maps.
enum AreaShape {
  /// Rectangle (coords: left, top, right, bottom).
  rect('rect'),

  /// Circle (coords: center-x, center-y, radius).
  circle('circle'),

  /// Polygon (coords: x1, y1, x2, y2, ...).
  poly('poly'),

  /// Default area (entire image).
  default_('default');

  final String value;
  const AreaShape(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Text Direction Enum
// ══════════════════════════════════════════════════════════════════════════════

/// Text direction for bidirectional text.
enum Dir {
  /// Left-to-right (default for most languages).
  ltr('ltr'),

  /// Right-to-left (Arabic, Hebrew, etc.).
  rtl('rtl'),

  /// Let browser decide based on content.
  auto('auto');

  final String value;
  const Dir(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// Draggable Enum
// ══════════════════════════════════════════════════════════════════════════════

/// Draggable states.
enum Draggable {
  /// Element is draggable.
  true_('true'),

  /// Element is not draggable.
  false_('false'),

  /// Use browser default.
  auto('auto');

  final String value;
  const Draggable(this.value);
}

// ══════════════════════════════════════════════════════════════════════════════
// ARIA Role Enum (Optional - for accessibility)
// ══════════════════════════════════════════════════════════════════════════════

/// Common ARIA roles for accessibility.
///
/// Note: This is a subset of all available ARIA roles.
/// Use the generic `role(String)` method for unlisted roles.
enum AriaRole {
  /// Interactive alert.
  alert('alert'),

  /// Alert dialog.
  alertdialog('alertdialog'),

  /// Application region.
  application('application'),

  /// Article content.
  article('article'),

  /// Banner landmark.
  banner('banner'),

  /// Button element.
  button('button'),

  /// Checkbox input.
  checkbox('checkbox'),

  /// Complementary content.
  complementary('complementary'),

  /// Content information.
  contentinfo('contentinfo'),

  /// Dialog box.
  dialog('dialog'),

  /// Document region.
  document('document'),

  /// Form landmark.
  form('form'),

  /// Heading.
  heading('heading'),

  /// Image.
  img('img'),

  /// Link.
  link('link'),

  /// List container.
  list('list'),

  /// List item.
  listitem('listitem'),

  /// Main content landmark.
  main('main'),

  /// Menu container.
  menu('menu'),

  /// Menu bar.
  menubar('menubar'),

  /// Menu item.
  menuitem('menuitem'),

  /// Navigation landmark.
  navigation('navigation'),

  /// No semantic meaning.
  presentation('presentation'),

  /// Radio button.
  radio('radio'),

  /// Radio group.
  radiogroup('radiogroup'),

  /// Region landmark.
  region('region'),

  /// Search landmark.
  search('search'),

  /// Tab.
  tab('tab'),

  /// Tab list.
  tablist('tablist'),

  /// Tab panel.
  tabpanel('tabpanel'),

  /// Text box.
  textbox('textbox'),

  /// Tooltip.
  tooltip('tooltip');

  final String value;
  const AriaRole(this.value);
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
