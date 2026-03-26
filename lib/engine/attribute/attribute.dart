import 'package:pulsar_web/pulsar.dart';

typedef EventCallback = void Function(Event event);

// lib/core/attributes.dart

sealed class Attribute {
  const Attribute();
}

class StringAttribute extends Attribute {
  final String value;
  const StringAttribute(this.value);
}

class BooleanAttribute extends Attribute {
  final bool value;
  const BooleanAttribute(this.value);
}

class ClassAttribute extends Attribute {
  final String classes;
  const ClassAttribute(this.classes);
}

class StyleAttribute extends Attribute {
  final Map<String, String> styles;
  const StyleAttribute(this.styles);
}

// 🔑 ACTUALIZADO: Event attribute con owner
class EventAttribute extends Attribute {
  final EventCallback callback;
  final Component? owner; // 🔑 NUEVO

  const EventAttribute(this.callback, {this.owner});

  // Helper para crear con owner desde context
  factory EventAttribute.fromContext(EventCallback callback) {
    return EventAttribute(callback, owner: RenderContext.currentComponent);
  }
}
