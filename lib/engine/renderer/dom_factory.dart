import 'package:pulsar_web/engine/attribute/attribute.dart';
import 'package:pulsar_web/engine/node/node.dart';
import 'dart:js_interop';
import 'package:universal_web/web.dart';

PulsarNode assertNode(dynamic n) => n as PulsarNode;
PulsarNode assertDom(dynamic n) => n as PulsarNode;

Node createDom(PulsarNode node) {
  if (node is TextNode) {
    return document.createTextNode(node.value);
  }

  if (node is ElementNode) {
    final element = document.createElement(node.tag);

    node.attributes.forEach((key, attr) {
      // Atributos string genéricos
      if (attr is StringAttribute) {
        element.setAttribute(key, attr.value);
      } else if (attr is ClassAttribute) {
        element.setAttribute('class', attr.classes);
      } else if (attr is StyleAttribute) {
        final htmlElement = element as HTMLElement;

        for (final entry in attr.styles.entries) {
          htmlElement.style.setProperty(_toKebabCase(entry.key), entry.value);
        }
      }
      // Eventos
      else if (attr is EventAttribute) {
        final eventName = key.startsWith('on')
            ? key.substring(2).toLowerCase()
            : key;

        final jsHandler = ((Event e) {
          attr.callback(e);
        }).toJS;

        element.addEventListener(eventName, jsHandler);
      }
    });

    for (final child in node.children) {
      element.append(createDom(child));
    }

    return element;
  }

  throw UnsupportedError('Unknown node type: $node');
}

String _toKebabCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '-${m.group(0)!.toLowerCase()}',
  );
}
