import 'package:pulsar_web/engine/stylesheet/css_file.dart';
import 'package:pulsar_web/engine/stylesheet/stylesheet.dart';

final class StyleRegistry {
  final _loaded = <String>{};

  void use(Stylesheet sheet) {
    if (sheet is CssFile && _loaded.contains(sheet.href)) {}

    sheet.apply();

    if (sheet is CssFile) {
      _loaded.add(sheet.href);
    }
  }
}
