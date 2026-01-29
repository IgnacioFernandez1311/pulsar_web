import 'package:universal_web/web.dart';

sealed class Attribute {
  const Attribute();
}

final class StringAttribute extends Attribute {
  final String value;
  const StringAttribute(this.value);
}

typedef EventCallback = void Function(Event event);

final class EventAttribute extends Attribute {
  final EventCallback callback;
  const EventAttribute(this.callback);
}

final class ClassAttribute extends Attribute {
  final String classes;

  const ClassAttribute(this.classes);
}

final class StyleAttribute extends Attribute {
  final Map<String, String> styles;

  const StyleAttribute(this.styles);
}

final class BooleanAttribute extends Attribute {
  final bool value;
  const BooleanAttribute(this.value);
}
