import 'package:pulsar_web/pulsar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mutable handler infrastructure
// ─────────────────────────────────────────────────────────────────────────────

/// A mutable wrapper around an [EventAttribute].
///
/// Registered once on the DOM element at mount time via [_registerHandler].
/// On every patch, only [attr] is swapped — the JS function reference never
/// changes, so no removeEventListener/addEventListener is needed.
///
/// This is what makes positional unkeyed diffing correct: the DOM node is
/// reused, the JS listener is reused, and the callback it delegates to is
/// always the latest one from the most recent render pass.
class _MutableHandler {
  EventAttribute attr;
  _MutableHandler(this.attr);
}

/// Per-element map of mutable handlers, keyed by attribute name (e.g. 'onClick').
/// Stored in an Expando so it lives alongside the DOM node without modifying it.
final _handlers = Expando<Map<String, _MutableHandler>>();

Map<String, _MutableHandler> _handlersFor(Element element) {
  return _handlers[element] ??= {};
}

/// Registers a new JS event listener backed by a [_MutableHandler].
///
/// The JS closure captures [wrapper] by reference. Swapping [wrapper.attr]
/// in [updateHandler] is all that's needed to redirect future events to a
/// new callback — no DOM mutation required.
void _registerHandler(Element element, String key, EventAttribute attr) {
  final eventName = key.startsWith('on') ? key.substring(2).toLowerCase() : key;

  final wrapper = _MutableHandler(attr);
  _handlersFor(element)[key] = wrapper;

  final jsHandler = ((Event e) {
    final a = wrapper.attr;
    final owner = a.owner;
    final ownerRuntime = owner?.componentRuntime;

    if (owner != null && ownerRuntime != null) {
      RenderContext.run(ownerRuntime, () {
        RenderContext.runWithComponent(owner, () {
          a.callback(e);
        });
      });
    } else {
      a.callback(e);
    }
  }).toJS;

  element.addEventListener(eventName, jsHandler);
}

/// Updates the handler wrapper for [key] on [element] with a new [attr].
///
/// Called by [_patchAttributes] in diff.dart whenever a DOM node is reused
/// at the same position. The JS listener stays registered — only the Dart
/// callback it delegates to is updated.
void updateHandler(Element element, String key, EventAttribute attr) {
  final map = _handlers[element];
  if (map != null && map.containsKey(key)) {
    map[key]!.attr = attr;
  } else {
    // Not yet registered — first time this event appears on this node.
    _registerHandler(element, key, attr);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// createDom
// ─────────────────────────────────────────────────────────────────────────────

/// Creates a real DOM [Node] from a resolved [Morphic] tree.
///
/// The optional [componentOwner] identifies which [Component] this element
/// is the root output of. When provided, the created node is registered with
/// the [ComponentRuntime] so that [requestUpdateFor] can diff it directly on
/// future morphs without traversing the full tree.
///
/// Pass [componentOwner] only for the root element of a component's render
/// output — never for nested elements within the same component.
Node createDom(Morphic node, {Component? componentOwner}) {
  if (node is TextMorphic) {
    return document.createTextNode(node.value);
  }

  if (node is ElementMorphic) {
    final element = document.createElement(node.tag);

    // ── Attributes ───────────────────────────────────────────────────────
    node.attributes.forEach((key, attr) {
      if (attr is StringAttribute) {
        element.setAttribute(key, attr.value);
      } else if (attr is BooleanAttribute) {
        if (attr.value) element.setAttribute(key, '');
      } else if (attr is ClassAttribute) {
        element.setAttribute('class', attr.classes);
      } else if (attr is StyleAttribute) {
        final htmlElement = element as HTMLElement;
        attr.styles.forEach((k, value) {
          htmlElement.style.setProperty(_toKebabCase(k), value);
        });
      } else if (attr is EventAttribute) {
        // Register via mutable wrapper so patch can update the callback
        // without touching the DOM listener registration.
        _registerHandler(element, key, attr);
      }
    });

    // ── Children ─────────────────────────────────────────────────────────
    final morphicChildren = node.children.cast<Morphic>();
    for (final child in morphicChildren) {
      element.append(createDom(child));
    }

    // ── Component node registration ───────────────────────────────────────
    if (componentOwner != null) {
      try {
        RenderContext.runtime.registerComponentDomNode(componentOwner, element);
      } catch (_) {
        // RenderContext not active in static render paths or tests.
      }
    }

    return element;
  }

  throw UnsupportedError('Unknown node type: ${node.runtimeType}');
}

String _toKebabCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '-${m.group(0)!.toLowerCase()}',
  );
}
