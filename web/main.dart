import 'package:pulsar_web/pulsar.dart';
import './components/counter/counter_app.dart';

void main() {
  final app = TodoApp();
  mountApp(app, selector: "#app");
}
