# Pulsar Example

This is a minimal Pulsar Web application generated with `pulsar create`.

## Requirements

- Dart SDK ^3.9.0
- Pulsar CLI installed

## Getting Started

Install dependencies:

```bash
dart pub get
```

Run the development server:

```bash
pulsar serve
```

By default, the app will be available at:

```bash
http://localhost:8080
```

## Production Build

To generate a production build:

```bash
pulsar build
```

The output will be generated in the `build/` directory.

## Project Structure

```bash
lib/
  app.dart        # Root component

web/
  main.dart       # Application entrypoint
  index.html      # HTML shell
  styles.css      # Global styles
```

## How it Works

`main.dart` mounts the root component into the DOM:

```dart
mountApp(App(), selector: "#app");
```

`App` extends `Component` and returns a `PulsarNode`:

```dart
class App extends Component {
  @override
  PulsarNode render() {
    return h1(children: [text("Welcome to Pulsar!")]);
  }
}
```