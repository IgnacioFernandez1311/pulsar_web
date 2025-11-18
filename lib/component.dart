import 'package:pulsar_web/prop_namespace.dart';
import 'package:pulsar_web/pulsar.dart';
import 'package:pulsar_web/state_namespace.dart';
import 'package:pulsar_web/trigger_namespace.dart';
import 'package:universal_web/web.dart';

typedef PulsarEvent = Event;

abstract class Component extends Renderable {
  Component() {
    onInit();
  }
  @override
  List<Component> get imports => <Component>[];

  bool _isUpdating = false;
  bool _shouldUpdate = false;

  final Set<String> _incomingPropKeys = <String>{};

  final Map<String, dynamic> processedProps = <String, dynamic>{};
  final Map<String, dynamic> propsRegistry = <String, dynamic>{};

  final Map<String, dynamic> states = <String, dynamic>{};

  late final dynamic prop = PropNamespace(this);
  late final dynamic state = StateNamespace(this);
  late final dynamic trigger = TriggerNamespace(this);

  final Map<String, Function> _methodRegistry = <String, Function>{};

  @override
  Map<String, Function> get methodRegistry => _methodRegistry;

  @override
  void receiveProps(Map<String, dynamic> newProps) {
    if (newProps.isEmpty) return;

    // Registrar keys que vienen desde fuera
    _incomingPropKeys.addAll(newProps.keys);

    final processed = _processIncomingProps(newProps);
    // ignore: unnecessary_this
    this.processedProps.addAll(processed);
    super.receiveProps(processed);

    if (processedProps.isNotEmpty && !_isUpdating) {
      _queueUpdate();
    }
  }

  @override
  void setState(void Function() updater) {
    if (_isUpdating) return;

    updater();
    _queueUpdate();
  }

  void _queueUpdate() {
    if (_isUpdating) {
      _shouldUpdate = true;
      return;
    }

    _isUpdating = true;
    _shouldUpdate = false;

    Future(() {
      try {
        render();
      } finally {
        _isUpdating = false;
        if (_shouldUpdate) {
          _queueUpdate();
        }
      }
    });
  }

  Map<String, dynamic> _processIncomingProps(Map<String, dynamic> newProps) {
    final processedProps = <String, dynamic>{};

    newProps.forEach((key, value) {
      if (!_incomingPropKeys.contains(key)) {
        processedProps[key] = value;
        return;
      }

      if (value is String && value.startsWith('{{') && value.endsWith('}}')) {
        final expression = value.substring(2, value.length - 2).trim();

        processedProps[key] =
            propsData[expression] ?? processedProps[expression];
      } else {
        processedProps[key] = value;
      }
    });

    return processedProps;
  }

  /// Actualiza el estado de `key` a `value` y dispara render de forma segura.
  void updateState<T>(String key, T value) {
    setState(() {
      states[key] = value;
    });
  }

  @override
  Map<String, dynamic> get props {
    final result = <String, dynamic>{};
    // Combinar props registradas con props procesadas
    result.addAll(propsRegistry);
    result.addAll(processedProps);
    return result;
  }
}
