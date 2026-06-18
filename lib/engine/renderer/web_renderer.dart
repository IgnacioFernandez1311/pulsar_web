import 'package:pulsar_web/pulsar.dart';

final class WebRenderer implements Renderer {
  final Element mountPoint;

  WebRenderer(this.mountPoint);

  @override
  void mount(Morphic root) {
    mountPoint.textContent = "";
    mountPoint.append(createDom(root));
  }

  @override
  void update(Morphic prev, Morphic next) {
    patch(mountPoint.firstChild!, prev, next);
  }

  @override
  void unmount() {
    mountPoint.textContent = "";
  }
}
