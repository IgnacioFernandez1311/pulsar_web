import 'package:pulsar_web/pulsar.dart';
import 'counter/counter_app.dart';
import 'app_root/app_root.dart';

class ComponentProvider extends Provider {
  @override
  void registerComponents() {
    register("CounterApp", () => CounterApp());
    register("AppRoot", () => AppRoot());
  }
}
