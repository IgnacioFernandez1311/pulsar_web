<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

<h1>Pulsar web Framework</h1>

> **Pulsar** is a lightweight Dart web framework for building web **SPAs** combining the simplicity of HTML + CSS with Dart using **Jinja** templates and reactive components


## Installation

First of all create a new web project with Dart using:
```bash
  dart create -t web app_name
```

Add **pulsar_web** as a dependency in your **pubspec.yaml** manually or use the next command:
```bash
  dart pub add pulsar_web
```
Then execute:
```bash
  dart pub get
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

## Component creation

Every component extends from **Component** class and defines:
  - `tagName` -> Name of the wrapper tag for the component (div by default)
  - `props()` -> Available variables in the HTML template
  - `template()` -> Component's HTML content (inline using multiline Strings or extern using `loadFile()` function)
  - `style()` -> Component's CSS content (inline using multiline Strings or extern using `loadFile()` function)
  - `methodRegistry` -> Available methods in the HTML template

Example:
`hello.dart`
```dart counter.dart

import 'package:pulsar_web/pulsar.dart';

class Hello extends Component {
  String hello = "Hello Pulsar!";

  @override
  Map<String, dynamic> props() => {'hello': hello};

  @override
  Map<String, Function> get methodRegistry => {
    "helloMethod": helloMethod,
  };

  @override
  Future<String> template() async =>
      await loadFile('path/to/hello.html');
  @override
  Future<String?> style() async =>
      await loadFile('path/to/hello.css');

  void helloMethod(PulsarEvent event) => setState(() => hello = "Goodbye Pulsar!");
}
```

> Note: If you are using `loadFile()` keep in mind that the root directory for this function is `web/`. So every template must be inside the `web/` directory. Example: `loadFile("components/hello/hello.html")`.

`hello.html`
```html counter.html
<span>{{hello}}</span>
<button @click="helloMethod">Press Me</button>
```
`main.dart`
```dart main.dart
  import 'package:pulsar_web/pulsar.dart';
  import 'components/hello/hello.dart';

  void main() {
    runApp([Hello()]);
  }
```

Then execute:

```bash
  webdev serve
```

## Register and insert components using Provider

If you want to insert a component into HTML you have to use a `Provider`, the `ComponentRegistry` and the `{% insert %}` tag.


Structure:

```

  web/
    ├─ index.html
    ├─ main.dart
    └─ components/
        ├─ app_root/
        │   ├─ app_root.dart
        │   ├─ app_root.html
        │   └─ app_root.css
        ├─ hello/
        │   ├─ hello.dart
        │   ├─ hello.html
        │   └─ hello.css
        └─ component_provider.dart
```


Example:
`component_provider.dart`
```dart component_provider.dart
import 'package:pulsar_web/pulsar.dart';
import '';
class ComponentProvider extends Provider {
  @override
  void registerComponents() {
    register("Hello", () => Hello());
  }
}
```
> Note: This structure is optional. Every component can have its own provider if you want.

Define a root component to insert the child.

`app_root.dart`
```dart app_root.dart
import 'package:pulsar_web/pulsar.dart';

class AppRoot extends Component {
  @override
  Future<String> template() async =>
      await loadFile('components/app_root/app_root.html');

  @override
  Future<String> style() async => await loadFile('components/app_root/app_root.css');

  @override
  Map<String, dynamic> props() => {};
}
```
Then use the `{% insert "Hello" %}` syntax to import the component in the `app_root.html` and we can insert it the times we want.

`app_root.html`
```html app_root.html
  <h1>Welcome to App Root</h1>
  <hr/>
  {% insert "Hello" %}

```

Finally import the provider and pass it to the `runApp()` function.

`main.dart`
```dart main.dart
  import 'package:pulsar_web/pulsar.dart';
  import 'components/component_provider.dart';
  import 'components/app_root/app_root.dart';

  void main() {
    runApp([AppRoot()], componentProvider: ComponentProvider());
  }
```
