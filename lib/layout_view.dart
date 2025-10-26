import 'package:universal_web/web.dart';
import 'router.dart';
import 'view.dart';

abstract class LayoutView extends View {
  late final Router router;
  late HTMLElement content;

  LayoutView() {
    final HTMLElement slot = document.createElement('div') as HTMLElement;
    router = Router(slot);

    defineRoutes();
    router.start();
    content = router.mountPoint;
  }
  @override
  Future<String> get template;

  @override
  Map<String, dynamic> get props => {
    'content': content,
  };

  void navigateTo(String route) {
    router.navigateTo(route);
  }

  void defineRoutes() {}
}