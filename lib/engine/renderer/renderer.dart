import 'package:pulsar_web/pulsar.dart';

abstract class Renderer {
  void mount(PulsarNode root);
  void update(PulsarNode prev, PulsarNode next);
}
