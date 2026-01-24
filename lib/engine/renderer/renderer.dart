import 'package:pulsar_web/engine/node/node.dart';

abstract class Renderer {
  void mount(PulsarNode root);
  void update(PulsarNode prev, PulsarNode next);
}
