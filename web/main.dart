import 'package:pulsar_web/pulsar.dart';
import 'components/todo/todo_app.dart';

void main() {
  final app = TodoApp();
  mountApp(app, selector: "#app");
}
