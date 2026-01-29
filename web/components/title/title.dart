import 'package:pulsar_web/pulsar.dart';

class TitleComponent extends Component {
  final String title;
  TitleComponent({required this.title});

  @override
  PulsarNode render() {
    return h1(children: [text(title)]);
  }
}
