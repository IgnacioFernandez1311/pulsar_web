import 'package:pulsar_web/types.dart';

class Route {
  final String path;
  final ComponentBuilder builder;

  const Route({required this.path, required this.builder});
}
