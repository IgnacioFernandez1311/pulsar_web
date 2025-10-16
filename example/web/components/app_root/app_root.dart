import 'package:pulsar_web/pulsar.dart';

class AppRoot extends Component {
  @override
  Future<String> template() async =>
      await loadFile('components/app_root/app_root.html');

  @override
  Map<String, dynamic> props() => {};
}
