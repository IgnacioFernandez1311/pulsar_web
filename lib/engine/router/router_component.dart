import 'package:pulsar_web/pulsar.dart';

class RouterComponent extends Component {
  static RouterComponent? _instance;

  final Router router;
  final Component Function(Component page) layout;

  Component? _currentPage;

  RouterComponent({required this.router, required this.layout});

  @override
  void onMount() {
    _instance = this;
    window.onPopState.listen((_) => update());
  }

  static void notifyNavigation() {
    _instance?.update();
  }

  @override
  PulsarNode render() {
    final path = window.location.pathname;

    final resolved = router.resolve(path);

    // 👇 SOLO cambia si el tipo cambia
    if (_currentPage == null ||
        _currentPage.runtimeType != resolved.runtimeType) {
      _currentPage = resolved;
    }

    return ComponentNode(
      component: layout(_currentPage!),
      // 👇 SIN key
    );
  }
}

String currentPath() {
  return window.location.pathname;
}
