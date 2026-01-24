import 'package:pulsar_web/engine/stylesheet/stylesheet.dart';
import 'package:universal_web/web.dart';

final class CssFile extends Stylesheet {
  final String href;

  const CssFile(this.href);

  @override
  void apply() {
    final HTMLLinkElement link =
        document.createElement('link') as HTMLLinkElement;
    link.rel = 'stylesheet';
    link.href = href;
    document.head!.append(link);
  }
}

Stylesheet css(String path) => CssFile(path);
