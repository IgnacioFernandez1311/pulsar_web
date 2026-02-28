<p align="center">
  <img src="./billboard_img.png" alt="Pulsar" width="740">
</p>

<p align="center">
  <a href="https://github.com/sponsors/IgnacioFernandez1311">
    <img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=white" alt="Sponsor Pulsar">
  </a>
</p>

[![pub package](https://img.shields.io/pub/v/pulsar_web.svg)](https://pub.dev/packages/pulsar_web)
[![pub points](https://img.shields.io/pub/points/pulsar_web)](https://pub.dev/packages/pulsar_web/score)
[![likes](https://img.shields.io/pub/likes/pulsar_web)](https://pub.dev/packages/pulsar_web/score)

# Pulsar Web Framework

**Pulsar** is a simple Dart-first web framework focused on clarity, explicit behavior, and long-term maintainability.

It combines the simplicity of the web platform with the strengths of Dart, without hidden magic or unnecessary abstractions.

🌐 Website: https://pulsar-web.netlify.app

---

## Getting Started

### Installation

Pulsar projects are created and served using the official CLI.

Activate the CLI globally:

```bash
dart pub global activate pulsar_cli
```

Create a new project:

```bash
pulsar create hello
cd hello
```

Run the development server:
```bash
pulsar serve
```

> Note: The app will be available in your browser with live reload enabled if you use the `--watch` option.

### Project Structure

A typical Pulsar project looks like this:

```markdown
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

- `lib/` contains all Dart components and layouts
- `web/` contains the entry point, HTML, and CSS assets

Pulsar intentionally avoids placing components inside `web/` to prevent fragile relative imports and keep Dart code clean and package-based.

## Basic Usage
### Creating a Component

Components are plain Dart classes that extend `Component`.

```dart
import 'package:pulsar_web/pulsar.dart';

class Counter extends Component {
  int count = 0;

  void increment(Event event) => setState(() => count++);
  void decrement(Event event) => setState(() => count--);

  @override
  PulsarNode render() {
    return div(
      children: [
        h2(children: [text('$count')]),
        button(onClick: decrement, children: [text('-')]),
        button(onClick: increment, children: [text('+')]),
      ],
    );
  }
}
```

State is managed directly in Dart.
Calling `setState` triggers a re-render of the component.

### Styling Components

Components can define their own stylesheets:

```dart
@override
List<Stylesheet> get styles => [
  css('components/counter/counter.css'),
];
```
> Note: The `css()` path is always relative to the `web/` directory.

## Routing & Layouts

Pulsar includes a simple router with layout support.

### Defining a Layout

```dart
class App extends Component {
  final Component child;

  App(this.child);

  @override
  PulsarNode render() {
    return div(
      children: [
        h1(children: [text('Persistent Header')]),
        ComponentNode(component: child),
      ],
    );
  }
}
```

### Configuring Routes

```dart
void main() {
  mountApp(
    RouterComponent(
      router: Router(
        routes: [
          Route(path: '/', builder: (_) => HomePage()),
          Route(path: '/items', builder: (_) => ListPage()),
          Route(
            path: '/items/:id',
            builder: (params) => ItemPage(params['id']!),
          ),
        ],
        notFound: () => NotFoundPage(),
      ),
      layout: (page) => AppLayout(page),
    ),
  );
}

```

Routes can declare dynamic segments using `:paramName`.
The resolved values are passed to the builder via the `params` map.

### Navigating Between Routes

Programmatic navigation:
```dart
navigateTo('/items/abc123');
```

Declarative navigation:

```dart
a(
  href: '/coffees/abc123',
  onClick: (e) {
    e.preventDefault();
    navigateTo('/coffees/abc123');
  },
  children: [text('Open coffee')],
);
```
Both approaches produce the same result.
No reloads, no remounts unless necessary.

### Component Lifecylce

Pulsar components expose a small, explicit lifecycle.

```dart
class Example extends Component {
  @override
  void onMount() {
    // Runs once when the component is attached
  }

  @override
  void onUpdate() {
    // Runs after each update triggered by setState or update()
  }

  @override
  void onUnmount() {
    // Cleanup logic (timers, listeners, etc.)
  }

  @override
  PulsarNode render() {
    return div(children: [text('Hello')]);
  }
}
```

Lifecycle methods are optional.
If you don’t need them, you don’t pay for them.

### Morphic Components
Pulsar components are morphic by design.

A component is not tied to a single immutable configuration.
It can evolve over time without being destroyed and recreated.

This allows patterns such as:

- Updating route parameters without remounting
- Reusing the same component instance across navigations
- Preserving internal state intentionally

```dart
class CoffeePage extends Component {
  String id;

  CoffeePage(this.id);

  void updateId(String newId) {
    if (id != newId) {
      id = newId;
      update();
    }
  }

  @override
  PulsarNode render() {
    return div(children: [text('Coffee ID: $id')]);
  }
}
```

This model avoids:

- Hooks
- Controllers
- Providers
- Implicit dependency graphs

Components are stateful objects, not render functions.

## Core Philosophy

Pulsar is built around one simple idea: clarity over cleverness.

It embraces Dart as it is, without fighting the language or hiding behavior behind magic. The framework favors explicit code, predictable behavior, and direct use of the web platform.

Pulsar grows through reflection, not constant iteration. Every feature exists for a reason, and unnecessary abstractions are intentionally avoided.

The goal is not to be the most powerful framework, but the one that stays understandable, maintainable, and honest over time.

## Principles

Pulsar is guided by a small set of principles that shape every design decision.

- **Clarity over cleverness**<br>
If something feels smart but unclear, it does not belong in Pulsar.

- **Dart first, always**<br>
Pulsar embraces Dart’s type system, null safety, and tooling.

- **Explicit by design**<br>
What you write is what runs.

- **Minimal abstraction**<br>
Abstractions must earn their place.

- **Respect the web platform**<br>
Pulsar works with HTML, CSS, and browser semantics.

- **Reflection over iteration**<br>
Design decisions are deliberate, not trend-driven.

## Golden Rules

These rules act as guardrails for Pulsar’s development.

- If a feature requires magic, it should be reconsidered.

- If Dart already solves the problem, Pulsar must not reimplement it.

- If an abstraction obscures behavior, it is not acceptable.

- If something cannot be explained simply, it is probably wrong.

- If a feature exists only for convenience, it must justify its cost.

- If removing a feature improves clarity, it should be removed.

Pulsar values long-term clarity over short-term convenience.

## Status & Stability

Pulsar is actively developed.
Version `0.4.x` is considered stable and suitable for real projects.

Feedback, issues, and discussions are welcome:<br>
👉 https://github.com/IgnacioFernandez1311/pulsar_web

## Support Pulsar

Pulsar is free and open-source.

If it helps you build better software, consider supporting its development through GitHub Sponsors.

Your support helps keep Pulsar independent, focused, and thoughtfully evolving.

❤️ https://github.com/sponsors/IgnacioFernandez1311