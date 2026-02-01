<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

[![pub package](https://img.shields.io/pub/v/pulsar_web.svg)](https://pub.dev/packages/pulsar_web)
[![pub points](https://img.shields.io/pub/points/pulsar_web)](https://pub.dev/packages/pulsar_web/score)
[![likes](https://img.shields.io/pub/likes/pulsar_web)](https://pub.dev/packages/pulsar_web/score)


<h1>Pulsar Web Framework</h1>

**Pulsar** is a simple Dart web framework for building apps combining the simplicity of the web with the power of Dart.
See [Pulsar Web Framework](https://pulsar-web.netlify.app) and enjoy creating with Pulsar.


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

See [pulsar_cli](https://pub.dev/packages/pulsar_cli) for more information on how to configurate the project creation.

## Project structure

A Pulsar project must have the structure of the example below:

> Note: Now every component and layout lives inside `lib/` directory. Pulsar avoids intentionally using `web/` for the components and layouts but not for CSS styling files. Pulsar dont want to use this directory to avoid relative import routes. So instead of using the syntax `import '../../some_component.dart';` use the following `import 'package:app_name/some_component.dart'`.

```
  lib/
    ├─ app.dart
    └─ components/
        └─ hello.dart
  web/
    ├─ index.html
    ├─ main.dart
    └─ styles/
        └─ hello.css
```

The `app.dart` is the entry point that comunicates `lib/` directory with `web/` directory.


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
              onClick: decrement,
              children: <PulsarNode>[
                text('-'),
              ],
            ),
            button(
              onClick: increment,
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

### List of available DOM events

You can use any of these events in most of HTML elements.

`HTML DOM events`
```dart
  EventCallback? onClick,
  EventCallback? onDoubleClick,
  EventCallback? onMouseEnter,
  EventCallback? onMouseLeave,
  EventCallback? onMouseMove,
  EventCallback? onMouseDown,
  EventCallback? onMouseUp,
  EventCallback? onFocus,
  EventCallback? onBlur,
  EventCallback? onKeyDown,
  EventCallback? onKeyUp,
  EventCallback? onInput,
  EventCallback? onChange,
```


### Layout Creation

You can use the `app.dart` to make it the main layout of the application by passing it a `child`. 

`app_layout.dart`
```dart app_layout.dart
import 'package:pulsar_web/pulsar.dart';

class App extends Component {
  final Component child;

  App(this.child);

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
This is how the main file might look like with `Routing`. The `Layout` has to define a child you may pass as the `page` parameter in the constructor.

`main.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import 'package:app_name/app.dart';
import 'package:app_name/home_page.dart';
import 'package:app_name/counter.dart';

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
      layout: (page) => App(page),
    ),
  );
}

```

> Note: To navigate through routes use the `navigateTo(String path)` function this way `navigateTo("/counter")`.

And this is how the main file looks with a single component.

`main.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import 'package:app_name/app.dart';
void main() {
  mountApp(App(), selector: "#app");
}

```

Then execute:

```bash
  pulsar serve
```

