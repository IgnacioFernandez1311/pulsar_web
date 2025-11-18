import 'package:universal_web/web.dart';
import 'dart:js_interop';

/// Function to load templates and styles from a url. The base directory is always considered the `web/` directory so you must use the following path styles:
/// `components/component_name/component_name.html or component_name.css`
/// `layouts/layout_name/layout_name.html or layout_name.css`
///Note that every template must be at least inside of the `web/` directory to work correctly and avoid to use paths like `web/components/component_name/component_name.html`.
Future<String> loadFile(String path) async {
  final Response response = await window.fetch(path.toJS).toDart;
  final JSString text = await response.text().toDart;
  return text.toDart;
}