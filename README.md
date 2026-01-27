<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

[![pub package](https://img.shields.io/pub/v/pulsar_web.svg)](https://pub.dev/packages/pulsar_web)
[![pub points](https://img.shields.io/pub/points/pulsar_web)](https://pub.dev/packages/pulsar_web/score)
[![likes](https://img.shields.io/pub/likes/pulsar_web)](https://pub.dev/packages/pulsar_web/score)


<h1>Pulsar Web Framework</h1>

> **Pulsar** is a simple Dart web framework for building apps combining the simplicity of the web with the power of Dart.


## Installation

> **Note**: Pulsar Web Framework is still under development but `0.4` is a stable version so you can use it to work in real projects. Please consider to give feedback for every bug you find or open a new issue at the [Github Repository](https://github.com/IgnacioFernandez1311/pulsar_web).

Use the `pulsar_cli` to create and serve projects. Run the following command to activate it.
```bash
  dart pub global activate pulsar_cli
```
Then use the `create` command for make a new project.
```bash
  pulsar create hello
```

## Project structure

A Pulsar project must have the structure of the example below:

```
  web/
    ├─ index.html
    ├─ main.dart
    └─ components/
        └─ hello/
             ├─ hello.dart
             ├─ hello.html
             └─ hello.css
```

## How to use Pulsar

### Component Creation


Example:
`counter.dart`
```dart counter.dart

import 'package:pulsar_web/pulsar.dart';

class Counter extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/counter.css")];

  int count = 0;

  void increment(Event event) => setState(() => count++);

  void decrement(Event event) => setState(() => count--);

  @override
  PulsarNode render() {
    return div(
      children: <PulsarNode>[
        ComponentNode(
          component: TitleComponent(title: "Welcome to Pulsar Web"),
        ), // This is another component defined just like Counter
        h2(children: <PulsarNode>[text("$count")]),
        div(
          classes: "buttons",
          children: <PulsarNode>[
            button(
              attrs: <String, Attribute>{'onClick': EventAttribute(decrement)},
              children: <PulsarNode>[
                text('-'),
              ],
            ),
            button(
              attrs: <String, Attribute>{'onClick': EventAttribute(increment)},
              children: <PulsarNode>[
                text("+"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
```

> Note: If you are using `css()` keep in mind that the root directory for this function is `web/`. So every css file must be inside the `web/` directory. Example: `css("components/counter/counter.css")`.

### Layout Creation

`app_layout.dart`
```dart app_layout.dart
import 'package:pulsar_web/pulsar.dart';
import '../../components/counter/counter.dart';

class AppLayout extends Component {
  final Component child;

  AppLayout(this.child);

  @override
  PulsarNode render() {
    return div(
      children: <PulsarNode>[
        h1("This is a persistant title"),
        ComponentNode(component: child),
    ]);
  }
 
}
```
This is how the main file might look like with `Routing`. The `Layout` has to define a child you may pass as a parameter `page`

`main.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import 'layout/app_layout/app_layout.dart';
void main() {
  mountApp(
    RouterComponent(
      router: Router(
        routes: [
          Route(path: '/', builder: () => HomePage()),
          Route(path: '/counter', builder: () => Counter()),
        ],
        notFound: () => NotFoundPage(),
      ),
      layout: (page) => AppLayout(page),
    ),
  );
}

```

> Note: To navigate through routes use the `navigateTo(String path)` function this way `navigateTo("/counter")`.

And this is how the main file looks with a single component.

`main.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import 'components/counter/counter.dart';
void main() {
  mountApp(Counter(), selector: "#app");
}

```

Then execute:

```bash
  pulsar serve
```

