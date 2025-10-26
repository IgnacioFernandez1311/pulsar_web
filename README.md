<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

<h1>Pulsar Web Framework</h1>

> **Pulsar** is a lightweight Dart web framework for building web **SPAs** combining the simplicity of HTML + CSS with Dart using **Jinja** templates and reactive components.


## Installation

> **Disclaimer**: Pulsar Web Framework is still under development so the versions `0.x.y` can be strongly modified as this package gets new features and fixes. This version of Pulsar is only recommended for personal, private or test use. Please consider to give feedback for every bug you find or open a new issue at the [Github Repository](https://github.com/IgnacioFernandez1311/pulsar_web).

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
    ├─ components/
    │   └─ hello/
    │        ├─ hello.dart
    │        ├─ hello.html
    │        └─ hello.css
    └─ views/
        └─ app_view/
            ├─ app_view.dart
            ├─ app_view.html
            └─ app_view.css

```

## How to use Pulsar

### Component Creation

Every `Component` extends from `Renderable` class and defines:
  - `props` -> Available variables in the HTML template.
  - `imports` -> A list of components available to insert into the html template.
  - `template` -> HTML content (inline using multiline Strings or extern using `loadFile()` function).
  - `style` -> CSS content (inline using multiline Strings or extern using `loadFile()` function).
  - `methodRegistry` -> Available methods in the HTML template.

Example:
`hello.dart`
```dart counter.dart

import 'package:pulsar_web/pulsar.dart';

class Hello extends Component {
  String hello = "Hello Pulsar!";

  @override
  Map<String, dynamic> get props => {'hello': hello};

  @override
  Map<String, Function> get methodRegistry => {
    "helloMethod": helloMethod,
  };

  @override
  Future<String> get template async =>
      await loadFile('path/to/hello.html');
  @override
  Future<String?> get style async =>
      await loadFile('path/to/hello.css');

  void helloMethod(PulsarEvent event) => setState(() => hello = "Goodbye Pulsar!");
}
```

> Note: If you are using `loadFile()` keep in mind that the root directory for this function is `web/`. So every template must be inside the `web/` directory. Example: `loadFile("components/hello/hello.html")` or `loadFile("views/app_view/app_view.html")`.

`hello.html`
```html hello.html
<span>{{hello}}</span>
<button @click="helloMethod">Press Me</button>
```

### View Creation

The `ContentView` class is a `Renderable` used to render the page content. It contains components or another views and defines:
  - `props` -> Available variables in the HTML template.
  - `imports` -> A list of renderables available to insert into the html template.
  - `template` -> HTML content (inline using multiline Strings or extern using `loadFile()` function).
  - `style` -> CSS content (inline using multiline Strings or extern using `loadFile()` function).
  - `methodRegistry` -> Available methods in the HTML template.

`app_view.dart`
```dart app_view.dart
import 'package:pulsar_web/pulsar.dart';
import '../../components/hello/hello.dart';

class AppView extends ContentView {
  @override
  List<Renderable Function()> get imports => [
    () => Hello()
  ];

  @override
  Future<String> get template async =>
      await loadFile('views/app_root/app_root.html');
}
```
`main.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import 'views/app_view/app_view.dart';

void main() {
  runApp(AppView());
}
```

Then execute:

```bash
  pulsar serve
```
### Insert components

As you can see, every Component and View defines an `imports` list that defines the list of `Renderable Function()` items you can insert into the `View` html template using the syntax `{% insert "Hello" %}`.

### LayoutView

A `LayoutView` is a view that can contain `ContentView` elements to use routing with Layout persistance like a Navbar or a Footer. Every `LayoutView`extends from `Renderable`and defines:
  - `router` -> Property to register and handle routes on LayoutView.
  - `content` -> The `Renderable` content that renders as a child contained by `LayoutView`.
  - `navigateTo()` -> Function to navigate between the routes defined in the `ListView`. It receives a `String route` parameter.
  - `defineRoutes()` -> Function to define and register all the routes for the `LayoutView`.

You must create a new view that extends from LayoutView:
`persistant_view.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import '../app_view/app_view.dart';
import '../about_view/about_view.dart';

class PersistantView extends LayoutView {
  @override
  Future<String> get template async => await loadFile("views/persistant_view/persistant_view.html");

  @override
  Map<String, Function> get methodRegistry => {
        'goHome': (_) => router.navigateTo('/'),
        'goAbout': (_) => router.navigateTo('/about')
      };

  @override
  void defineRoutes() {
    router.define('/', () => AppView());
    router.define('/about', () => AboutView());
  }
}
```
`persistant_view.html`
```html
<div class="layout">
  <header>
    <nav>
      <a @click="goHome">Home</a>
      <a @click="goAbout">About</a>
     </nav>
   </header>

  {% content %}

  <footer>
     <small>Pulsar © 2025</small>
  </footer>
</div>
```

This will make the `AppView()` the default (**/** route) view to render for the `LayoutView` and the `AboutView()` will be at the **/about** route.

If you want to add props to the LayoutView, you can use the following way.

```dart
@override
  Map<String, dynamic> get props => {
    ...super.props,
    'newProp': newPropValueOrVar
  };
```

> Note: LayoutView is recommended to use only methodRegistry, not props so this is completely optional.
