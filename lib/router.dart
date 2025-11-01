import 'package:universal_web/web.dart';
import 'content_view.dart';

class Router {
  final Map<String, ContentView Function()> _routes = {};
  ContentView? _currentView;
  final HTMLElement mountPoint;

  Router(this.mountPoint);

  void define(String path, ContentView builder) {
    _routes[path] = () => builder;
  }

  void start() {
    _loadCurrentPath();
    window.onPopState.listen((_) => _loadCurrentPath());
  }

  void navigateTo(String path) {
    window.history.pushState(null, '', path);
    _loadCurrentPath();
  }

  void clearMountPoint(HTMLElement mountPoint) {
  final List<Node> children = [];
  final NodeList nodeList = mountPoint.childNodes;

  // Creamos una copia de los nodos porque vamos a modificarlos
  for (int i = 0; i < nodeList.length; i++) {
    final Node? child = nodeList.item(i);
    if (child != null) {
      children.add(child);
    }
  }

  // Eliminamos cada hijo referenciando al padre
  for (final child in children) {
    mountPoint.removeChild(child);
  }
}

  void _loadCurrentPath() {
    final String path = window.location.pathname;
    final builder = _routes[path] ?? _routes['/'];

    if (builder == null) return;

    clearMountPoint(mountPoint);

    _currentView = builder();
    final HTMLElement newView = _currentView!.build();
    mountPoint.append(newView);
  }
}