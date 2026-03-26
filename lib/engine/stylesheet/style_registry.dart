import 'package:pulsar_web/pulsar.dart';

final class StyleRegistry {
  final _registered = <String>{};

  void use(Stylesheet sheet) {
    _registered.add(sheet.path);
  }

  Set<String> get registered => _registered;
}
