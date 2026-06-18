import 'package:pulsar_web/pulsar.dart';

void patch(Node dom, Morphic prev, Morphic next) {
  assert(
    _isResolved(prev),
    'prev tree contains unresolved Components. Call resolveNode() first.',
  );
  assert(
    _isResolved(next),
    'next tree contains unresolved Components. Call resolveNode() first.',
  );

  if (prev.runtimeType != next.runtimeType) {
    _replace(dom, createDom(next));
    return;
  }

  if (prev is TextMorphic && next is TextMorphic) {
    if (prev.value != next.value) {
      (dom as Text).data = next.value;
    }
    return;
  }

  if (prev is ElementMorphic && next is ElementMorphic) {
    if (prev.tag != next.tag) {
      _replace(dom, createDom(next));
      return;
    }

    final el = dom as Element;
    _patchAttributes(el, prev, next);

    final prevChildren = prev.children.cast<Morphic>();
    final nextChildren = next.children.cast<Morphic>();
    _patchChildren(el, prevChildren, nextChildren);
  }
}

bool _isResolved(Morphic node) {
  if (node is ElementMorphic) {
    for (final child in node.children) {
      if (child is Component) return false;
      if (child is Morphic && !_isResolved(child)) return false;
    }
  }
  return true;
}

void _replace(Node oldNode, Node newNode) {
  oldNode.parentNode?.replaceChild(newNode, oldNode);
}

void _patchAttributes(Element el, ElementMorphic prev, ElementMorphic next) {
  // Remove attributes that no longer exist
  for (final key in prev.attributes.keys) {
    if (!next.attributes.containsKey(key)) {
      el.removeAttribute(key);

      // When removing a form property attribute, also reset the DOM property.
      // The browser tracks these independently from HTML attributes after
      // the first render — setAttribute/removeAttribute alone is not enough.
      _resetDomProperty(el, key);
    }
  }

  // Set/update attributes
  next.attributes.forEach((key, attr) {
    if (attr is StringAttribute) {
      el.setAttribute(key, attr.value);

      // For value/checked/selected, also set the DOM property directly.
      // This is what the browser actually uses for current state — the
      // HTML attribute is only the initial value.
      _setDomProperty(el, key, attr.value);
    } else if (attr is BooleanAttribute) {
      if (attr.value) {
        el.setAttribute(key, '');
      } else {
        el.removeAttribute(key);
      }

      // Always sync the DOM property regardless of true/false,
      // so the visual state matches the Morphic tree exactly.
      _setDomBooleanProperty(el, key, attr.value);
    } else if (attr is ClassAttribute) {
      el.setAttribute('class', attr.classes);
    } else if (attr is StyleAttribute) {
      el.removeAttribute('style');
      final htmlElement = el as HTMLElement;
      attr.styles.forEach((prop, value) {
        htmlElement.style.setProperty(_toKeyBase(prop), value);
      });
    } else if (attr is EventAttribute) {
      updateHandler(el, key, attr);
    }
  });
}

/// Sets a DOM property directly for attributes where the browser distinguishes
/// between the HTML attribute (initial value) and the JS property (live state).
void _setDomProperty(Element el, String key, String value) {
  switch (key) {
    case 'value':
      // HTMLInputElement.value, HTMLTextAreaElement.value, HTMLSelectElement.value
      if (el is HTMLInputElement) el.value = value;
    // ignore: no_default_cases
    default:
      break;
  }
}

/// Sets a boolean DOM property directly.
void _setDomBooleanProperty(Element el, String key, bool value) {
  switch (key) {
    case 'checked':
      if (el is HTMLInputElement) el.checked = value;
    case 'disabled':
      if (el is HTMLInputElement)
        el.disabled = value;
      else if (el is HTMLButtonElement)
        el.disabled = value;
      else if (el is HTMLSelectElement)
        el.disabled = value;
      else if (el is HTMLTextAreaElement)
        el.disabled = value;
    case 'selected':
      if (el is HTMLOptionElement) el.selected = value;
    // ignore: no_default_cases
    default:
      break;
  }
}

/// Resets a DOM property to its default when the attribute is removed.
void _resetDomProperty(Element el, String key) {
  switch (key) {
    case 'checked':
      if (el is HTMLInputElement) el.checked = false;
    case 'value':
      if (el is HTMLInputElement) el.value = '';
    case 'disabled':
      if (el is HTMLInputElement)
        el.disabled = false;
      else if (el is HTMLButtonElement)
        el.disabled = false;
      else if (el is HTMLSelectElement)
        el.disabled = false;
      else if (el is HTMLTextAreaElement)
        el.disabled = false;
    case 'selected':
      if (el is HTMLOptionElement) el.selected = false;
    // ignore: no_default_cases
    default:
      break;
  }
}

String _toKeyBase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (match) => '-${match.group(0)!.toLowerCase()}',
  );
}

class _KeyedChild {
  final Morphic vnode;
  final Node dom;
  _KeyedChild(this.vnode, this.dom);
}

void _patchChildren(Element el, List<Morphic> prev, List<Morphic> next) {
  final oldKeyed = <Object, _KeyedChild>{};
  final oldUnkeyed = <_KeyedChild>[];
  final childNodes = el.childNodes;

  for (int i = 0; i < prev.length; i++) {
    final vnode = prev[i];
    final dom = childNodes.item(i)!;

    if (vnode.key != null) {
      oldKeyed[vnode.key!] = _KeyedChild(vnode, dom);
    } else {
      oldUnkeyed.add(_KeyedChild(vnode, dom));
    }
  }

  int unkeyedCursor = 0;
  Node? anchor;

  for (int i = 0; i < next.length; i++) {
    final vnode = next[i];

    if (vnode.key != null) {
      // ── Keyed ──────────────────────────────────────────────────────────
      if (oldKeyed.containsKey(vnode.key)) {
        final entry = oldKeyed.remove(vnode.key)!;
        patch(entry.dom, entry.vnode, vnode);

        if (entry.dom != anchor?.nextSibling) {
          el.insertBefore(entry.dom, anchor?.nextSibling);
        }
        anchor = entry.dom;
      } else {
        final newDom = createDom(vnode);
        el.insertBefore(newDom, anchor?.nextSibling);
        anchor = newDom;
      }
    } else {
      // ── Unkeyed — patch by position ─────────────────────────────────────
      if (unkeyedCursor < oldUnkeyed.length) {
        final entry = oldUnkeyed[unkeyedCursor++];

        if (entry.vnode is ElementMorphic &&
            vnode is ElementMorphic &&
            (entry.vnode as ElementMorphic).tag == vnode.tag) {
          patch(entry.dom, entry.vnode, vnode);
          anchor = entry.dom;
        } else {
          final newDom = createDom(vnode);
          el.replaceChild(newDom, entry.dom);
          anchor = newDom;
        }
      } else {
        final newDom = createDom(vnode);
        el.insertBefore(newDom, anchor?.nextSibling);
        anchor = newDom;
      }
    }
  }

  // Remove leftover keyed nodes
  for (final entry in oldKeyed.values) {
    entry.dom.parentNode?.removeChild(entry.dom);
  }

  // Remove unkeyed nodes beyond next's length
  for (int i = unkeyedCursor; i < oldUnkeyed.length; i++) {
    oldUnkeyed[i].dom.parentNode?.removeChild(oldUnkeyed[i].dom);
  }
}
