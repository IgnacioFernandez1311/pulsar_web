import 'package:pulsar_web/pulsar.dart';
import 'package:pulsar_web/types.dart';
import 'package:universal_web/web.dart';

class Router {
  final List<Route> routes;
  final ComponentBuilder notFound;

  final Map<String, Component> _cache = {};

  Router({required this.routes, required this.notFound});

  Component resolve(String path) {
    return _cache.putIfAbsent(path, () {
      for (final route in routes) {
        if (route.path == path) {
          return route.builder();
        }
      }
      return notFound();
    });
  }
}

void navigateTo(String path) {
  window.history.pushState(null, '', path);
  RouterComponent.notifyNavigation();
}
