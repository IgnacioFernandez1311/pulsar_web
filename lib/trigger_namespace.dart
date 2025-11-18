import 'package:pulsar_web/dynamic_namespace.dart';

typedef PulsarCallback = dynamic Function(dynamic e);

class TriggerNamespace extends DynamicNamespace {
  TriggerNamespace(super.owner);

  @override
  dynamic handleGet(String key) {
    return owner.methodRegistry[key];
  }

  @override
  dynamic handleSet(String key, dynamic value) {
    if (value is Function) {
      owner.methodRegistry[key] = (e) => value(e);
      return value;
    }
    throw ArgumentError("Triggers must be functions");
  }
}
