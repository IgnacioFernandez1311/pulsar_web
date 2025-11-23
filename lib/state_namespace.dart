import 'package:pulsar_web/dynamic_namespace.dart';

class StateNamespace extends DynamicNamespace {
  StateNamespace(super.owner);

  @override
  dynamic handleGet(String key) {
    final exact = owner.states[key];
    if (exact != null) return exact;
    return owner.states[key.toLowerCase()];
  }

  @override
  dynamic handleSet(String key, value) {
    owner.updateState(key.toLowerCase(), value);
    return value;
  }
}
