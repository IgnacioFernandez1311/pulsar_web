import 'package:pulsar_web/pulsar.dart';

class CounterApp extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/counter_app.css")];

  int count = 0;

  void increment(Event event) => setState(() => count++);

  void decrement(Event event) => setState(() => count--);

  @override
  void onMount() {
    print("Hello from onMount function");
  }

  @override
  void onUpdate() {
    print("Hello from onUpdate function");
  }

  @override
  PulsarNode render() {
    return div(
      children: <PulsarNode>[
        h1(children: [text("Welcome to Pulsar Web")]),
        img(src: "assets/Logo.png", width: 180),
        hr(),
        h2(children: [text("$count")]),
        div(
          classes: "buttons",
          children: <PulsarNode>[
            button(
              classes: "button-circular",
              onClick: decrement,
              children: <PulsarNode>[text('-')],
            ),
            button(
              classes: "button-circular",
              onClick: increment,
              children: <PulsarNode>[text("+")],
            ),
          ],
        ),
      ],
    );
  }
}
