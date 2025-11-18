import '../app_root/app_root.dart';
import '../about/about.dart';
import 'package:pulsar_web/pulsar.dart';

class MainLayout extends LayoutView {
  @override
  Future<String> get template async =>
      await loadFile("views/main_layout/main_layout.html");

  @override
  void defineRoutes() {
    route('/', AppRoot());
    route('/about', AboutView());
  }
}
