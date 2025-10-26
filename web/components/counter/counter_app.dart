import 'package:pulsar_web/pulsar.dart';

class CounterApp extends Component {
  int count = 0;

  @override
  Map<String, dynamic> get props => {'count': count};

  @override
  Map<String, Function> get methodRegistry => {
    "increment": increment,
    "decrement": decrement,
  };

  @override
  Future<String> get template async =>
      await loadFile('components/counter/counter_app.html');
  @override
  Future<String?> get style async =>
      await loadFile('components/counter/counter_app.css');

  void increment(PulsarEvent event) => setState(() => count++);
  void decrement(PulsarEvent event) => setState(() => count--);
}
