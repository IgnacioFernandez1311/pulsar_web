import 'package:pulsar_web/pulsar.dart';

class App extends Component {
  @override
  PulsarNode render() {
    return h1(children: [text("Welcome to Pulsar!")]);
  }
}
