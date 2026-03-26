// lib/routing/router_component.dart

import 'package:pulsar_web/pulsar.dart';

final class RouterComponent extends Component {
  static RouterComponent? _instance;

  final Router router;
  final Component Function(Component page) layoutBuilder;

  Component? _currentPage;
  Component? _layoutComponent;

  RouterComponent({
    required this.router,
    required Component Function(Component page) layout,
  }) : layoutBuilder = layout;

  void onMount() {
    _instance = this;
    window.onPopState.listen((_) => update());
  }

  static void notifyNavigation() {
    _instance?.update();
  }

  @override
  Morphic render() {
    final path = window.location.pathname;
    final resolved = router.resolve(path);

    // Actualizar página actual
    if (_currentPage == null ||
        _currentPage.runtimeType != resolved.runtimeType) {
      _currentPage = resolved;

      // Recrear layout con nueva página
      _layoutComponent = layoutBuilder(_currentPage!);
    }

    // El layout es un component - se resolverá en resolveNode()
    return _layoutComponent!.render();
  }
}

String currentPath() {
  return window.location.pathname;
}
