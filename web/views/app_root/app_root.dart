import 'package:pulsar_web/pulsar.dart';
import '../../components/counter/counter_app.dart';

class AppRoot extends ContentView {
  @override
  List<Renderable Function()> get imports => [
    () => CounterApp()
  ];
  @override
  Future<String> get template async =>
      await loadFile('views/app_root/app_root.html');
}
