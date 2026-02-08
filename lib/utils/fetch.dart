import 'dart:js_interop';
import 'package:universal_web/web.dart';

@JS('fetch')
external JSPromise<Response> _fetch(String input, [RequestInit? init]);

Future<Response> fetch(
  String url, {
  String method = 'GET',
  Map<String, String>? headers,
  String? body,
}) {
  // Camino estable: fetch(url)
  if (headers == null && body == null && method == 'GET') {
    return _fetch(url).toDart;
  }

  // Camino con RequestInit COMPLETO
  final init = RequestInit(
    method: method,
    headers: headers!.jsify() as HeadersInit,
    body: body?.toJS,
  );

  return _fetch(url, init).toDart;
}
