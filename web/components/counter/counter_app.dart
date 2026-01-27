import 'package:pulsar_web/pulsar.dart';
import 'package:universal_web/web.dart';
import '../title/title.dart';

class CounterApp extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/counter_app.css")];

  int count = 0;

  void increment(Event event) => setState(() => count++);

  void decrement(Event event) => setState(() => count--);

  @override
  PulsarNode render() {
    return div(
      children: <PulsarNode>[
        ComponentNode(
          component: TitleComponent(title: "Welcome to Pulsar Web"),
        ),
        el("h2", children: [text("$count")]),
        div(
          classes: "buttons",
          children: <PulsarNode>[
            button(
              classes: "btn-floating btn-large waves-effect blue darken-2",
              attrs: <String, Attribute>{'onClick': EventAttribute(decrement)},
              children: <PulsarNode>[
                el('i', classes: "material-icons", children: [text('remove')]),
              ],
            ),
            button(
              classes: "btn-floating btn-large waves-effect blue darken-2",
              attrs: <String, Attribute>{'onClick': EventAttribute(increment)},
              children: <PulsarNode>[
                el('i', classes: "material-icons", children: [text("add")]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
