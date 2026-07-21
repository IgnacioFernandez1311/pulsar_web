import 'package:pulsar_web/pulsar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mutable handler infrastructure
// ─────────────────────────────────────────────────────────────────────────────

class _MutableHandler {
  EventAttribute attr;
  _MutableHandler(this.attr);
}

final _handlers = Expando<Map<String, _MutableHandler>>();

Map<String, _MutableHandler> _handlersFor(Element element) {
  return _handlers[element] ??= {};
}

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

void updateHandler(Element element, String key, EventAttribute attr) {
  final map = _handlers[element];
  if (map != null && map.containsKey(key)) {
    map[key]!.attr = attr;
  } else {
    _registerHandler(element, key, attr);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// createDom
// ─────────────────────────────────────────────────────────────────────────────

/// Creates a single DOM [Node] from a fully resolved [Morphic].
///
/// ## owners parameter
///
/// [owners] is the map produced by [resolveNode] that pairs each component's
/// root [Morphic] to its [Component]. It is passed explicitly here rather than
/// being read from shared mutable state. This makes the data flow visible:
/// resolveNode produces owners, createDom consumes them, ComponentRuntime
/// stores the resulting DOM nodes.
///
/// ## Two-phase invariant
///
/// [resolveNode] never creates DOM. [createDom] never resolves Components.
/// Every [Morphic] passed here must be fully resolved — no [Component]
/// instances should remain in the children list.
Node createDom(
  Morphic node, {
  Component? componentOwner,
  Map<Morphic, Component> owners = const {},
}) {
  if (node is FragmentMorphic) {
    throw UnsupportedError(
      'createDom cannot produce a single Node from FragmentMorphic. '
      'Use createDomNodes() when iterating children that may include fragments.',
    );
  }

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
        _registerHandler(element, key, attr);
      } else if (attr is InnerHtmlAttribute) {
        // Inject pre-parsed HTML directly. Children are ignored when this
        // attribute is present — the raw HTML becomes the full content.
        (element as HTMLElement).setHTMLUnsafe(attr.html.toJS);
      }
    });

    // ── Children ─────────────────────────────────────────────────────────
    // Children are fully resolved Morphic — no Components remain.
    // Fragments expand into multiple sibling nodes via createDomNodes.
    // owners is consulted to find the owning Component for each child
    // that is a component's root — no shared mutable state needed.
    for (final child in node.children.cast<Morphic>()) {
      final childOwner = owners[child];
      for (final domNode in createDomNodes(
        child,
        componentOwner: childOwner,
        owners: owners,
      )) {
        element.append(domNode);
      }
    }

    // ── Component node registration ───────────────────────────────────────
    if (componentOwner != null) {
      try {
        RenderContext.runtime.registerComponentDomNode(componentOwner, element);
      } catch (_) {
        // RenderContext not active in static paths or tests — safe to ignore.
      }
    }

    return element;
  }

  throw UnsupportedError('Unknown Morphic type: ${node.runtimeType}');
}

/// Creates one or more DOM nodes from a resolved [Morphic].
///
/// For [FragmentMorphic], expands into one node per child recursively.
/// For all other types, returns a single-element list.
///
/// Use this whenever iterating children that may contain fragments.
List<Node> createDomNodes(
  Morphic node, {
  Component? componentOwner,
  Map<Morphic, Component> owners = const {},
}) {
  if (node is FragmentMorphic) {
    final nodes = <Node>[];
    for (final child in node.children) {
      final childOwner = owners[child];
      nodes.addAll(
        createDomNodes(child, componentOwner: childOwner, owners: owners),
      );
    }
    return nodes;
  }

  return [createDom(node, componentOwner: componentOwner, owners: owners)];
}

String _toKebabCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '-${m.group(0)!.toLowerCase()}',
  );
}
