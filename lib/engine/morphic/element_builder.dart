import 'package:pulsar_web/pulsar.dart';

// ==============================
// Core
// ==============================

// lib/core/element_builder.dart

/// Builder for HTML elements with fluent API and call operator.
///
/// Example:
/// ```dart
/// Div().classes('container').id('main')([
///   H1()('Hello World'),
///   P()('Welcome to Pulsar'),
/// ]);
/// ```
// lib/core/element_builder.dart

base class ElementBuilder<T extends ElementBuilder<T>> {
  final String tag;
  final Object? key;
  final bool isVoid;

  T get self => this as T;

  String? _classes;
  String? _id;
  Map<String, String>? _style;
  final Map<String, Attribute> _attrs = {};

  ElementBuilder(this.tag, {this.key, this.isVoid = false});

  T classes(String classes) {
    _classes = _classes == null ? classes : '$_classes $classes';
    return self;
  }

  /// Sets the element's unique identifier.
  ///
  /// Example:
  /// ```dart
  /// Div().id('main-content')
  /// ```
  T id(String id) {
    _id = id;
    return self;
  }

  /// Sets the element's title (tooltip text).
  ///
  /// Example:
  /// ```dart
  /// Button().title('Click to submit')('Submit')
  /// ```
  T title(String value) {
    attr('title', StringAttribute(value));
    return self;
  }

  /// Hides the element from display.
  ///
  /// Example:
  /// ```dart
  /// Div().hidden()  // hidden = true
  /// Div().hidden(false)  // explicitly visible
  /// ```
  T hidden([bool h = true]) {
    if (h) {
      attr('hidden', BooleanAttribute(true));
    } else {
      // Remove attribute if explicitly set to false
      _attrs.remove('hidden');
    }
    return self;
  }

  /// Sets the tab order index for keyboard navigation.
  ///
  /// Values:
  /// - Positive numbers: explicit tab order
  /// - 0: natural document order
  /// - -1: not keyboard accessible
  ///
  /// Example:
  /// ```dart
  /// Input().tabIndex(1)
  /// Button().tabIndex(-1)  // Skip in tab navigation
  /// ```
  T tabIndex(int value) {
    attr('tabindex', StringAttribute('$value'));
    return self;
  }

  /// Sets the language of the element's content.
  ///
  /// Example:
  /// ```dart
  /// Div().lang('es')  // Spanish
  /// P().lang('en-US')  // English (US)
  /// ```
  T lang(String value) {
    attr('lang', StringAttribute(value));
    return self;
  }

  /// Sets a custom data attribute.
  ///
  /// Example:
  /// ```dart
  /// Div().data('user-id', '123')  // data-user-id="123"
  /// Div().data('count', '42')  // data-count="42"
  /// ```
  T data(String key, String value) {
    attr('data-$key', StringAttribute(value));
    return self;
  }

  // ========================================
  // ARIA Attributes (Basic Accessibility)
  // ========================================

  /// Sets the accessible label for screen readers.
  ///
  /// Example:
  /// ```dart
  /// Button().ariaLabel('Close dialog')('×')
  /// ```
  T ariaLabel(String value) {
    attr('aria-label', StringAttribute(value));
    return self;
  }

  /// Hides the element from screen readers.
  ///
  /// Example:
  /// ```dart
  /// Div().ariaHidden()  // aria-hidden="true"
  /// Div().ariaHidden(false)  // aria-hidden="false"
  /// ```
  T ariaHidden([bool h = true]) {
    attr('aria-hidden', StringAttribute(h ? 'true' : 'false'));
    return self;
  }

  /// References another element by ID for accessible description.
  ///
  /// Example:
  /// ```dart
  /// Input().ariaDescribedBy('help-text')
  /// ```
  T ariaDescribedBy(String id) {
    attr('aria-describedby', StringAttribute(id));
    return self;
  }

  T style(Map<String, String> style) {
    _style = {...?_style, ...style};
    return self;
  }

  /// Generic escape hatch for any attribute.
  ///
  /// Use this for attributes not yet supported by Pulsar.
  ///
  /// Example:
  /// ```dart
  /// Div().attr('custom-attribute', 'value')
  /// Div().attr('aria-label', 'Close button')
  /// ```
  T attr(String name, Attribute value) {
    _attrs[name] = value;
    return self;
  }

  T onClick(EventCallback handler) {
    _attrs['onClick'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDoubleClick(EventCallback handler) {
    _attrs['onDoubleClick'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseDown(EventCallback handler) {
    _attrs['onMouseDown'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseUp(EventCallback handler) {
    _attrs['onMouseUp'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseEnter(EventCallback handler) {
    _attrs['onMouseEnter'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseLeave(EventCallback handler) {
    _attrs['onMouseLeave'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseMove(EventCallback handler) {
    _attrs['onMouseMove'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseOver(EventCallback handler) {
    _attrs['onMouseOver'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onMouseOut(EventCallback handler) {
    _attrs['onMouseOut'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onContextMenu(EventCallback handler) {
    _attrs['onContextMenu'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Form Events
  // ──────────────────────────────────────────────────────────────────────────

  T onInput(EventCallback handler) {
    _attrs['onInput'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onChange(EventCallback handler) {
    _attrs['onChange'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onSubmit(EventCallback handler) {
    _attrs['onSubmit'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onFocus(EventCallback handler) {
    _attrs['onFocus'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onBlur(EventCallback handler) {
    _attrs['onBlur'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onFocusIn(EventCallback handler) {
    _attrs['onFocusIn'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onFocusOut(EventCallback handler) {
    _attrs['onFocusOut'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onReset(EventCallback handler) {
    _attrs['onReset'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onSelect(EventCallback handler) {
    _attrs['onSelect'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Keyboard Events
  // ──────────────────────────────────────────────────────────────────────────

  T onKeyDown(EventCallback handler) {
    _attrs['onKeyDown'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onKeyUp(EventCallback handler) {
    _attrs['onKeyUp'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onKeyPress(EventCallback handler) {
    _attrs['onKeyPress'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Drag & Drop Events
  // ──────────────────────────────────────────────────────────────────────────

  T onDrag(EventCallback handler) {
    _attrs['onDrag'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDragStart(EventCallback handler) {
    _attrs['onDragStart'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDragEnd(EventCallback handler) {
    _attrs['onDragEnd'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDragEnter(EventCallback handler) {
    _attrs['onDragEnter'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDragLeave(EventCallback handler) {
    _attrs['onDragLeave'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDragOver(EventCallback handler) {
    _attrs['onDragOver'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onDrop(EventCallback handler) {
    _attrs['onDrop'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Clipboard Events
  // ──────────────────────────────────────────────────────────────────────────

  T onCopy(EventCallback handler) {
    _attrs['onCopy'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onCut(EventCallback handler) {
    _attrs['onCut'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPaste(EventCallback handler) {
    _attrs['onPaste'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Media Events
  // ──────────────────────────────────────────────────────────────────────────

  T onPlay(EventCallback handler) {
    _attrs['onPlay'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPause(EventCallback handler) {
    _attrs['onPause'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onEnded(EventCallback handler) {
    _attrs['onEnded'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onTimeUpdate(EventCallback handler) {
    _attrs['onTimeUpdate'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onVolumeChange(EventCallback handler) {
    _attrs['onVolumeChange'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onLoadedData(EventCallback handler) {
    _attrs['onLoadedData'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onLoadedMetadata(EventCallback handler) {
    _attrs['onLoadedMetadata'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onCanPlay(EventCallback handler) {
    _attrs['onCanPlay'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onCanPlayThrough(EventCallback handler) {
    _attrs['onCanPlayThrough'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Scroll Events
  // ──────────────────────────────────────────────────────────────────────────

  T onScroll(EventCallback handler) {
    _attrs['onScroll'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onWheel(EventCallback handler) {
    _attrs['onWheel'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Touch Events (Mobile)
  // ──────────────────────────────────────────────────────────────────────────

  T onTouchStart(EventCallback handler) {
    _attrs['onTouchStart'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onTouchMove(EventCallback handler) {
    _attrs['onTouchMove'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onTouchEnd(EventCallback handler) {
    _attrs['onTouchEnd'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onTouchCancel(EventCallback handler) {
    _attrs['onTouchCancel'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Animation & Transition Events
  // ──────────────────────────────────────────────────────────────────────────

  T onAnimationStart(EventCallback handler) {
    _attrs['onAnimationStart'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onAnimationEnd(EventCallback handler) {
    _attrs['onAnimationEnd'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onAnimationIteration(EventCallback handler) {
    _attrs['onAnimationIteration'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onTransitionEnd(EventCallback handler) {
    _attrs['onTransitionEnd'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Pointer Events (Modern alternative to mouse/touch)
  // ──────────────────────────────────────────────────────────────────────────

  T onPointerDown(EventCallback handler) {
    _attrs['onPointerDown'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPointerUp(EventCallback handler) {
    _attrs['onPointerUp'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPointerMove(EventCallback handler) {
    _attrs['onPointerMove'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPointerEnter(EventCallback handler) {
    _attrs['onPointerEnter'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPointerLeave(EventCallback handler) {
    _attrs['onPointerLeave'] = EventAttribute.fromContext(handler);
    return self;
  }

  T onPointerCancel(EventCallback handler) {
    _attrs['onPointerCancel'] = EventAttribute.fromContext(handler);
    return self;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Generic Event Handler (for custom or less common events)
  // ──────────────────────────────────────────────────────────────────────────

  /// Generic event handler for custom or less common events.
  ///
  /// Use specific handlers (onClick, onInput, etc.) when available.
  /// Use this for events not covered by the standard handlers.
  ///
  /// Example:
  /// ```dart
  /// Div().on('customevent', handleCustom)
  /// ```
  T on(String event, EventCallback handler) {
    // Normalize event name to camelCase with 'on' prefix
    final eventName = event.startsWith('on')
        ? event
        : 'on${event[0].toUpperCase()}${event.substring(1)}';

    _attrs[eventName] = EventAttribute.fromContext(handler);
    return self;
  }

  /// Call operator for children
  Morphic call<M>([List<M>? children]) {
    // Void elements can't have children
    if (isVoid && children != null && children.isNotEmpty) {
      throw ArgumentError(
        '<$tag> is a void element and cannot have children. '
        'Use $tag() without arguments or $tag.attr() methods only.',
      );
    }

    final normalizedChildren = isVoid
        ? <Object>[]
        : MorphicChildren.normalize(children ?? []);

    final finalAttrs = <String, Attribute>{
      if (_classes != null) 'class': ClassAttribute(_classes!),
      if (_id != null) 'id': StringAttribute(_id!),
      if (_style != null) 'style': StyleAttribute(_style!),
      ..._attrs,
    };

    return ElementMorphic(
      tag: tag,
      key: key,
      attributes: finalAttrs,
      children: normalizedChildren,
    );
  }
}
