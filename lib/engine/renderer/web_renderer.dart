import 'package:universal_web/web.dart';

import '../node/node.dart';
import './renderer.dart';

import 'dom_factory.dart';
import 'diff.dart';

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
