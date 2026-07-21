import 'package:pulsar_web/pulsar.dart';

typedef EventCallback = void Function(Event event);

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

/// Injects raw HTML into an element via [HTMLElement.setHTMLUnsafe].
///
/// Used by [ElementBuilder.innerHTML] to render pre-parsed HTML content —
/// for example, Markdown converted to HTML by [pulsar_content].
///
/// ## Safety
///
/// [setHTMLUnsafe] bypasses Pulsar's normal child normalization. Only use
/// this with trusted HTML sources — content parsed from Markdown files,
/// never with raw user input.
///
/// When [InnerHtmlAttribute] is present on an element, its children list
/// is ignored. The raw HTML becomes the entire content of the element.
class InnerHtmlAttribute extends Attribute {
  final String html;
  const InnerHtmlAttribute(this.html);
}

/// Event attribute with owner for granular update context.
class EventAttribute extends Attribute {
  final EventCallback callback;
  final Component? owner;

  const EventAttribute(this.callback, {this.owner});

  factory EventAttribute.fromContext(EventCallback callback) {
    return EventAttribute(callback, owner: RenderContext.currentComponent);
  }
}
