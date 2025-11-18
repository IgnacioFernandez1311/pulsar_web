import 'package:pulsar_web/dynamic_namespace.dart';

class PropNamespace extends DynamicNamespace {
  PropNamespace(super.owner);

  @override
  dynamic handleGet(String key) {
    // 1) intento exacto
    final exact = owner.props[key];
    if (exact != null) return exact;

    // 2) intento lowercase (DOM attributes)
    final lower = owner.props[key.toLowerCase()];
    if (lower != null) return lower;

    // 3) fallback null
    return null;
  }

  @override
  dynamic handleSet(String key, value) {
    // Guardar en forma exacta y en lowercase para que ambas búsquedas funcionen
    owner.propsRegistry[key] = value;
    owner.propsRegistry[key.toLowerCase()] = value;
    return value;
  }
}
