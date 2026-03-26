# Pulsar Roadmap

**Pulsar Web Framework - Evolution Plan**

This roadmap outlines Pulsar's evolution from v1.0 onwards. Every feature must align with core principles: **clarity over cleverness, explicit over implicit, architecture over convenience.**

---

## Guiding Philosophy

Pulsar's growth will be **slow, deliberate, and philosophically coherent**.

### What We Will NOT Add

1. **Features that introduce "magic"** or implicit behavior
2. **Features that compromise Main Thread performance**
3. **Breaking changes** without critical architectural justification
4. **Trend-driven additions** that don't solve real architectural problems
5. **Abstractions that obscure behavior**

### What Guides Every Decision

- ✅ Does it make code clearer?
- ✅ Does it preserve explicit architecture?
- ✅ Does it respect component identity?
- ✅ Can it be explained simply?
- ✅ Does it encourage Domain Oriented UI?

---

## Phase 1: Ecosystem and Structure (Immediate)

**Status:** In Progress  
**Timeline:** Q1-Q2 2025

###  Pulsar Linter (Highest Priority)

The cornerstone of Pulsar is **"Clarity over Cleverness"**. A specialized linter will enforce architectural best practices.

#### Features

**1. Domain Boundary Detection**
- ✅ Detect heavy business logic inside `render()` methods
- ✅ Flag transformations (`.map()`, `.where()`, `.fold()`) in `render()`
- ✅ Suggest extraction to getters or domain objects

```dart
// ❌ Linter Error
@override
Morphic render() {
  return Ul()([
    users.map((u) => UserCard(u)).toList(),  // ❌ Logic in render
  ]);
}

// ✅ Linter Pass
List<UserCard> get userCards => users.map((u) => UserCard(u)).toList();

@override
Morphic render() {
  return Ul()([...userCards]);  // ✅ Pure description
}
```

**2. Domain Object Usage**
- ✅ Ensure persistent state lives in domain objects
- ✅ Detect state scattered across local UI variables
- ✅ Encourage Domain Oriented UI patterns

```dart
// ❌ Linter Warning
final class Cart extends Component {
  double total = 0.0;  // ❌ Business logic in component
  double tax = 0.0;
  
  void calculate() {
    total = items.fold(0.0, (sum, item) => sum + item.price);
    tax = total * 0.1;
  }
}

// ✅ Linter Pass
class CartCalculator {  // ✅ Domain object
  double get total => ...;
  double get tax => ...;
}

final class Cart extends Component {
  final CartCalculator calculator = CartCalculator();
}
```

**3. Identity Persistence Patterns**
- ✅ Flag components created inline in `render()`
- ✅ Enforce component storage as fields
- ✅ Prevent patterns from functional frameworks

```dart
// ❌ Linter Error
@override
Morphic render() {
  return Div()([Counter()]);  // ❌ Identity lost
}

// ✅ Linter Pass
final Counter counter = Counter();

@override
Morphic render() {
  return Div()([counter]);  // ✅ Identity preserved
}
```

**4. Best Practices Enforcement**
- ✅ No `morph()` in `onInput` for text fields
- ✅ Method references vs anonymous functions
- ✅ Enum usage over strings
- ✅ Explicit dependencies (no global state access in components)

#### Configuration

```yaml
# pulsar_analysis_options.yaml
linter:
  rules:
    # Domain Boundary
    - no_logic_in_render
    - require_domain_objects_for_business_logic
    
    # Identity Preservation
    - components_must_be_fields
    - no_inline_component_creation
    
    # State Management
    - no_morph_in_on_input
    - explicit_state_updates
    
    # Type Safety
    - prefer_enums_over_strings
    - explicit_dependencies
```

#### Why This Matters

-  **Enforces philosophy** through tooling, not just documentation
-  **Catches mistakes early** in development
-  **Educates developers** on Pulsar patterns
-  **Prevents regression** to bad patterns from other frameworks

---

### Fragment Implementation

**Status:** Planned  
**Timeline:** Q2 2025

A new `Morphic` type that allows grouping multiple elements without adding extra DOM nodes.

#### The Problem

```dart
// ❌ Problem: Wrapper div pollutes DOM
@override
Morphic render() {
  return Div()([  // Extra <div> in DOM
    H1()(['Title']),
    P()(['Paragraph']),
  ]);
}
```

#### The Solution

```dart
// ✅ Solution: Fragment groups without wrapper
@override
Morphic render() {
  return Fragment()([  // No extra DOM node
    H1()(['Title']),
    P()(['Paragraph']),
  ]);
}
```

#### Architecture

**Fragment as Morphic Type:**
```dart
sealed class Morphic {
  // Existing types
  const Morphic.element(Element element);
  const Morphic.text(String text);
  
  // New type
  const Morphic.fragment(List<Morphic> children);  // ✅ New
}
```

**Usage Contract:**
- ✅ `render()` always returns a single `Morphic`
- ✅ No confusion between component hierarchy and DOM hierarchy
- ✅ Clean HTML output without unnecessary wrappers

#### Use Cases

**1. Component returning multiple siblings:**
```dart
final class TableRow extends Component {
  @override
  Morphic render() {
    return Fragment()([
      Td()(['Cell 1']),
      Td()(['Cell 2']),
      Td()(['Cell 3']),
    ]);
  }
}
```

**2. Conditional rendering without wrappers:**
```dart
@override
Morphic render() {
  return Fragment()([
    if (showHeader) Header(),
    Main()([content]),
    if (showFooter) Footer(),
  ]);
}
```

**3. List rendering:**
```dart
@override
Morphic render() {
  return Fragment()([
    for (var item in items)
      ItemCard(item),
  ]);
}
```

---

## Phase 2: Development Tools (Q2-Q3 2026)

**Status:** Planned  
**Timeline:** Q2-Q3 2026

###  Pulsar DevTools

A browser extension and integrated inspector for debugging Pulsar applications.

#### Features

**1. Component Tree Visualization**
- ✅ Visualize persistent component hierarchy
- ✅ Show component identity (memory address, creation time)
- ✅ Highlight components vs DOM elements
- ✅ Track component lifecycle (mount, morph, unmount)

**2. Domain Object Inspector**
- ✅ Inspect domain object state in real-time
- ✅ View computed properties and getters
- ✅ Track domain object mutations
- ✅ Visualize relationships between components and domain objects

**3. morph() Profiler**
- ✅ Track all `morph()` calls with timestamps
- ✅ Measure render time per component
- ✅ Identify performance bottlenecks
- ✅ Visualize component update frequency
- ✅ Detect unnecessary re-renders

**4. State Timeline**
- ✅ Replay state mutations over time
- ✅ Time-travel debugging
- ✅ Export/import state snapshots
- ✅ Compare state before/after morph()

**5. Architecture Validator**
- ✅ Detect DOU violations (logic in components)
- ✅ Suggest domain object extraction
- ✅ Flag identity preservation issues
- ✅ Real-time linter feedback

#### UI Concept

```
┌─────────────────────────────────────────────────────────┐
│ Pulsar DevTools                                         │
├─────────────────────────────────────────────────────────┤
│ [Components] [Domain Objects] [Performance] [Timeline]  │
├──────────────────────┬──────────────────────────────────┤
│ Component Tree       │ Selected: TodoApp                │
│                      │                                  │
│ ▼ TodoApp            │ State:                           │
│   │ ├─ TodoList ●    │   - todos: TodoList              │
│   │ ├─ Input         │   - inputValue: ""               │
│   │ └─ Ul            │   - currentFilter: Filter.all    │
│   │   ├─ TodoItem ●  │                                  │
│   │   └─ TodoItem ●  │ Domain Objects:                  │
│                      │   - TodoList (3 items)           │
│ ● = Persistent       │     - active: 2                  │
│ ○ = Ephemeral        │     - completed: 1               │
│                      │                                  │
│                      │ morph() calls: 12                │
│                      │ Avg render: 2.3ms                │
└──────────────────────┴──────────────────────────────────┘
```

---

###  Pulsar CLI Enhancements

Improvements to the command-line interface for better developer experience.

#### Features

**1. Component/DSO Pair Generation**

```bash
pulsar generate component UserCard --with-domain
```

**Generates:**
```
lib/
├── components/
│   └── user_card/
│       └── user_card.dart       # Component
└── domain/
    └── user/
        └── user_card_state.dart # Domain object
```

**Generated Component:**
```dart
import 'package:my_app/domain/user/user_card_state.dart';

final class UserCard extends Component {
  final UserCardState state;
  
  UserCard(this.state);
  
  @override
  Morphic render() {
    return Div().classes("user-card")([
      // TODO: Implement
    ]);
  }
}
```

**Generated Domain Object:**
```dart
class UserCardState {
  // TODO: Add domain logic
}
```

**2. Domain Object Generator**

```bash
pulsar generate domain ShoppingCart
```

**3. Route Generator**

```bash
pulsar generate route /users/:userId --component UserPage
```

**4. Architecture Scaffolding**

```bash
pulsar generate feature TodoList
```

**Generates complete feature structure:**
```
lib/
├── features/
│   └── todo_list/
│       ├── components/
│       │   ├── todo_app.dart
│       │   └── todo_item.dart
│       ├── domain/
│       │   ├── todo.dart
│       │   └── todo_list.dart
│       └── styles/
│           └── todo.css
```

**5. Migration Tools**

```bash
pulsar migrate v0.4-to-v1.0
```

- ✅ Automated syntax migration
- ✅ Pattern detection and replacement
- ✅ Generate migration report

---

## Phase 3: Advanced Use Cases (Future)

**Status:** Research  
**Timeline:** 2027+

###  Real-Time Synchronization Protocols

Official abstractions for connecting domain objects with real-time backends.

#### Features

**1. WebSocket Integration**

```dart
class TodoListSync extends TodoList {
  final WebSocketChannel channel;
  
  TodoListSync(this.channel) {
    channel.stream.listen((message) {
      final update = TodoUpdate.fromJson(message);
      applyRemoteUpdate(update);
    });
  }
  
  @override
  void add(String text) {
    super.add(text);
    channel.sink.add(jsonEncode({'action': 'add', 'text': text}));
  }
}
```

**2. gRPC Streaming**

```dart
class CollaborativeDocument extends Document {
  final DocumentServiceClient grpc;
  
  CollaborativeDocument(this.grpc) {
    grpc.watchDocument(documentId).listen(applyRemoteChange);
  }
}
```

**3. Conflict Resolution Patterns**

```dart
abstract class SyncStrategy {
  void resolveConflict(LocalChange local, RemoteChange remote);
}

class LastWriteWins extends SyncStrategy { ... }
class OperationalTransform extends SyncStrategy { ... }
```

#### Use Cases

- ✅ Collaborative editing platforms
- ✅ Virtual tabletops (VTTs)
- ✅ Real-time dashboards
- ✅ Multiplayer game state
- ✅ Live data visualization

---

### 🧪 Identity Testing Suite

Specialized testing tools for Pulsar's component identity model.

#### Features

**1. Identity Assertions**

```dart
test('component preserves identity across morphs', () {
  final app = TodoApp();
  final todoItem = app.todoElements[0];
  
  app.handleToggle(todoItem.todo.id);
  
  // Assert same instance
  expect(app.todoElements[0], same(todoItem));
});
```

**2. State Mutation Tracking**

```dart
test('domain object mutations propagate correctly', () {
  final todos = TodoList();
  final tracker = StateTracker(todos);
  
  todos.add('Task 1');
  
  expect(tracker.mutations, [
    Mutation(field: 'items', type: MutationType.add),
  ]);
});
```

**3. Lifecycle Verification**

```dart
test('component lifecycle fires correctly', () {
  final app = TodoApp();
  final lifecycle = LifecycleTracker(app);
  
  app.attach(runtime);
  app.morph(() => app.inputValue = 'test');
  app.detach();
  
  expect(lifecycle.events, [
    LifecycleEvent.mount,
    LifecycleEvent.morph,
    LifecycleEvent.unmount,
  ]);
});
```

**4. Performance Regression Tests**

```dart
test('render performance stays under threshold', () {
  final app = LargeListApp(items: 1000);
  
  final benchmark = Benchmark();
  benchmark.measure(() => app.render());
  
  expect(benchmark.duration, lessThan(Duration(milliseconds: 16)));
});
```

---

## Version Milestones

### v1.0 (Released)
- ✅ Core component model
- ✅ Routing system
- ✅ State management with morph()
- ✅ Element builders
- ✅ Morphic type system
- ✅ Documentation and examples

### v1.1 (Q2 2026)
- 🔄 Pulsar Linter
- 🔄 Fragment implementation
- 🔄 CLI enhancements (basic)

### v1.2 (Q3 2026)
- 🔄 DevTools (alpha)
- 🔄 Advanced CLI generators
- 🔄 Testing utilities

### v1.3 (Q4 2026)
- 🔄 DevTools (stable)
- 🔄 Performance profiling tools
- 🔄 Architecture validator

### v2.0 (2027+)
- 🔄 Real-time sync abstractions
- 🔄 Identity testing suite
- 🔄 Advanced tooling ecosystem

---

## Community Contributions

We welcome contributions that align with Pulsar's philosophy.

### High-Priority Areas
-  Documentation improvements
-  Example applications
-  Linter rule implementations
-  CLI command additions
-  Educational content

### Contribution Process

1. **Read the philosophy** - Understand core principles
2. **Open an issue** - Discuss idea before implementation
3. **Follow patterns** - Match existing code style
4. **Write tests** - Ensure quality
5. **Document thoroughly** - Explain the "why"

### What We're Looking For

- ✅ Thoughtful feature proposals
- ✅ Bug reports with clear reproduction
- ✅ Performance improvements
- ✅ Educational content (blogs, videos, tutorials)
- ✅ Integration examples (Firebase, Supabase, etc.)

### What We Won't Accept

- ❌ Features that add "magic"
- ❌ Abstractions that obscure behavior
- ❌ Trend-driven additions
- ❌ Breaking changes without justification
- ❌ Contributions that fight the philosophy

---

## Long-Term Vision

Pulsar aims to be:

1. **The clarity-first framework** - Code that stays understandable
2. **The architecture-first framework** - Patterns that scale
3. **The Dart-native framework** - Embracing the language, not fighting it
4. **The DDD framework for frontend** - Domain objects, not just UI
5. **The framework for the long term** - Built to last years, not months

### Not Our Goals

- ❌ Most popular framework
- ❌ Fastest iteration speed
- ❌ Largest feature set
- ❌ Framework for everyone

### Success Metrics

- ✅ Applications stay maintainable at scale
- ✅ New developers understand the codebase
- ✅ Code remains clear after months/years
- ✅ Teams report reduced technical debt
- ✅ Philosophy guides decisions naturally

---

## Get Involved

- 💬 **Discussions:** https://github.com/IgnacioFernandez1311/pulsar_web/discussions
- 🐛 **Issues:** https://github.com/IgnacioFernandez1311/pulsar_web/issues
- 📖 **Docs:** https://pulsar-web.netlify.app/docs
- 🌐 **Website:** https://pulsar-web.netlify.app

---

**Roadmap Last Updated:** March 2026  
**Next Review:** June 2026

---

*Built with clarity. Maintained with discipline. Evolved with intention.*

— Pulsar Web Framework