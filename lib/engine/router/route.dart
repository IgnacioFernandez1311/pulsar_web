import 'package:pulsar_web/pulsar.dart';
import 'package:pulsar_web/engine/router/route_match.dart';
import 'package:pulsar_web/types.dart';

class Route {
  final String path;
  final Component Function(ParamsContext params) builder;
  final bool catchAll;

  late final RegExp _regex;
  late final List<String> _paramNames;

  Route({required this.path, required this.builder, this.catchAll = false}) {
    final names = <String>[];

    var pattern = path.replaceAllMapped(RegExp(r':(\w+)'), (m) {
      names.add(m.group(1)!);
      return '([^/]+)';
    });

    _paramNames = names;

    // if catchAll, matches prefix and every next route
    if (catchAll) {
      _regex = RegExp('^$pattern(/.*)?'); // Match /docs, /docs/, /docs/anything
    } else {
      _regex = RegExp('^$pattern\$');
    }
  }

  RouteMatch? match(String path) {
    final match = _regex.firstMatch(path);
    if (match == null) return null;

    final params = <String, String>{};
    for (var i = 0; i < _paramNames.length; i++) {
      params[_paramNames[i]] = match.group(i + 1)!;
    }

    return RouteMatch(component: builder(params), params: params);
  }
}
