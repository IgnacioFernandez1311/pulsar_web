import 'package:pulsar_web/pulsar.dart';

void patch(Node dom, Morphic prev, Morphic next) {
  // Sanity check: Estos árboles deben estar resueltos
  assert(
    _isResolved(prev),
    'prev tree contains unresolved Components. Call resolveNode() first.',
  );
  assert(
    _isResolved(next),
    'next tree contains unresolved Components. Call resolveNode() first.',
  );

  // Tipo distinto → reemplazo
  if (prev.runtimeType != next.runtimeType) {
    _replace(dom, createDom(next));
    return;
  }

  // Text
  if (prev is TextMorphic && next is TextMorphic) {
    if (prev.value != next.value) {
      (dom as Text).data = next.value;
    }
    return;
  }

  // Element
  if (prev is ElementMorphic && next is ElementMorphic) {
    if (prev.tag != next.tag) {
      _replace(dom, createDom(next));
      return;
    }

    final el = dom as Element;

    _patchAttributes(el, prev, next);

    // Cast children a List<Morphic> (safe porque está resuelto)
    final prevChildren = prev.children.cast<Morphic>();
    final nextChildren = next.children.cast<Morphic>();

    _patchChildren(el, prevChildren, nextChildren);
  }
}

// Helper para verificar que el árbol está resuelto
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
  final parent = oldNode.parentNode;
  if (parent == null) return;

  parent.replaceChild(newNode, oldNode);
}

void _patchAttributes(Element el, ElementMorphic prev, ElementMorphic next) {
  // remove old
  for (final key in prev.attributes.keys) {
    if (!next.attributes.containsKey(key)) {
      el.removeAttribute(key);
    }
  }

  // set/update new
  next.attributes.forEach((key, attr) {
    if (attr is StringAttribute) {
      el.setAttribute(key, attr.value);
    } else if (attr is BooleanAttribute) {
      if (attr.value) {
        el.setAttribute(key, '');
      } else {
        el.removeAttribute(key);
      }
    } else if (attr is ClassAttribute) {
      el.setAttribute('class', attr.classes);
    } else if (attr is StyleAttribute) {
      el.removeAttribute('style');
      final htmlElement = el as HTMLElement;
      attr.styles.forEach((prop, value) {
        htmlElement.style.setProperty(_toKebabCase(prop), value);
      });
    }
    // Note: EventAttribute listeners are bound at DOM creation time
    // and remain stable across morphs.
  });
}

String _toKebabCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '-${m.group(0)!.toLowerCase()}',
  );
}

class _KeyedChild {
  final Morphic vnode;
  final Node dom;

  _KeyedChild(this.vnode, this.dom);
}

void _patchChildren(Element el, List<Morphic> prev, List<Morphic> next) {
  final childNodes = el.childNodes;

  // ---- Indexar hijos viejos ----
  final oldKeyed = <Object, _KeyedChild>{};
  final oldUnkeyed = <_KeyedChild>[];

  for (int i = 0; i < prev.length; i++) {
    final vnode = prev[i];
    final dom = childNodes.item(i)!;

    if (vnode.key != null) {
      oldKeyed[vnode.key!] = _KeyedChild(vnode, dom);
    } else {
      oldUnkeyed.add(_KeyedChild(vnode, dom));
    }
  }

  Node? anchor;

  // ---- Reconciliar hijos nuevos ----
  for (int i = 0; i < next.length; i++) {
    final vnode = next[i];

    if (vnode.key != null && oldKeyed.containsKey(vnode.key)) {
      final entry = oldKeyed.remove(vnode.key)!;

      patch(entry.dom, entry.vnode, vnode);

      // mover si hace falta
      if (entry.dom != anchor?.nextSibling) {
        el.insertBefore(entry.dom, anchor?.nextSibling);
      }

      anchor = entry.dom;
    } else {
      // nuevo nodo
      final newDom = createDom(vnode);
      el.insertBefore(newDom, anchor?.nextSibling);
      anchor = newDom;
    }
  }

  // ---- Eliminar sobrantes ----
  for (final entry in oldKeyed.values) {
    final parent = entry.dom.parentNode;
    if (parent != null) {
      parent.removeChild(entry.dom);
    }
  }

  for (final entry in oldUnkeyed) {
    final parent = entry.dom.parentNode;
    if (parent != null) {
      parent.removeChild(entry.dom);
    }
  }
}
