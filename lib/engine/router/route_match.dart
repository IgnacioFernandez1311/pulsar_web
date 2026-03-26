import 'package:pulsar_web/pulsar.dart';

class RouteMatch {
  final Component component;
  final Map<String, String> params;

  const RouteMatch({required this.component, required this.params});
}
