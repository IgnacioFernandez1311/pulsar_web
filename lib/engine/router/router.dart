import 'package:pulsar_web/pulsar.dart';
import 'package:pulsar_web/types.dart';

class Router {
  final List<Route> routes;
  final ComponentBuilder notFound;

  Router({required this.routes, required this.notFound});

  Component resolve(String path) {
    for (final route in routes) {
      final match = route.match(path);
      if (match != null) {
        return match.component;
      }
    }
    return notFound();
  }
}

void navigateTo(String path) {
  window.history.pushState(null, '', path);
  RouterComponent.notifyNavigation();
}
