<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

[![pub package](https://img.shields.io/pub/v/pulsar_web.svg)](https://pub.dev/packages/pulsar_web)
[![pub points](https://img.shields.io/pub/points/pulsar_web)](https://pub.dev/packages/pulsar_web/score)
[![likes](https://img.shields.io/pub/likes/pulsar_web)](https://pub.dev/packages/pulsar_web/score)


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
  - `imports` -> A list of components available to insert into the html template.
  - `template` -> HTML content (inline using multiline Strings or extern using `loadFile()` function).
  - `style` -> CSS content (inline using multiline Strings or extern using `loadFile()` function).
  - `prop` -> A namespace for prop creation using the syntax `prop.propname`. All prop names must be lowercase
  - `state` -> A namespace for state creation using the syntax `state.propname`. All state names must be lowercase
  - `trigger` -> A namespace for event trigger creation using the syntax `trigger.propname`.


Example:
`hello.dart`
```dart counter.dart

import 'package:pulsar_web/pulsar.dart';

class Hello extends Component {
  Hello() {
    state.hello = "Hello Pulsar!";
    prop.title = "Default prop value";
    trigger.helloMethod = (PulsarEvent event) => state.hello = "Goodbye Pulsar!";
  }


  @override
  Future<String> get template async =>
      await loadFile('path/to/hello.html');
  @override
  Future<String?> get style async =>
      await loadFile('path/to/hello.css');
}
```

> Note: If you are using `loadFile()` keep in mind that the root directory for this function is `web/`. So every template must be inside the `web/` directory. Example: `loadFile("components/hello/hello.html")` or `loadFile("views/app_view/app_view.html")`.

`hello.html`
```html hello.html
<h1>{{title}}</h1>
<span>{{hello}}</span>
<button @click="helloMethod">Press Me</button>
```

### View Creation

The `ContentView` class is a `Renderable` used to render the page content. It contains components or another views and defines:
  - `imports` -> A list of renderables available to insert into the html template.
  - `template` -> HTML content (inline using multiline Strings or extern using `loadFile()` function).
  - `style` -> CSS content (inline using multiline Strings or extern using `loadFile()` function).

`app_view.dart`
```dart app_view.dart
import 'package:pulsar_web/pulsar.dart';
import '../../components/hello/hello.dart';

class AppView extends ContentView {
  @override
  List<Renderable> get imports => [Hello()];

  @override
  Future<String> get template async =>
      await loadFile('views/app_view/app_view.html');
}
```

You can insert the Component `Hello` into the view template using the following syntax.

`app_view.html`
```html
<Hello title="Hello App Title" />
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

As you can see, every Component and View defines an `imports` list that defines the list of `Renderable` items you can insert into the `View` or `Component` html template using the syntax `<Hello />`.

### LayoutView

A `LayoutView` is a view that can contain `ContentView` elements to use routing with Layout persistence like a Navbar or a Footer. Every `LayoutView` extends from `Renderable` and defines:
  - `router` -> Property to register and handle routes on LayoutView.
  - `content` -> The `Renderable` content that renders as a child contained by `LayoutView`.
  - `defineRoutes()` -> Function to define and register all the routes for the `LayoutView`.
  - `route()` -> Function for route definitions like `/` or `/about`.

You must create a new view that extends from LayoutView:

`persistent_view.dart`
```dart
import 'package:pulsar_web/pulsar.dart';
import '../app_view/app_view.dart';
import '../about_view/about_view.dart';

class PersistentView extends LayoutView {
  @override
  Future<String> get template async => await loadFile("views/persistent_view/persistent_view.html");


  @override
  void defineRoutes() {
    route('/', AppView());
    route('/about', AboutView());
  }
}
```
`persistent_view.html`
```html
  <header>
    <nav>
      <a @click="goToHome">Home</a>
      <a @click="goToAbout">About</a>
     </nav>
   </header>

  <@View />

  <footer>
     <small>Pulsar © 2025</small>
  </footer>
```

This will make the `AppView()` the default (**/** route) view to render for the `LayoutView` and the `AboutView()` will be at the **/about** route.
Note that the `route()` method always create the default name as `goToRouteName` like `goToHome` if the `route()` is defined like `route('/', AppView)`. The `/` route case is special since its the only route definition that will be registered as "goToHome" at the method registry used by the template.


