import 'package:pulsar/pulsar.dart';

typedef ComponentFactory = Component Function();

class Registry {
  static final Map<String, ComponentFactory> _registry = {};

  static void register(String name, ComponentFactory componentFactory) {
    _registry[name] = componentFactory;
  }

  static Component? create(String name) {
    final ComponentFactory? componentFactory = _registry[name];
    return componentFactory != null ? componentFactory() : null;
  }

  static bool isRegistered(String name) => _registry.containsKey(name);

  static void clear() => _registry.clear();
}
