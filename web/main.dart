import 'package:pulsar_web/pulsar.dart';
import 'components/counter/counter_app.dart';

void main() {
  mountApp(CounterApp(), selector: "#app");
}
