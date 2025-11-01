import 'package:pulsar_web/pulsar.dart';
import 'package:universal_web/web.dart';

/// Extends from Event. It is the Event type of the @events in the templates. example: @click, @submit, @mouseover
typedef PulsarEvent = Event;

/// The base class to create a component. Every component extends from this class and defines `props`, `tagName`, `template`, `style` and `methodRegistry`.
/// A Component structure must be like the following syntax:
/// ```dart
/// class ComponentName extends Component {
///   String var = "example prop";
///   @override
///   Future<String> get template async => await "<p>{{var}} works</p>";
///   @override
///   Map<String, dynamic> get props => {"var": var};
/// }
/// ```
/// Also can be used with the `loadFile()` method to use an extern template.
/// ```dart
/// class ComponentName extends Component {
///  @override
///  Future<String> get template async => await loadFile('path/to/component_name.html');
/// }
/// ```
abstract class Component extends Renderable {
  @override
  List<Component> get imports => [];
  /*
  String _interpolate(String template) {
    final values = props;
    return template.replaceAllMapped(RegExp(r'{{\s*(\w+)\s*}}'), (match) {
      final String key = match.group(1)!;
      final value = values[key];
      if (value is HTMLElement) {
        return '<div data-slot="$key"></div>';
      }
      return value?.toString() ?? '';
    });
  }
*/
}




