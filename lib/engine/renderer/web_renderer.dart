import 'package:pulsar_web/pulsar.dart';

final class WebRenderer implements Renderer {
  final Element mountPoint;

  WebRenderer(this.mountPoint);

  @override
  void mount(PulsarNode root) {
    mountPoint.textContent = "";
    mountPoint.append(createDom(root));
  }

  @override
  void update(PulsarNode prev, PulsarNode next) {
    patch(mountPoint.firstChild!, prev, next);
  }
}
