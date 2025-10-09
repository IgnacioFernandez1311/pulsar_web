<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

<h1>Pulsar web Framework</h1>

> **Pulsar** is a lightweight Dart web framework for building web SPAs combining the simplicity of HTML + CSS with Dart using **Jinja** templates and reactive components


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
  - **props()** -> Available variables in the HTML template
  - **template()** -> Component's HTML content (inline using multiline Strings or extern using **loadFile()** function)
  - **style()** -> Component's CSS content (inline using multiline Strings or extern using **loadFile()** function)
  - **methodRegistry** -> Available methods in the HTML template

example:
**hello.dart**
```dart counter.dart

import 'package:pulsar_web/pulsar.dart';

class Hello extends Component {
  String hello = "Hello Pulsar!";

  @override
  Map<String, dynamic> props() => {'hello': hello};

  @override
  Map<String, Function> get methodRegistry => {
    "helloMethod": helloNethod,
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
**hello.html**
```html counter.html
<span>{{hello}}</span>
<button @click="helloMethod">Press Me</button>
```
**main.dart**
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
