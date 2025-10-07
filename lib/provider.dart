import 'package:pulsar/core.dart';
import 'registry.dart';

abstract class Provider {
  void registerComponents();

  void register<T extends Component>(
    String name,
    Component Function() componentFactory,
  ) {
    Registry.register(name, componentFactory);
  }
}
