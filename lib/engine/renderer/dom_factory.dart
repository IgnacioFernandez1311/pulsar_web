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

/// Creates a single DOM [Node] from a resolved [Morphic].
///
/// [FragmentMorphic] cannot be passed here directly — fragments produce
/// multiple sibling nodes and have no single root. Use [createDomNodes]
/// when the caller may encounter a fragment.
///
/// The optional [componentOwner] marks the root element as belonging to
/// a specific [Component], registering it with the [ComponentRuntime] for
/// granular diffing. For child components, ownership is looked up via
/// [ComponentRuntime.ownerOf].
Node createDom(Morphic node, {Component? componentOwner}) {
  if (node is FragmentMorphic) {
    throw UnsupportedError(
      'createDom cannot create a single node from FragmentMorphic. '
      'Use createDomNodes() instead, or ensure fragments are only used '
      'as children of an ElementMorphic.',
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
      }
    });

    // ── Children ─────────────────────────────────────────────────────────
    // Each child may be a fragment — use createDomNodes to expand them.
    final morphicChildren = node.children.cast<Morphic>();
    for (final child in morphicChildren) {
      Component? childOwner;
      try {
        childOwner = RenderContext.runtime.ownerOf(child);
      } catch (_) {}

      for (final domNode in createDomNodes(child, componentOwner: childOwner)) {
        element.append(domNode);
      }
    }

    // ── Component node registration ───────────────────────────────────────
    if (componentOwner != null) {
      try {
        RenderContext.runtime.registerComponentDomNode(componentOwner, element);
      } catch (_) {}
    }

    return element;
  }

  throw UnsupportedError('Unknown node type: ${node.runtimeType}');
}

/// Creates one or more DOM nodes from a resolved [Morphic].
///
/// For [FragmentMorphic], returns one node per child (recursively expanded).
/// For all other Morphic types, returns a single-element list.
///
/// This is the correct entry point when iterating children that may include
/// fragments — both in [createDom] and in [diff.dart]'s [_createDomNodes].
List<Node> createDomNodes(Morphic node, {Component? componentOwner}) {
  if (node is FragmentMorphic) {
    final nodes = <Node>[];
    for (final child in node.children) {
      Component? childOwner;
      try {
        childOwner = RenderContext.runtime.ownerOf(child);
      } catch (_) {}
      nodes.addAll(createDomNodes(child, componentOwner: childOwner));
    }
    return nodes;
  }

  return [createDom(node, componentOwner: componentOwner)];
}

String _toKebabCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '-${m.group(0)!.toLowerCase()}',
  );
}
