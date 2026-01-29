import 'package:pulsar_web/pulsar.dart';

final class StyleRegistry {
  final loaded = <String>{};

  void use(Stylesheet sheet) {
    if (sheet is CssFile && loaded.contains(sheet.href)) {
      return;
    }

    sheet.apply();

    if (sheet is CssFile) {
      loaded.add(sheet.href);
    }
  }
}
