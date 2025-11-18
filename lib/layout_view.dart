import 'package:pulsar_web/content_view.dart';
import 'package:universal_web/web.dart';
import 'router.dart';
import 'view.dart';

abstract class LayoutView extends View {
  late final Router router;
  late HTMLElement content;

  final Map<String, String> _autoRoutes = {};

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
  Map<String, dynamic> get props => <String, dynamic>{'content': content};

  void route(String path, ContentView builder) {
    _autoRoutes[path] = _buildMethodName(path);

    router.define(path, builder);
  }

  String _buildMethodName(String path) {
    if (path == '/') return 'goToHome';

    final cleaned = path.replaceAll('/', '');
    final parts = cleaned.split('-');

    final capitalized = parts
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : '')
        .join('');

    return 'goTo$capitalized';
  }

  void navigateTo(String route) {
    router.navigateTo(route);
  }

  void defineRoutes() {}

  @override
  Map<String, Function> get methodRegistry {
    final reg = <String, Function>{};

    for (final entry in _autoRoutes.entries) {
      final path = entry.key;
      final fnName = entry.value;

      reg[fnName] = (_) => router.navigateTo(path);
    }

    return reg;
  }
}
