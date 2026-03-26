import 'package:pulsar_web/pulsar.dart';
// ignore: avoid_relative_lib_imports
import '../lib/app.dart';

void main() {
  mountApp(App(), selector: "#app");
}
