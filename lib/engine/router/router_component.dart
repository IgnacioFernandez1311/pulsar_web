import 'package:pulsar_web/pulsar.dart';
import 'package:universal_web/web.dart';

class RouterComponent extends Component {
  static RouterComponent? _instance;
  final Router router;
  final Component Function(Component page) layout;

  RouterComponent({required this.router, required this.layout});

  @override
  void onMount() {
    _instance = this;
    window.onPopState.listen((_) {
      update();
    });
  }

  static void notifyNavigation() {
    _instance?.update();
  }

  @override
  PulsarNode render() {
    final path = window.location.pathname;
    final component = router.resolve(path);
    final wrapped = layout(component);
    return ComponentNode(component: wrapped, key: path);
  }
}

String currentPath() {
  return window.location.pathname;
}
