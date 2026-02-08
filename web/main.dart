import 'package:pulsar_web/utils/mount_app.dart';
import './components/counter/counter_app.dart';

void main() {
  mountApp(CounterApp(), selector: "#app");
}
