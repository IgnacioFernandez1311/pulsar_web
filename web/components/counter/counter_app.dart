import 'package:pulsar_web/pulsar.dart';

class CounterApp extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/counter_app.css")];

  int count = 0;

  void increment(_) {
    count++;
    update();
  }

  void decrement(_) {
    count--;
    update();
  }

  @override
  PulsarNode render() {
    return div(
      children: <PulsarNode>[
        text("Count $count"),
        div(
          classes: "buttons",
          children: <PulsarNode>[
            button(
              classes: "button-circular",
              attrs: <String, Attribute>{'onClick': EventAttribute(decrement)},
              children: <PulsarNode>[text("-")],
            ),
            button(
              classes: "button-circular",
              attrs: <String, Attribute>{'onClick': EventAttribute(increment)},
              children: <PulsarNode>[text("+")],
            ),
          ],
        ),
      ],
    );
  }
}
