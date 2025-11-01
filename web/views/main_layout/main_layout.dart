import '../app_root/app_root.dart';
import '../about/about.dart';
import 'package:pulsar_web/pulsar.dart';

class MainLayout extends LayoutView {
  @override
  Future<String> get template async => await loadFile("views/main_layout/main_layout.html");

  @override
  Map<String, Function> get methodRegistry => {
        'goHome': (_) => router.navigateTo('/'),
        'goAbout': goAbout
      };

  void goAbout(PulsarEvent event) => router.navigateTo('/about');

  @override
  void defineRoutes() {
    router.define('/', AppRoot());
    router.define('/about', AboutView());
  }
}