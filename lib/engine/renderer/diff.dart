import 'package:universal_web/web.dart';

import 'package:pulsar_web/engine/node/node.dart';
import 'package:pulsar_web/engine/attribute/attribute.dart';

import 'dom_factory.dart';

void patch(Node dom, PulsarNode prev, PulsarNode next) {
  // Tipo distinto → reemplazo
  if (prev.runtimeType != next.runtimeType) {
    _replace(dom, createDom(next));
    return;
  }

  // Text
  if (prev is TextNode && next is TextNode) {
    if (prev.value != next.value) {
      (dom as Text).data = next.value;
    }
    return;
  }

  // Element
  if (prev is ElementNode && next is ElementNode) {
    if (prev.tag != next.tag) {
      _replace(dom, createDom(next));
      return;
    }

    final el = dom as Element;

    _patchAttributes(el, prev, next);
    _patchChildren(el, prev.children, next.children);
  }
}

void _replace(Node oldNode, Node newNode) {
  final parent = oldNode.parentNode;
  if (parent == null) return;

  parent.replaceChild(newNode, oldNode);
}

void _patchAttributes(Element el, ElementNode prev, ElementNode next) {
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
    }
  });
}

class _KeyedChild {
  final PulsarNode vnode;
  final Node dom;

  _KeyedChild(this.vnode, this.dom);
}

void _patchChildren(Element el, List<PulsarNode> prev, List<PulsarNode> next) {
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
