import 'package:pulsar_web/pulsar.dart';
import 'components/component_provider.dart';
import './components/app_root/app_root.dart';

void main() {
  runApp([AppRoot()], componentProvider: ComponentProvider());
}
