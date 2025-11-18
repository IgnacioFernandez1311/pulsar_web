import 'package:pulsar_web/pulsar.dart';

class CounterApp extends Component {
  CounterApp() {
    state.count = 0;
    prop.title = "Counter App";
    trigger.increment = (PulsarEvent event) => state.count++;
    trigger.decrement = (PulsarEvent event) => state.count--;
    trigger.updateTitle = (PulsarEvent event) =>
        state.subtitle = "This is the subtitle from the state";
  }

  @override
  Future<String> get template async =>
      await loadFile('components/counter/counter_app.html');
  @override
  Future<String?> get style async =>
      await loadFile('components/counter/counter_app.css');
}
