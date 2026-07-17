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
    _replaceAll(dom, prev, next);
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
    return;
  }

  // Fragment → fragment: patch each child in-place via the parent element.
  // The fragment itself has no DOM node — we need its parent to operate on.
  if (prev is FragmentMorphic && next is FragmentMorphic) {
    // Fragment-level patch is handled entirely by _patchChildren of the
    // parent element — fragments expand into their children inline.
    // This branch is only reached if patch() is called directly on a
    // fragment, which should not happen in normal operation.
    return;
  }
}

bool _isResolved(Morphic node) {
  if (node is ElementMorphic) {
    for (final child in node.children) {
      if (child is Component) return false;
      if (child is Morphic && !_isResolved(child)) return false;
    }
  }
  if (node is FragmentMorphic) {
    for (final child in node.children) {
      if (!_isResolved(child)) return false;
    }
  }
  return true;
}

void _replace(Node oldNode, Node newNode) {
  oldNode.parentNode?.replaceChild(newNode, oldNode);
}

/// Replaces all DOM nodes produced by [prev] with those produced by [next].
/// Used when prev and next have different runtimeTypes — including when one
/// is a fragment and the other is not.
void _replaceAll(Node firstDom, Morphic prev, Morphic next) {
  final parent = firstDom.parentNode;
  if (parent == null) return;

  // Collect all DOM nodes that prev occupies (fragment may span multiple)
  final oldNodes = _domNodesFor(firstDom, prev);

  // Create new DOM for next
  final newNodes = _createDomNodes(next);

  // Insert new nodes before the first old node
  final anchor = oldNodes.first;
  for (final newNode in newNodes) {
    parent.insertBefore(newNode, anchor);
  }

  // Remove old nodes
  for (final old in oldNodes) {
    parent.removeChild(old);
  }
}

/// Returns the list of DOM nodes that [morphic] occupies starting at [dom].
/// For a fragment, this is multiple sibling nodes. For anything else, it's one.
List<Node> _domNodesFor(Node dom, Morphic morphic) {
  if (morphic is FragmentMorphic) {
    final nodes = <Node>[];
    Node? current = dom;
    for (int i = 0; i < morphic.children.length && current != null; i++) {
      final childCount = _domNodeCount(morphic.children[i]);
      for (int j = 0; j < childCount && current != null; j++) {
        nodes.add(current);
        current = current.nextSibling;
      }
    }
    return nodes;
  }
  return [dom];
}

/// Returns how many real DOM nodes a Morphic occupies.
/// Fragment → N nodes (one per child, recursively).
/// Everything else → 1 node.
int _domNodeCount(Morphic morphic) {
  if (morphic is FragmentMorphic) {
    return morphic.children.fold(0, (sum, c) => sum + _domNodeCount(c));
  }
  return 1;
}

/// Creates the DOM node(s) for [morphic].
/// Fragment → multiple nodes. Everything else → one node.
List<Node> _createDomNodes(Morphic morphic) {
  if (morphic is FragmentMorphic) {
    final nodes = <Node>[];
    for (final child in morphic.children) {
      nodes.addAll(_createDomNodes(child));
    }
    return nodes;
  }
  return [createDom(morphic)];
}

void _patchAttributes(Element el, ElementMorphic prev, ElementMorphic next) {
  for (final key in prev.attributes.keys) {
    if (!next.attributes.containsKey(key)) {
      el.removeAttribute(key);
      _resetDomProperty(el, key);
    }
  }

  next.attributes.forEach((key, attr) {
    if (attr is StringAttribute) {
      el.setAttribute(key, attr.value);
      _setDomProperty(el, key, attr.value);
    } else if (attr is BooleanAttribute) {
      if (attr.value) {
        el.setAttribute(key, '');
      } else {
        el.removeAttribute(key);
      }
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

void _setDomProperty(Element el, String key, String value) {
  switch (key) {
    case 'value':
      if (el is HTMLInputElement) {
        el.value = value;
      } else if (el is HTMLTextAreaElement) {
        el.value = value;
      }
    default:
      break;
  }
}

void _setDomBooleanProperty(Element el, String key, bool value) {
  switch (key) {
    case 'checked':
      if (el is HTMLInputElement) {
        el.checked = value;
      }
    case 'disabled':
      if (el is HTMLInputElement) {
        el.disabled = value;
      } else if (el is HTMLButtonElement) {
        el.disabled = value;
      } else if (el is HTMLSelectElement) {
        el.disabled = value;
      } else if (el is HTMLTextAreaElement) {
        el.disabled = value;
      }
    case 'selected':
      if (el is HTMLOptionElement) {
        el.selected = value;
      }
    default:
      break;
  }
}

void _resetDomProperty(Element el, String key) {
  switch (key) {
    case 'checked':
      if (el is HTMLInputElement) {
        el.checked = false;
      }
    case 'value':
      if (el is HTMLInputElement) {
        el.value = '';
      } else if (el is HTMLTextAreaElement) {
        el.value = '';
      }
    case 'disabled':
      if (el is HTMLInputElement) {
        el.disabled = false;
      } else if (el is HTMLButtonElement) {
        el.disabled = false;
      } else if (el is HTMLSelectElement) {
        el.disabled = false;
      } else if (el is HTMLTextAreaElement) {
        el.disabled = false;
      }
    case 'selected':
      if (el is HTMLOptionElement) {
        el.selected = false;
      }
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

// ─────────────────────────────────────────────────────────────────────────────
// _patchChildren
// ─────────────────────────────────────────────────────────────────────────────

/// A flattened representation of a child slot in the DOM.
///
/// A [_Slot] corresponds to a single Morphic node in the logical tree, but
/// may occupy one or more real DOM nodes (fragments expand into N siblings).
class _Slot {
  /// The Morphic node (may be a FragmentMorphic).
  final Morphic vnode;

  /// The first real DOM node this slot occupies.
  final Node dom;

  /// All DOM nodes this slot occupies (>1 for fragments).
  final List<Node> domNodes;

  _Slot(this.vnode, this.dom, this.domNodes);
}

void _patchChildren(Element el, List<Morphic> prev, List<Morphic> next) {
  // Build a flat list of slots from prev, each mapping one Morphic to its
  // DOM node(s). Fragments expand into their children inline.
  final oldKeyed = <Object, _Slot>{};
  final oldUnkeyed = <_Slot>[];

  // Walk the actual DOM children in sync with the prev Morphic list.
  // Each Morphic in prev corresponds to one or more DOM childNodes.
  int domIndex = 0;
  final childNodes = el.childNodes;

  for (final vnode in prev) {
    final count = _domNodeCount(vnode);
    final domNodes = <Node>[];
    for (int i = 0; i < count && domIndex < childNodes.length; i++) {
      domNodes.add(childNodes.item(domIndex++)!);
    }

    if (domNodes.isEmpty) continue;

    final slot = _Slot(vnode, domNodes.first, domNodes);

    if (vnode.key != null) {
      oldKeyed[vnode.key!] = slot;
    } else {
      oldUnkeyed.add(slot);
    }
  }

  int unkeyedCursor = 0;
  Node? anchor;

  for (final vnode in next) {
    if (vnode.key != null) {
      // ── Keyed ──────────────────────────────────────────────────────────
      if (oldKeyed.containsKey(vnode.key)) {
        final slot = oldKeyed.remove(vnode.key)!;
        _patchSlot(el, slot, vnode);

        if (slot.dom != anchor?.nextSibling) {
          for (final node in slot.domNodes) {
            el.insertBefore(node, anchor?.nextSibling);
          }
        }
        anchor = slot.domNodes.last;
      } else {
        // New keyed node
        final newNodes = _createDomNodes(vnode);
        for (final node in newNodes) {
          el.insertBefore(node, anchor?.nextSibling);
        }
        anchor = newNodes.last;
      }
    } else {
      // ── Unkeyed — patch by position ─────────────────────────────────────
      if (unkeyedCursor < oldUnkeyed.length) {
        final slot = oldUnkeyed[unkeyedCursor++];

        if (_canPatchInPlace(slot.vnode, vnode)) {
          _patchSlot(el, slot, vnode);
          anchor = slot.domNodes.last;
        } else {
          // Different type or tag — replace all DOM nodes for this slot
          final newNodes = _createDomNodes(vnode);
          final insertBefore = slot.dom;
          for (final node in newNodes) {
            el.insertBefore(node, insertBefore);
          }
          for (final old in slot.domNodes) {
            el.removeChild(old);
          }
          anchor = newNodes.last;
        }
      } else {
        // No existing slot — append
        final newNodes = _createDomNodes(vnode);
        for (final node in newNodes) {
          el.insertBefore(node, anchor?.nextSibling);
        }
        anchor = newNodes.last;
      }
    }
  }

  // Remove leftover keyed slots
  for (final slot in oldKeyed.values) {
    for (final node in slot.domNodes) {
      node.parentNode?.removeChild(node);
    }
  }

  // Remove leftover unkeyed slots
  for (int i = unkeyedCursor; i < oldUnkeyed.length; i++) {
    for (final node in oldUnkeyed[i].domNodes) {
      node.parentNode?.removeChild(node);
    }
  }
}

/// Returns true if [prev] and [next] can be patched in-place.
/// Requires matching runtime type and, for elements, matching tag.
bool _canPatchInPlace(Morphic prev, Morphic next) {
  if (prev.runtimeType != next.runtimeType) return false;
  if (prev is ElementMorphic && next is ElementMorphic) {
    return prev.tag == next.tag;
  }
  // FragmentMorphic → FragmentMorphic: always patch in-place
  // TextMorphic → TextMorphic: always patch in-place
  return true;
}

/// Patches [slot] (which may be a fragment) in-place against [next].
void _patchSlot(Element parent, _Slot slot, Morphic next) {
  if (slot.vnode is FragmentMorphic && next is FragmentMorphic) {
    _patchFragment(parent, slot, next);
    return;
  }

  // Single node patch — delegate to patch()
  patch(slot.dom, slot.vnode, next);
}

/// Patches a fragment slot in-place.
///
/// Treats the fragment's children as a nested child list anchored in [parent].
/// This allows fragments to grow, shrink, and update their children
/// independently without affecting sibling nodes outside the fragment.
void _patchFragment(Element parent, _Slot slot, FragmentMorphic next) {
  final prevFrag = slot.vnode as FragmentMorphic;
  final prevChildren = prevFrag.children;
  final nextChildren = next.children;

  // Build unkeyed pool from the slot's DOM nodes, one per prev child
  int domIdx = 0;
  final oldUnkeyed = <_Slot>[];
  final oldKeyed = <Object, _Slot>{};

  for (final child in prevChildren) {
    final count = _domNodeCount(child);
    final nodes = slot.domNodes.sublist(
      domIdx,
      (domIdx + count).clamp(0, slot.domNodes.length),
    );
    domIdx += count;
    if (nodes.isEmpty) continue;

    final childSlot = _Slot(child, nodes.first, nodes);
    if (child.key != null) {
      oldKeyed[child.key!] = childSlot;
    } else {
      oldUnkeyed.add(childSlot);
    }
  }

  int unkeyedCursor = 0;
  Node? anchor = slot.domNodes.isNotEmpty
      ? slot.domNodes.first.previousSibling
      : null;

  for (final child in nextChildren) {
    if (child.key != null && oldKeyed.containsKey(child.key)) {
      final childSlot = oldKeyed.remove(child.key)!;
      _patchSlot(parent, childSlot, child);
      anchor = childSlot.domNodes.last;
    } else if (unkeyedCursor < oldUnkeyed.length) {
      final childSlot = oldUnkeyed[unkeyedCursor++];
      if (_canPatchInPlace(childSlot.vnode, child)) {
        _patchSlot(parent, childSlot, child);
        anchor = childSlot.domNodes.last;
      } else {
        final newNodes = _createDomNodes(child);
        for (final node in newNodes) {
          parent.insertBefore(node, childSlot.dom);
        }
        for (final old in childSlot.domNodes) {
          parent.removeChild(old);
        }
        anchor = newNodes.last;
      }
    } else {
      final newNodes = _createDomNodes(child);
      for (final node in newNodes) {
        parent.insertBefore(node, anchor?.nextSibling);
      }
      anchor = newNodes.last;
    }
  }

  for (final childSlot in oldKeyed.values) {
    for (final node in childSlot.domNodes) {
      node.parentNode?.removeChild(node);
    }
  }

  for (int i = unkeyedCursor; i < oldUnkeyed.length; i++) {
    for (final node in oldUnkeyed[i].domNodes) {
      node.parentNode?.removeChild(node);
    }
  }
}
