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

**A Dart-first web framework for building structured, maintainable applications with explicit architecture and long-term clarity.**

Pulsar treats components as long-lived objects, not disposable functions. It prioritizes explicit design over framework magic, and applies Domain-Driven Design principles to frontend development.

It's not about being the most powerful framework. It's about being the most **understandable**, **maintainable**, and **architecturally sound** one.

🌐 **Website:** https://pulsar-web.netlify.app  
📖 **Docs:** https://pulsar-web.netlify.app/docs  
💬 **Discussions:** https://github.com/IgnacioFernandez1311/pulsar_web/discussions

---

## Why Pulsar?

Most modern frameworks optimize for speed of iteration rather than long-term clarity. As applications grow, UI logic becomes fragmented across implicit abstractions, hidden state flows, and short-lived components.

**Pulsar exists as a response to that complexity.**

It favors:
- ✅ **Explicit architecture** over framework magic
- ✅ **Long-lived objects** over ephemeral renders
- ✅ **Domain-driven design** over component-centric logic
- ✅ **Type safety** over stringly-typed APIs
- ✅ **Predictable behavior** over convenience-driven patterns

---

## Core Philosophy

Pulsar is built around a clear philosophy: **clarity over cleverness, explicit over implicit, architecture over convenience.**

### The Pulsar Way

1. **Components are objects, not functions** — They preserve identity, hold state, and evolve over time
2. **Pure description in render()** — All logic lives in getters or methods, render() only describes structure
3. **Explicit state updates** — morph() makes changes visible and deliberate
4. **Domain Oriented UI** — Business logic and styling logic live in domain objects, not components
5. **Type-safe abstractions** — Enums over strings, objects over maps
6. **Web-native** — Embrace HTML, CSS, and browser APIs

Every design decision exists to reduce cognitive load as applications grow, keeping UI behavior explicit and easy to reason about over time.

---

## Domain Oriented UI (DOU)

At the heart of Pulsar is **Domain Oriented UI** — a methodology that applies Domain-Driven Design principles to frontend development.

### The Three Layers

**1. Domain Layer** — Business logic in pure Dart objects
```dart
class ShoppingCart {
  List<CartItem> items = [];
  
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;
  
  void addItem(CartItem item) => items.add(item);
  void removeItem(String id) => items.removeWhere((item) => item.id == id);
}
```

**2. Styling Layer** — Visual decisions in domain styling objects
```dart
enum CartStatus { empty, active, checkout }

class CartStyles {
  final CartStatus status;
  
  CartStyles(this.status);
  
  String get containerClasses => switch (status) {
    CartStatus.empty => 'cart cart-empty',
    CartStatus.active => 'cart cart-active',
    CartStatus.checkout => 'cart cart-checkout',
  };
  
  static const empty = CartStyles(CartStatus.empty);
  static const active = CartStyles(CartStatus.active);
}
```

**3. UI Layer** — Pure structure in components
```dart
final class CartView extends Component {
  final ShoppingCart cart = ShoppingCart();
  
  CartStyles get styles => cart.items.isEmpty 
    ? CartStyles.empty 
    : CartStyles.active;

  @override
  Morphic render() {
    return Div().classes(styles.containerClasses)([
      H2()(['Shopping Cart']),
      P()(['Total: \$${cart.total.toStringAsFixed(2)}']),
      // ...
    ]);
  }
}
```

**Why DOU matters:**
- ✅ Business logic is testable without rendering UI
- ✅ Styling logic is isolated and reusable
- ✅ Components are simple coordinators, not complex logic containers
- ✅ Domain objects can be used anywhere (API, CLI, tests, backend)

---

## Quick Start

### Installation

Install the Pulsar CLI:

```bash
dart pub global activate pulsar_cli
```

Create a new project:

```bash
pulsar create my_app
cd my_app
```

Run the development server:

```bash
pulsar serve
```

Your app runs at `http://localhost:8080`.

### Your First Component

Create `lib/components/counter.dart`:

```dart
import 'package:pulsar_web/pulsar.dart';

final class Counter extends Component {
  int count = 0;
  List<String> history = [];

  void increment(Event e) {
    morph(() {
      count++;
      history.add('Incremented to $count');
    });
  }

  void decrement(Event e) {
    morph(() {
      count--;
      history.add('Decremented to $count');
    });
  }

  void reset(Event e) {
    morph(() {
      count = 0;
      history.add('Reset to 0');
    });
  }

  List<Morphic> get historyItems =>
    history.reversed.map((entry) => Li()([entry])).toList();

  @override
  Morphic render() {
    return Div().classes("counter")([
      H1()(['Count: $count']),
      
      Div().classes("controls")([
        Button().onClick(decrement)(['-']),
        Button().onClick(reset)(['Reset']),
        Button().onClick(increment)(['+']),
      ]),
      
      if (history.isNotEmpty)
        Ul().classes("history")([...historyItems]),
    ]);
  }
}
```

**Key concepts:**
- State lives in fields (`count`, `history`)
- Event handlers are methods (`increment`, `decrement`, `reset`)
- `morph()` wraps state changes and triggers re-renders
- Transformations happen in getters (`historyItems`), not in `render()`
- `render()` is a pure description of structure

---

## Core Concepts

### Components Are Objects

Components in Pulsar are **long-lived objects with identity**, not disposable functions.

```dart
final class UserProfile extends Component {
  final User user;
  bool isEditing = false;
  
  UserProfile(this.user);
  
  void toggleEdit(Event e) {
    morph(() => isEditing = !isEditing);
  }

  @override
  Morphic render() {
    return Div().classes("profile")([
      if (isEditing)
        ProfileEditor(user, onSave: toggleEdit),
      else
        ProfileDisplay(user, onEdit: toggleEdit),
    ]);
  }
}
```

**Why objects matter:**
- ✅ Identity is explicit (same instance across renders)
- ✅ State is simple (just fields)
- ✅ Lifecycle is clear (created once, lives until destroyed)
- ✅ Testing is easy (instantiate and call methods)

### The Identity Persistence Rule

**Critical:** Components only maintain identity if stored as **fields**, not created inline.

```dart
// ❌ WRONG - New instance every render
final class App extends Component {
  @override
  Morphic render() => Div()([Counter()]);  // Identity lost
}

// ✅ CORRECT - Identity preserved
final class App extends Component {
  final Counter counter = Counter();  // Stored as field
  
  @override
  Morphic render() => Div()([counter]);  // Same instance always
}
```

This is **intentional design**, not a limitation:
- Explicit object lifecycle
- Predictable state management
- No hidden component reconciliation
- You control when components are created and destroyed

### Pure render()

The `render()` method must be a **pure description** of structure. All computation belongs in getters or methods.

```dart
// ❌ BAD - Transformation in render()
@override
Morphic render() {
  return Ul()([
    users.map((user) => UserCard(user)).toList(),  // ❌ Logic in render
  ]);
}

// ✅ GOOD - Transformation in getter
List<UserCard> get userCards =>
  users.map((user) => UserCard(user)).toList();

@override
Morphic render() {
  return Ul()([...userCards]);  // ✅ Pure description
}
```

**Why this matters:**
- ✅ Separation of concerns (computation vs structure)
- ✅ Better performance (getters can be cached)
- ✅ Easier testing (test getters independently)
- ✅ Clearer code (render is just structure)

### State Management with morph()

All state changes must happen inside `morph()`. There is no automatic reactivity.

```dart
final class TodoList extends Component {
  List<Todo> todos = [];
  
  void addTodo(String text) {
    morph(() => todos.add(Todo(text: text)));
  }
  
  void toggleTodo(Todo todo) {
    morph(() => todo.completed = !todo.completed);
  }
  
  void removeTodo(Todo todo) {
    morph(() => todos.remove(todo));
  }
}
```

**Why explicit updates:**
- ✅ You know exactly when renders happen
- ✅ You can batch multiple mutations in one morph()
- ✅ No proxy objects or hidden getters
- ✅ Predictable, debuggable state changes

### Routing

Pulsar includes a built-in router with parametric routing and nested routes.

```dart
final router = Router(
  routes: [
    Route(path: '/', builder: (_) => HomePage()),
    Route(
      path: '/about',
      builder: (_) => AboutPage(),
      catchAll: true // Allows nested Routing with paths like /about/info
    ),
    Route(path: '/users/:userId', builder: (params) => 
      UserPage(params['userId']!)
    ),
  ],
  notFound: () => NotFoundPage(),
);

void main() {
  mountApp(
    RouterComponent(
      router: router,
      layout: (page) => AppLayout(page),
    ),
  );
}
```

**For stateful routes**, store components as fields:

```dart
final class App extends Component {
  final DashboardPage dashboard = DashboardPage();
  
  late final Router router = Router(
    routes: [
      Route(path: '/', builder: (_) => HomePage()),
      Route(path: '/dashboard', builder: (_) => dashboard),  // Returns field
    ],
  );
}
```

Navigation uses standard HTML links:

```dart
A().href('/about')(['About Page'])
A().href('/users/123')(['View User'])
```

### Styling

Components can declare their CSS dependencies:

```dart
final class Card extends Component {
  @override
  List<Stylesheet> get styles => [
    css("styles/components/card.css"),  // Relative to web/
  ];
  
  @override
  Morphic render() {
    return Div().classes("card")([
      // Styles are loaded
    ]);
  }
}
```

**Domain styling objects** encapsulate visual logic:

```dart
enum ButtonVariant { primary, secondary, success, danger }

class ButtonStyles {
  final ButtonVariant variant;
  final bool disabled;
  
  ButtonStyles({
    this.variant = ButtonVariant.primary,
    this.disabled = false,
  });
  
  String get classes {
    final base = 'btn';
    final variantClass = 'btn-${variant.name}';
    final disabledClass = disabled ? 'btn-disabled' : '';
    
    return [base, variantClass, disabledClass]
        .where((c) => c.isNotEmpty)
        .join(' ');
  }
  
  static const primary = ButtonStyles();
  static const success = ButtonStyles(variant: ButtonVariant.success);
}

// Usage
Button().classes(ButtonStyles.success.classes)(['Submit'])
```

---

## What Makes Pulsar Different?

### 1. Components Are Objects, Not Functions

Unlike functional frameworks where components are called on every render, Pulsar components are **long-lived objects** that persist and evolve.

```dart
final class Counter extends Component {
  int count = 0;  // State is just a field
  
  void increment(Event e) => morph(() => count++);
  
  @override
  Morphic render() => Button().onClick(increment)(['Count: $count']);
}
```

No hooks. No special rules. Just objects and methods.

### 2. Morphic Components: Semantic Versatility

**"Morphic"** means **semantic flexibility**, not performance optimization.

There is no artificial hierarchy. Everything is a `Component`:
- A page in the router
- A widget in a sidebar
- A modal overlay
- A layout wrapper

The same component can morph between roles and states without being destroyed:

```dart
final class UserProfile extends Component {
  String userId;
  DisplayMode mode;  // full, compact, modal
  
  UserProfile(this.userId, {this.mode = DisplayMode.full});
  
  void showUser(String newId) => morph(() => userId = newId);
  void switchMode(DisplayMode newMode) => morph(() => mode = newMode);
  
  @override
  Morphic render() {
    return switch (mode) {
      DisplayMode.full => _renderFullProfile(),
      DisplayMode.compact => _renderCompactCard(),
      DisplayMode.modal => _renderModalView(),
    };
  }
}
```

### 3. Domain Oriented UI

Business logic and styling logic live in **domain objects**, not components.

```dart
// Domain object: testable without UI
class OrderCalculator {
  List<OrderItem> items;
  
  OrderCalculator(this.items);
  
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;
}

// Component: thin coordinator
final class OrderSummary extends Component {
  final OrderCalculator calculator;
  
  OrderSummary(this.calculator);

  @override
  Morphic render() {
    return Div().classes("order-summary")([
      P()(['Subtotal: \$${calculator.subtotal.toStringAsFixed(2)}']),
      P()(['Tax: \$${calculator.tax.toStringAsFixed(2)}']),
      P()(['Total: \$${calculator.total.toStringAsFixed(2)}']),
    ]);
  }
}
```

### 4. Type Safety First

Enums over strings, objects over maps, compile-time checks over runtime errors.

```dart
// ❌ Stringly-typed
Button('Submit', variant: 'success')

// ✅ Type-safe
enum ButtonVariant { primary, secondary, success }
Button('Submit', variant: ButtonVariant.success)
```

### 5. Explicit Over Implicit

Dependencies, data flow, and state changes are **visible in code**.

```dart
// ❌ Hidden dependency
final class UserProfile extends Component {
  @override
  Morphic render() {
    final user = GlobalState.currentUser;  // Where does this come from?
    return Div()([user.name]);
  }
}

// ✅ Explicit dependency
final class UserProfile extends Component {
  final User user;
  
  UserProfile(this.user);  // Clear and testable

  @override
  Morphic render() {
    return Div()([user.name]);
  }
}
```

### 6. Fluent Element Builders

Pulsar 1.0 uses Dart's call operator for concise, type-safe element creation:

```dart
// Simple text
H1()(['Hello World'])

// Attributes + children
Button()
  .classes('btn primary')
  .onClick(handleClick)
(['Submit'])

// Conditional rendering
Div()([
  if (showHeader) H1()(['Title']),
  P()(['Content']),
])

// Lists
Ul()([...itemList])
```

**Why not JSX or templates?**
- ✅ Full IDE support (autocomplete, refactoring, type checking)
- ✅ No build step complexity
- ✅ No DSL to learn
- ✅ Pure Dart code

---

## Design Principles

Every design decision in Pulsar aligns with these principles:

### 1. Clarity Over Cleverness
Code should be obvious, not smart.

### 2. Explicit Over Implicit
Dependencies and data flow must be visible.

### 3. Objects Over Functions
Components are long-lived objects with identity and lifecycle.

### 4. Configuration Over Magic
Behavior should be configured explicitly, not inferred.

### 5. Architecture Over Convenience
Good architecture may require more code upfront, but pays dividends as systems grow.

### 6. Dart-First, Always
Use Dart's type system, null safety, and tooling naturally.

### 7. Web-Native
Work with HTML, CSS, and browser APIs, don't hide them.

---

## Pulsar 1.0: Foundation Release

Version 1.0 represents Pulsar's **philosophical foundation**, not feature completeness.

### What 1.0 Means

**Philosophically coherent:**
- Every design decision aligns with core principles
- No lingering compromises
- The architecture feels complete

**API stable:**
- Future changes will be additive, not breaking
- Safe to invest in learning and building

**Production-ready conceptually:**
- The mental model is solid
- You can build real apps with confidence
- Missing features (SSR, DevTools) don't compromise the foundation

### What Changed in 1.0

#### Fluent Element Builders

**Before (v0.4):**
```dart
div(
  classes: 'container',
  children: [h1(children: [text('Title')])],
)
```

**After (v1.0):**
```dart
Div().classes('container')([
  H1()(['Title']),
])
```

#### Morphic Type System

**Before:** `PulsarNode` (Element, Text, Component wrapper)  
**After:** `Morphic` (Element, Text) — Components resolve directly

#### Explicit morph() for All Updates

State changes require `morph()` — no automatic reactivity.

#### Component Identity Preservation

Components must be stored as fields to maintain identity across renders.

---

## Project Structure

```
my_app/
├── lib/
│   ├── main.dart             # App entry point
│   ├── components/           # UI components
│   │   ├── counter.dart
│   │   └── user_card.dart
│   └── domain/               # Business logic
│       ├── cart.dart
│       └── order_calculator.dart
├── web/
│   ├── index.html            # HTML entry point
│   └── styles/
│       ├── app.css           # Global styles
│       └── components/       # Component styles
│           └── counter.css
└── pubspec.yaml
```

**Why `lib/` for components?**
- Clean package imports (`package:my_app/components/counter.dart`)
- No fragile relative paths
- Proper Dart project structure
- Better IDE support

---

## Performance by Design

Pulsar's architecture is **performance-friendly by design**, not through premature optimization:

### 1. Getters for Dynamic Lists

```dart
List<UserCard> get userCards =>
  users.map((user) => UserCard(user)).toList();
```

- ✅ Lazy evaluation
- ✅ Natural caching opportunities
- ✅ Less GC pressure
- ✅ Computed data, not computed structure

### 2. Final Classes

```dart
final class Counter extends Component { ... }
```

- ✅ Compiler devirtualization
- ✅ Smaller vtables
- ✅ More aggressive JIT optimization

### 3. Component Identity Preservation

```dart
final Counter counter = Counter();  // Created once
```

- ✅ Less object creation/destruction
- ✅ Predictable memory patterns
- ✅ Reduced GC cycles

### 4. Pure render()

```dart
@override
Morphic render() {
  return Div()([...userCards]);  // Fast and predictable
}
```

- ✅ No side effects
- ✅ Can be called multiple times safely
- ✅ Easy to profile and optimize

These aren't premature optimizations — they're **architectural decisions that make code clearer AND faster**.

---

## FAQ

### Is this production-ready?

**Conceptually: Yes.** The architecture is solid and battle-tested.

**Practically:**
- ✅ Core framework stable
- ✅ Routing works well
- ✅ Component model proven
- ⚠️ Missing: SSR, extensive DevTools, large ecosystem

**Best for:**
- Personal projects
- Internal tools
- MVPs and prototypes
- Projects where you control the stack

**Not yet ideal for:**
- SEO-critical sites (SSR coming soon)
- Large teams without extensive documentation
- Projects requiring many third-party packages

### Do I need to learn Flutter first?

**No.** Pulsar is not Flutter for Web.

If you know Dart and basic web development (HTML/CSS), you can learn Pulsar.

Flutter experience may create wrong expectations (Widgets, BuildContext, InheritedWidget patterns don't apply).

### Why not use React/Vue/Svelte?

Pulsar is designed for developers who value:
- **Dart's type system** over JavaScript/TypeScript
- **Explicit architecture** over framework magic
- **Long-term maintainability** over short-term convenience
- **Object-oriented patterns** over functional paradigms
- **Domain-driven design** in frontend code

If you're happy with JavaScript frameworks, keep using them. Pulsar is for teams who want something different.

### Can I use Tailwind/Bootstrap?

Yes! Pulsar works with any CSS framework:

```dart
final class Card extends Component {
  @override
  Morphic render() {
    return Div().classes("bg-white rounded-lg shadow-md p-6")([
      // Tailwind classes work perfectly
    ]);
  }
}
```

Domain styling objects work great with utility frameworks:

```dart
class CardStyles {
  static const elevated = 'bg-white rounded-lg shadow-xl p-6';
  static const flat = 'bg-gray-100 rounded p-4';
}
```

---

## Examples

### Counter with History

```dart
final class Counter extends Component {
  int count = 0;
  List<String> history = [];

  void increment(Event e) {
    morph(() {
      count++;
      history.add('Incremented to $count');
    });
  }

  List<Morphic> get historyItems =>
    history.reversed.map((entry) => Li()([entry])).toList();

  @override
  Morphic render() {
    return Div()([
      H1()(['Count: $count']),
      Button().onClick(increment)(['+']),
      if (history.isNotEmpty)
        Ul()([...historyItems]),
    ]);
  }
}
```

### TodoMVC

```dart
final class TodoApp extends Component {
  List<Todo> todos = [];
  
  void addTodo(String text) {
    morph(() => todos.add(Todo(text: text)));
  }
  
  void toggleTodo(Todo todo) {
    morph(() => todo.completed = !todo.completed);
  }
  
  void removeTodo(Todo todo) {
    morph(() => todos.remove(todo));
  }
  
  List<TodoItem> get todoItems =>
    todos.map((todo) => TodoItem(
      todo: todo,
      onToggle: () => toggleTodo(todo),
      onRemove: () => removeTodo(todo),
    )).toList();

  @override
  Morphic render() {
    return Div().classes('todo-app')([
      H1()(['Todos']),
      TodoInput(onAdd: addTodo),
      Ul()([...todoItems]),
    ]);
  }
}
```

---

## Contributing

Pulsar is open to contributions that align with its philosophy.

**Before contributing:**
1. Read the philosophy and design principles
2. Check existing issues/discussions
3. Open an issue to discuss your idea

**Contribution areas:**
- Documentation improvements
- Example applications
- Bug fixes
- Thoughtful feature proposals

**Not accepting:**
- Features that add "magic"
- Abstractions that obscure behavior
- Trend-driven additions
- Breaking changes without strong justification

---

## Support Pulsar

Pulsar is free, open-source, and independently developed.

If it helps you build better software, consider supporting:

❤️ **GitHub Sponsors:** https://github.com/sponsors/IgnacioFernandez1311

Your support:
- Keeps Pulsar independent
- Funds documentation and examples
- Enables focused, thoughtful development
- Signals that clarity-first frameworks matter

---

## License

BSD-3-Clause License - See [LICENSE](LICENSE) file.

---

## Links

- 🌐 **Website:** https://pulsar-web.netlify.app
- 📦 **Pub Package:** https://pub.dev/packages/pulsar_web
- 💬 **Discussions:** https://github.com/IgnacioFernandez1311/pulsar_web/discussions
- 🐛 **Issues:** https://github.com/IgnacioFernandez1311/pulsar_web/issues
- 📖 **Docs:** https://pulsar-web.netlify.app/docs
- 🚀 **CLI:** https://pub.dev/packages/pulsar_cli

---

**Built with clarity. Maintained with discipline. Evolved with intention.**

*— Pulsar Web Framework*