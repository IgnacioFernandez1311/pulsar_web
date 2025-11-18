import 'package:pulsar_web/component.dart';

abstract class DynamicNamespace {
  final Component owner;
  DynamicNamespace(this.owner);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = _member(invocation.memberName);

    if (invocation.isGetter) {
      return handleGet(name);
    }

    if (invocation.isSetter) {
      final value = invocation.positionalArguments.first;
      return handleSet(name, value);
    }

    throw UnsupportedError("Invalid operation: $invocation");
  }

  dynamic handleGet(String key);
  dynamic handleSet(String key, dynamic value);

  String _member(Symbol s) {
    final raw = s.toString(); // Symbol("count=")
    return raw.substring(8, raw.length - 2).replaceAll("=", "");
  }
}
