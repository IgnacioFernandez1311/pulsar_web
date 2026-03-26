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

class ElementBuilder {
  final String tag;
  final Object? key;
  final bool isVoid;

  String? _classes;
  String? _id;
  Map<String, String>? _style;
  final Map<String, Attribute> _attrs = {};

  ElementBuilder(this.tag, {this.key, this.isVoid = false});

  ElementBuilder classes(String classes) {
    _classes = _classes == null ? classes : '$_classes $classes';
    return this;
  }

  /// Sets the element's unique identifier.
  ///
  /// Example:
  /// ```dart
  /// Div().id('main-content')
  /// ```
  ElementBuilder id(String id) {
    _id = id;
    return this;
  }

  /// Sets the element's title (tooltip text).
  ///
  /// Example:
  /// ```dart
  /// Button().title('Click to submit')('Submit')
  /// ```
  ElementBuilder title(String value) {
    attr('title', StringAttribute(value));
    return this;
  }

  /// Hides the element from display.
  ///
  /// Example:
  /// ```dart
  /// Div().hidden()  // hidden = true
  /// Div().hidden(false)  // explicitly visible
  /// ```
  ElementBuilder hidden([bool h = true]) {
    if (h) {
      attr('hidden', BooleanAttribute(true));
    } else {
      // Remove attribute if explicitly set to false
      _attrs.remove('hidden');
    }
    return this;
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
  ElementBuilder tabIndex(int value) {
    attr('tabindex', StringAttribute('$value'));
    return this;
  }

  /// Sets the language of the element's content.
  ///
  /// Example:
  /// ```dart
  /// Div().lang('es')  // Spanish
  /// P().lang('en-US')  // English (US)
  /// ```
  ElementBuilder lang(String value) {
    attr('lang', StringAttribute(value));
    return this;
  }

  /// Sets a custom data attribute.
  ///
  /// Example:
  /// ```dart
  /// Div().data('user-id', '123')  // data-user-id="123"
  /// Div().data('count', '42')  // data-count="42"
  /// ```
  ElementBuilder data(String key, String value) {
    attr('data-$key', StringAttribute(value));
    return this;
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
  ElementBuilder ariaLabel(String value) {
    attr('aria-label', StringAttribute(value));
    return this;
  }

  /// Hides the element from screen readers.
  ///
  /// Example:
  /// ```dart
  /// Div().ariaHidden()  // aria-hidden="true"
  /// Div().ariaHidden(false)  // aria-hidden="false"
  /// ```
  ElementBuilder ariaHidden([bool h = true]) {
    attr('aria-hidden', StringAttribute(h ? 'true' : 'false'));
    return this;
  }

  /// References another element by ID for accessible description.
  ///
  /// Example:
  /// ```dart
  /// Input().ariaDescribedBy('help-text')
  /// ```
  ElementBuilder ariaDescribedBy(String id) {
    attr('aria-describedby', StringAttribute(id));
    return this;
  }

  ElementBuilder style(Map<String, String> style) {
    _style = {...?_style, ...style};
    return this;
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
  ElementBuilder attr(String name, Attribute value) {
    _attrs[name] = value;
    return this;
  }

  ElementBuilder onClick(EventCallback handler) {
    _attrs['onClick'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDoubleClick(EventCallback handler) {
    _attrs['onDoubleClick'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseDown(EventCallback handler) {
    _attrs['onMouseDown'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseUp(EventCallback handler) {
    _attrs['onMouseUp'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseEnter(EventCallback handler) {
    _attrs['onMouseEnter'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseLeave(EventCallback handler) {
    _attrs['onMouseLeave'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseMove(EventCallback handler) {
    _attrs['onMouseMove'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseOver(EventCallback handler) {
    _attrs['onMouseOver'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onMouseOut(EventCallback handler) {
    _attrs['onMouseOut'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onContextMenu(EventCallback handler) {
    _attrs['onContextMenu'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Form Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onInput(EventCallback handler) {
    _attrs['onInput'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onChange(EventCallback handler) {
    _attrs['onChange'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onSubmit(EventCallback handler) {
    _attrs['onSubmit'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onFocus(EventCallback handler) {
    _attrs['onFocus'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onBlur(EventCallback handler) {
    _attrs['onBlur'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onFocusIn(EventCallback handler) {
    _attrs['onFocusIn'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onFocusOut(EventCallback handler) {
    _attrs['onFocusOut'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onReset(EventCallback handler) {
    _attrs['onReset'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onSelect(EventCallback handler) {
    _attrs['onSelect'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Keyboard Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onKeyDown(EventCallback handler) {
    _attrs['onKeyDown'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onKeyUp(EventCallback handler) {
    _attrs['onKeyUp'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onKeyPress(EventCallback handler) {
    _attrs['onKeyPress'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Drag & Drop Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onDrag(EventCallback handler) {
    _attrs['onDrag'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDragStart(EventCallback handler) {
    _attrs['onDragStart'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDragEnd(EventCallback handler) {
    _attrs['onDragEnd'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDragEnter(EventCallback handler) {
    _attrs['onDragEnter'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDragLeave(EventCallback handler) {
    _attrs['onDragLeave'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDragOver(EventCallback handler) {
    _attrs['onDragOver'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onDrop(EventCallback handler) {
    _attrs['onDrop'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Clipboard Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onCopy(EventCallback handler) {
    _attrs['onCopy'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onCut(EventCallback handler) {
    _attrs['onCut'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPaste(EventCallback handler) {
    _attrs['onPaste'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Media Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onPlay(EventCallback handler) {
    _attrs['onPlay'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPause(EventCallback handler) {
    _attrs['onPause'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onEnded(EventCallback handler) {
    _attrs['onEnded'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onTimeUpdate(EventCallback handler) {
    _attrs['onTimeUpdate'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onVolumeChange(EventCallback handler) {
    _attrs['onVolumeChange'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onLoadedData(EventCallback handler) {
    _attrs['onLoadedData'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onLoadedMetadata(EventCallback handler) {
    _attrs['onLoadedMetadata'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onCanPlay(EventCallback handler) {
    _attrs['onCanPlay'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onCanPlayThrough(EventCallback handler) {
    _attrs['onCanPlayThrough'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Scroll Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onScroll(EventCallback handler) {
    _attrs['onScroll'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onWheel(EventCallback handler) {
    _attrs['onWheel'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Touch Events (Mobile)
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onTouchStart(EventCallback handler) {
    _attrs['onTouchStart'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onTouchMove(EventCallback handler) {
    _attrs['onTouchMove'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onTouchEnd(EventCallback handler) {
    _attrs['onTouchEnd'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onTouchCancel(EventCallback handler) {
    _attrs['onTouchCancel'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Animation & Transition Events
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onAnimationStart(EventCallback handler) {
    _attrs['onAnimationStart'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onAnimationEnd(EventCallback handler) {
    _attrs['onAnimationEnd'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onAnimationIteration(EventCallback handler) {
    _attrs['onAnimationIteration'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onTransitionEnd(EventCallback handler) {
    _attrs['onTransitionEnd'] = EventAttribute.fromContext(handler);
    return this;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Pointer Events (Modern alternative to mouse/touch)
  // ──────────────────────────────────────────────────────────────────────────

  ElementBuilder onPointerDown(EventCallback handler) {
    _attrs['onPointerDown'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPointerUp(EventCallback handler) {
    _attrs['onPointerUp'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPointerMove(EventCallback handler) {
    _attrs['onPointerMove'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPointerEnter(EventCallback handler) {
    _attrs['onPointerEnter'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPointerLeave(EventCallback handler) {
    _attrs['onPointerLeave'] = EventAttribute.fromContext(handler);
    return this;
  }

  ElementBuilder onPointerCancel(EventCallback handler) {
    _attrs['onPointerCancel'] = EventAttribute.fromContext(handler);
    return this;
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
  ElementBuilder on(String event, EventCallback handler) {
    // Normalize event name to camelCase with 'on' prefix
    final eventName = event.startsWith('on')
        ? event
        : 'on${event[0].toUpperCase()}${event.substring(1)}';

    _attrs[eventName] = EventAttribute.fromContext(handler);
    return this;
  }

  /// Call operator for children
  Morphic call([List<dynamic>? children]) {
    // 🔑 Void elements no pueden tener children
    if (isVoid && children != null && children.isNotEmpty) {
      throw ArgumentError(
        '<$tag> is a void element and cannot have children. '
        'Use $tag() without arguments or $tag.attr() methods only.',
      );
    }

    final normalizedChildren = isVoid
        ? <Object>[]
        : _normalizeChildren(children ?? []);

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

  List<Object> _normalizeChildren(List<dynamic> children) {
    final result = <Object>[];

    for (final child in children) {
      if (child == null) {
        continue;
      } else if (child is String) {
        result.add(TextMorphic(child));
      } else if (child is num) {
        result.add(TextMorphic(child.toString()));
      } else if (child is Morphic) {
        result.add(child);
      } else if (child is Component) {
        result.add(child);
      } else if (child is Iterable) {
        result.addAll(_normalizeChildren(child.toList()));
      } else {
        throw ArgumentError(
          'Invalid child type: ${child.runtimeType}. '
          'Expected String, Morphic, Component, Iterable, or null.',
        );
      }
    }

    return result;
  }
}

// ==============================
// ContentElement (elementos con children)
// ==============================

/// Base class for elements that can have children and support text shorthand
class ContentElement extends ElementBuilder {
  ContentElement(super.tag, {super.key});
}

// ==============================
// VoidElement (elementos sin children)
// ==============================

/// Base class for void elements (cannot have children)
class VoidElement extends ElementBuilder {
  VoidElement(super.tag, {super.key}) : super(isVoid: true);
}
