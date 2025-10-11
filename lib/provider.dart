import 'package:pulsar_web/core.dart';
import 'registry.dart';

/// Class to provide a way to register the components.
/// Use the `registerComponents()` function to register the components you want in the Registry. Note that if you register a component, you must clear the Registry if you don't want to have stacked components in memory. Use this class with the following syntax
/// ```dart
///class ComponentProvider extends Provider {
///  @override
///  void registerComponents() {
///    register("ComponentName", () => ComponentName());
///  }
///}
/// ```
abstract class Provider {
  void registerComponents();

  /// Function to register a component into the Registry.
  /// Use this method passing the name you want to insert in the `{% insert %}` tag with the following syntax
  /// ```dart
  /// register("ComponentName", () => ComponentName());
  /// ```
  void register<T extends Component>(
    String name,
    Component Function() componentFactory,
  ) {
    Registry.register(name, componentFactory);
  }
}
