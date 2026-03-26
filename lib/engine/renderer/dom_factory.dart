import 'package:pulsar_web/pulsar.dart';

Morphic assertNode(dynamic n) => n as Morphic;
Morphic assertDom(dynamic n) => n as Morphic;

Node createDom(Morphic node) {
  if (node is TextMorphic) {
    return document.createTextNode(node.value);
  }

  if (node is ElementMorphic) {
    final element = document.createElement(node.tag);

    // Set attributes
    node.attributes.forEach((key, attr) {
      if (attr is StringAttribute) {
        element.setAttribute(key, attr.value);
      } else if (attr is BooleanAttribute) {
        if (attr.value) {
          element.setAttribute(key, '');
        }
      } else if (attr is ClassAttribute) {
        element.setAttribute('class', attr.classes);
      } else if (attr is StyleAttribute) {
        final htmlElement = element as HTMLElement;
        attr.styles.forEach((key, value) {
          htmlElement.style.setProperty(_toKebabCase(key), value);
        });
      } else if (attr is EventAttribute) {
        final eventName = key.startsWith('on')
            ? key.substring(2).toLowerCase()
            : key;

        // 🔑 FIX: Guardar el runtime actual también
        final owner = attr.owner;
        final ownerRuntime = owner?.runtime; // Acceso a runtime privado

        final jsHandler = ((Event e) {
          if (owner != null && ownerRuntime != null) {
            // Restaurar AMBOS: runtime y component
            RenderContext.run(ownerRuntime, () {
              RenderContext.runWithComponent(owner, () {
                attr.callback(e);
              });
            });
          } else {
            // No owner, llamar directamente (pero no debería pasar)
            attr.callback(e);
          }
        }).toJS;

        element.addEventListener(eventName, jsHandler);
      }
    });

    // Create children
    final morphicChildren = node.children.cast<Morphic>();

    for (final child in morphicChildren) {
      element.append(createDom(child));
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
