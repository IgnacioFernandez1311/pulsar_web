import 'package:pulsar_web/pulsar.dart';

abstract class Renderer {
  void mount(Morphic root);
  void update(Morphic prev, Morphic next);
  void unmount();
}
