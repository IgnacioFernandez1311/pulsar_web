import 'package:pulsar_web/pulsar.dart';

final class CssFile extends Stylesheet {
  @override
  final String path;

  const CssFile(this.path);

  void apply() {
    final existing = document.querySelector('link[path="/$path"]');

    if (existing != null) return;

    final link = document.createElement('link') as HTMLLinkElement;
    link.rel = 'stylesheet';
    link.href = "/$path";
    document.head!.append(link);
  }
}

Stylesheet css(String path) => CssFile(path);
