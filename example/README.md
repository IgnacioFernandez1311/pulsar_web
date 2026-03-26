# TodoApp Example - Pulsar Web Framework

A complete todo application demonstrating **Domain Oriented UI (DOU)** architecture in Pulsar.

This example showcases:
- ✅ Domain objects for business logic
- ✅ Component composition and state management
- ✅ Event handling and user interaction
- ✅ Filtering and computed state
- ✅ Parent-child component communication
- ✅ Type-safe enums and data modeling

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Domain Layer](#domain-layer)
4. [Components](#components)
5. [State Management](#state-management)
6. [Event Handling](#event-handling)
7. [Styling](#styling)
8. [Running the App](#running-the-app)
9. [Key Concepts](#key-concepts)

---

## Overview

This TodoApp implements a classic todo list with:
- Add new todos
- Toggle completion status
- Remove todos
- Filter by all/active/completed
- Display remaining items count

**The app demonstrates Pulsar's core philosophy:**
- Business logic in domain objects (`TodoList`, `Todo`)
- Components as coordinators (`TodoApp`, `TodoItem`)
- Explicit state management with `morph()`
- Pure `render()` methods

---

## Architecture

### The Layers of DOU

```
┌─────────────────────────────────────────┐
│   Domain Layer (Business Logic)         │
│   - TodoList: Manages todo operations   │
│   - Todo: Data model                    │
│   - Filter: Enum for filter states      │
└─────────────────────────────────────────┘
                    ▲
                    │
┌─────────────────────────────────────────┐
│   UI Layer (Components)                 │
│   - TodoApp: Main component             │
│   - TodoItem: Individual todo renderer  │
└─────────────────────────────────────────┘
```

**Key Separation:**
- `TodoList` knows nothing about UI
- Components only coordinate between domain and UI
- State lives in domain objects

---

## Domain Layer

### TodoList - Business Logic

```dart
class TodoList {
  List<Todo> items = [];
  
  void add(String text) {
    items.add(
      Todo(id: DateTime.now().toString(), text: text, completed: false),
    );
  }
  
  void toggle(String id) {
    final todo = items.firstWhere((t) => t.id == id);
    todo.completed = !todo.completed;
  }
  
  void remove(String id) {
    items.removeWhere((t) => t.id == id);
  }
  
  List<Todo> get active => items.where((t) => !t.completed).toList();
  List<Todo> get completed => items.where((t) => t.completed).toList();
}
```

**What it does:**
- ✅ Manages the list of todos
- ✅ Provides operations: add, toggle, remove
- ✅ Computes derived state: active todos, completed todos
- ✅ **Pure Dart** - can be tested without UI

**Why this matters:**
- Test business logic independently: `expect(todos.active.length, 2)`
- Reuse in CLI, API, or other contexts
- Clear single responsibility

### Todo - Data Model

```dart
class Todo {
  final String id;
  final String text;
  bool completed;
  
  Todo({required this.id, required this.text, required this.completed});
}
```

**Simple data class:**
- `id` - Unique identifier (timestamp-based)
- `text` - Todo description
- `completed` - Completion status (mutable)

### Filter - Type-Safe Enum

```dart
enum Filter { all, active, completed }
```

**Instead of strings:**
```dart
// ❌ BAD - Stringly-typed
String filter = 'all';
if (filter == 'activ') { ... }  // Typo at runtime

// ✅ GOOD - Type-safe
Filter filter = Filter.all;
if (filter == Filter.activ) { ... }  // Compile error
```

---

## Components

### TodoApp - Main Component

The root component that coordinates everything.

#### State

```dart
final TodoList todos = TodoList();  // Domain object
String inputValue = '';             // Input field state
Filter currentFilter = Filter.all;  // Current filter
```

**Three pieces of state:**
1. `todos` - The domain object (business logic)
2. `inputValue` - UI-specific (text input)
3. `currentFilter` - UI-specific (filter selection)

#### Computed State

```dart
List<Todo> get filteredTodos {
  return switch (currentFilter) {
    Filter.all => todos.items,
    Filter.active => todos.active,
    Filter.completed => todos.completed,
  };
}

List<TodoItem> get todoElements => filteredTodos
  .map((todo) => TodoItem(
    todo: todo,
    onToggle: () => handleToggle(todo.id),
    onRemove: () => handleRemove(todo.id),
  ))
  .toList();
```

**Why in getters, not render():**
- ✅ `render()` stays pure (only describes structure)
- ✅ Getters are recomputed automatically when state changes
- ✅ Clear separation: computation vs description
- ✅ Easier to test: `expect(app.filteredTodos.length, 3)`

#### Event Handlers

```dart
void handleAdd(Event e) {
  if (inputValue.trim().isEmpty) return;
  morph(() {
    todos.add(inputValue);
    inputValue = '';
  });
}

void handleInput(Event e) {
  final target = e.target as HTMLInputElement;
  inputValue = target.value;  // No morph - keeps focus
}

void handleEnter(Event e) {
  final keyEvent = e as KeyboardEvent;
  if (keyEvent.key == "Enter") {
    handleAdd(e);
  }
}

void handleToggle(String id) {
  morph(() => todos.toggle(id));
}

void handleRemove(String id) {
  morph(() => todos.remove(id));
}

void setFilter(Filter filter) {
  morph(() => currentFilter = filter);
}
```

**Event Handling Patterns:**

1. **handleAdd** - Validates, calls domain method, clears input
2. **handleInput** - Updates input value **without morph()** (keeps focus)
3. **handleEnter** - Keyboard event handling
4. **handleToggle/handleRemove** - Delegate to domain object
5. **setFilter** - Updates UI state

**Important:** `handleInput` does NOT use `morph()` because:
- Input value changes on every keystroke
- Calling `morph()` would re-render and lose focus
- We only need to render when adding/removing/toggling todos

#### Render Method

```dart
@override
Morphic render() {
  return Div().classes("todo-app")([
    H1()(['Todo List']),
    
    // Input section
    Div().classes("input-section")([
      Input()
        .placeholder('What needs to be done?')
        .value(inputValue)
        .onInput(handleInput)
        .onKeyDown(handleEnter)(),
      Button().onClick(handleAdd)(['Add']),
    ]),
    
    // Filters
    Div().classes("filters")([
      Button()
        .onClick((_) => setFilter(Filter.all))
        .classes(currentFilter == Filter.all ? 'active' : '')(['All']),
      Button()
        .onClick((_) => setFilter(Filter.active))
        .classes(currentFilter == Filter.active ? 'active' : '')(['Active']),
      Button()
        .onClick((_) => setFilter(Filter.completed))
        .classes(currentFilter == Filter.completed ? 'active' : '')(['Completed']),
    ]),
    
    // Todo list
    Ul().classes("todo-list")([...todoElements]),
    
    // Stats
    P()(['${todos.active.length} items left']),
  ]);
}
```

**Structure:**
1. Header with title
2. Input section (text input + add button)
3. Filter buttons (all/active/completed)
4. Todo list (spread `todoElements` getter)
5. Stats footer (active count)

**Note the spread operator:**
```dart
Ul().classes("todo-list")([...todoElements])
```

This is equivalent to:
```dart
Ul().classes("todo-list")(todoElements)
```

But using `[...todoElements]` makes it clear we're passing a list of components.

### TodoItem - Child Component

A reusable component for rendering individual todos.

```dart
final class TodoItem extends Component {
  final Todo todo;
  final void Function() onToggle;
  final void Function() onRemove;
  
  TodoItem({
    required this.todo,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Morphic render() {
    return Li().classes(todo.completed ? 'completed' : '')([
      Input()
        .type(InputType.checkbox)
        .checked(todo.completed)
        .onChange((_) => onToggle())(),
      Span()([todo.text]),
      Button().onClick((_) => onRemove())(['×']),
    ]);
  }
}
```

**Component Design:**
- ✅ Receives data via constructor (`todo`)
- ✅ Receives callbacks via constructor (`onToggle`, `onRemove`)
- ✅ Stateless - just renders what it's given
- ✅ Reusable - works with any Todo

**Parent-Child Communication:**
```dart
// Parent creates TodoItem with callbacks
TodoItem(
  todo: todo,
  onToggle: () => handleToggle(todo.id),  // Parent's method
  onRemove: () => handleRemove(todo.id),  // Parent's method
)

// Child calls callbacks
Button().onClick((_) => onRemove())  // Triggers parent's handleRemove
```

This is the **standard pattern** for component communication in Pulsar:
- Parent passes data down (via constructor)
- Child calls callbacks up (via function parameters)
- No global state, no context, no magic

---

## State Management

### The morph() Pattern

**Rule:** All state changes that should trigger re-renders must be wrapped in `morph()`.

```dart
// ✅ CORRECT - Triggers re-render
void handleAdd(Event e) {
  morph(() {
    todos.add(inputValue);
    inputValue = '';
  });
}

// ❌ WRONG - No re-render
void handleAdd(Event e) {
  todos.add(inputValue);  // UI won't update
  inputValue = '';
}
```

### The Input Exception

```dart
void handleInput(Event e) {
  final target = e.target as HTMLInputElement;
  inputValue = target.value;  // ✅ No morph - keeps input focus
}
```

**Why no morph() here:**
- Input value changes on every keystroke
- `morph()` would re-render the entire component
- Re-rendering causes the input to lose focus
- We only need to render when adding/removing todos

**Pattern:**
- Update input state **without** morph (controlled input)
- Use morph **only** when form is submitted

### State Flow

```
User types → handleInput → inputValue updated (no render)
User clicks Add → handleAdd → morph(() => todos.add(...)) → render
User clicks checkbox → handleToggle → morph(() => todos.toggle(...)) → render
User clicks filter → setFilter → morph(() => currentFilter = ...) → render
```

---

## Event Handling

### Event Handler Signatures

All event handlers receive an `Event` object:

```dart
void handleAdd(Event e) { ... }
void handleInput(Event e) { ... }
```

### Passing Handlers to Elements

**Method reference (no parameters):**
```dart
Button().onClick(handleAdd)(['Add'])
```

**Anonymous function (to pass data):**
```dart
Button().onClick((_) => setFilter(Filter.all))(['All'])
```

**Callback from child:**
```dart
TodoItem(
  todo: todo,
  onToggle: () => handleToggle(todo.id),  // Closure captures id
)
```

### Keyboard Events

```dart
void handleEnter(Event e) {
  final keyEvent = e as KeyboardEvent;
  if (keyEvent.key == "Enter") {
    handleAdd(e);
  }
}

// Usage
Input().onKeyDown(handleEnter)()
```

**Event Types:**
- `onClick` - Mouse click
- `onChange` - Input value changed
- `onInput` - Input value changing (every keystroke)
- `onKeyDown` - Key pressed

---

## Styling

### CSS File Organization

```
web/
└── components/
    └── counter/
        └── todo.css
```

### Loading Styles

```dart
@override
List<Stylesheet> get styles => [css("components/counter/todo.css")];
```

**Path is relative to `web/` directory.**

### CSS Variables

The CSS uses CSS custom properties for theming:

```css
:root {
  --bg-primary: #0f172a;
  --accent: #3b82f6;
  --text-primary: #e5e7eb;
  /* ... */
}
```

### Key CSS Classes

- `.todo-app` - Main container
- `.input-section` - Input and add button
- `.filters` - Filter buttons
- `.todo-list` - Todo items list
- `.completed` - Completed todo styling (strikethrough, opacity)
- `.active` - Active filter button

### Responsive Design

The CSS includes mobile-friendly breakpoints:

```css
@media (max-width: 640px) {
  .input-section {
    flex-direction: column;
  }
  
  .filters {
    flex-direction: column;
  }
}
```

---

## Running the App

### Prerequisites

```bash
dart pub global activate pulsar_cli
```

### Create Project

```bash
pulsar create todo_app --template empty
cd todo_app
```

### Add Code

1. Copy `TodoApp` code to `lib/main.dart`
2. Copy CSS to `web/components/counter/todo.css`
3. Update `web/main.dart`:

```dart
import 'package:pulsar_web/pulsar.dart';
import 'package:todo_app/main.dart';

void main() {
  mountApp(TodoApp());
}
```

### Run Development Server

```bash
pulsar serve
```

Open `http://localhost:8080`

### Build for Production

```bash
pulsar build
```

Output in `build/` directory.

---

## Key Concepts

### 1. Domain Oriented UI (DOU)

**Business logic lives in domain objects:**
```dart
class TodoList {  // ← Domain object, pure Dart
  void add(String text) { ... }
  void toggle(String id) { ... }
}
```

**Components coordinate:**
```dart
final class TodoApp extends Component {  // ← UI coordinator
  final TodoList todos = TodoList();  // Uses domain object
  
  void handleAdd(Event e) {
    morph(() => todos.add(inputValue));  // Delegates to domain
  }
}
```

**Benefits:**
- ✅ Test `TodoList` without rendering UI
- ✅ Reuse `TodoList` in CLI, API, other apps
- ✅ Components stay simple and focused

### 2. Components Are Objects

```dart
final class TodoItem extends Component {
  final Todo todo;  // ← Data passed via constructor
  
  TodoItem({required this.todo});  // ← Created once, reused
}
```

**Not functions:**
- Components persist across renders
- State lives in fields
- Lifecycle is explicit

### 3. Pure render()

```dart
// ❌ BAD - Computation in render
@override
Morphic render() {
  return Ul()([
    filteredTodos.map((t) => TodoItem(...)).toList(),  // ❌
  ]);
}

// ✅ GOOD - Computation in getter
List<TodoItem> get todoElements => filteredTodos
  .map((t) => TodoItem(...))
  .toList();

@override
Morphic render() {
  return Ul()([...todoElements]);  // ✅
}
```

### 4. Explicit State Updates

```dart
void handleToggle(String id) {
  morph(() => todos.toggle(id));  // ✅ Explicit
}
```

**No automatic reactivity:**
- You know when renders happen
- You can batch updates
- Debugging is straightforward

### 5. Type Safety

```dart
enum Filter { all, active, completed }  // ✅ Type-safe

Filter currentFilter = Filter.all;
setFilter(Filter.active);  // ✅ Autocomplete, refactoring
```

**Instead of:**
```dart
String currentFilter = 'all';  // ❌ Stringly-typed
setFilter('activ');  // ❌ Typo becomes runtime bug
```

### 6. Parent-Child Communication

```dart
// Parent
TodoItem(
  todo: todo,
  onToggle: () => handleToggle(todo.id),  // Pass callback
)

// Child
final void Function() onToggle;  // Receive callback
Button().onClick((_) => onToggle())  // Call callback
```

**Pattern:**
- Data flows down (props)
- Events flow up (callbacks)
- No global state needed

---

## Testing the Domain Layer

Because business logic is isolated, it's easy to test:

```dart
import 'package:test/test.dart';

void main() {
  test('TodoList adds todos correctly', () {
    final todos = TodoList();
    
    todos.add('Buy milk');
    todos.add('Walk dog');
    
    expect(todos.items.length, 2);
    expect(todos.items[0].text, 'Buy milk');
  });
  
  test('TodoList filters active todos', () {
    final todos = TodoList();
    
    todos.add('Task 1');
    todos.add('Task 2');
    todos.toggle(todos.items[0].id);
    
    expect(todos.active.length, 1);
    expect(todos.active[0].text, 'Task 2');
  });
  
  test('TodoList filters completed todos', () {
    final todos = TodoList();
    
    todos.add('Task 1');
    todos.toggle(todos.items[0].id);
    
    expect(todos.completed.length, 1);
    expect(todos.completed[0].completed, true);
  });
}
```

**No UI rendering needed** - just test the logic.

---

## Next Steps

### Extend the App

1. **Add persistence with localStorage:**

First, add JSON serialization to the `Todo` class:

```dart
import 'dart:convert';

class Todo {
  final String id;
  final String text;
  bool completed;

  Todo({required this.id, required this.text, required this.completed});

  // Required for localStorage serialization
  Map<String, dynamic> toJson() {
    return {"id": id, "text": text, "completed": completed};
  }

  // Required for localStorage deserialization
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      text: json["text"],
      completed: json["completed"],
    );
  }
}
```

Add persistence methods to `TodoList`:

```dart
class TodoList {
  List<Todo> items = [];

  void loadTodos() {
    final String? stored = window.localStorage.getItem("todos");
    
    if (stored == null) return;
    
    final decoded = jsonDecode(stored) as List;
    
    items = decoded
        .map((todo) => Todo.fromJson(todo as Map<String, dynamic>))
        .toList();
  }

  void saveTodos() {
    final json = jsonEncode(items);
    window.localStorage.setItem("todos", json);
  }

  void add(String text) {
    items.add(
      Todo(id: DateTime.now().toString(), text: text, completed: false),
    );
  }
  
  // ... rest of TodoList methods
}
```

Load todos when component is created:

```dart
final class TodoApp extends Component {
  final TodoList todos = TodoList();
  
  TodoApp() {
    todos.loadTodos();  // Load from localStorage on init
  }
  
  void handleAdd(Event e) {
    if (inputValue.trim().isEmpty) return;
    
    morph(() {
      todos.add(inputValue);
      todos.saveTodos();  // Save after adding
      inputValue = '';
    });
  }
  
  void handleToggle(String id) {
    morph(() {
      todos.toggle(id);
      todos.saveTodos();  // Save after toggling
    });
  }
  
  void handleRemove(String id) {
    morph(() {
      todos.remove(id);
      todos.saveTodos();  // Save after removing
    });
  }
}
```

**How it works:**
- ✅ `toJson()` serializes Todo to JSON
- ✅ `fromJson()` deserializes JSON to Todo
- ✅ `loadTodos()` reads from localStorage on app start
- ✅ `saveTodos()` writes to localStorage after each change
- ✅ Data persists across page refreshes

2. **Add editing:**
   ```dart
   void edit(String id, String newText) {
     final todo = items.firstWhere((t) => t.id == id);
     todo.text = newText;
   }
   ```

3. **Extract styling to domain object:**
   ```dart
   class TodoItemStyles {
     final bool completed;
     
     String get classes => completed ? 'completed' : '';
     
     static forTodo(Todo todo) => TodoItemStyles(completed: todo.completed);
   }
   ```

4. **Add bulk actions:**
   ```dart
   void clearCompleted() {
     items.removeWhere((t) => t.completed);
   }
   
   void toggleAll() {
     final allCompleted = items.every((t) => t.completed);
     for (var todo in items) {
       todo.completed = !allCompleted;
     }
   }
   ```

### Learn More

- 📖 [Pulsar Documentation](https://pulsar-web.netlify.app/docs)
- 🎯 [Domain Oriented UI Guide](https://pulsar-web.netlify.app/docs/philosophy)
- 🎨 [Styling Best Practices](https://pulsar-web.netlify.app/docs/styling)

---

## Summary

This TodoApp demonstrates:

✅ **Domain Oriented UI** - Business logic in `TodoList`, UI in `TodoApp`  
✅ **Component composition** - Reusable `TodoItem` component  
✅ **State management** - Explicit `morph()` for updates  
✅ **Event handling** - Type-safe callbacks and handlers  
✅ **Computed state** - Getters for derived data  
✅ **Type safety** - Enums for filters, strongly-typed models  
✅ **Pure render()** - Computation in getters, structure in render  

**The Pulsar way:**
- Components are objects that persist
- Business logic lives in domain objects
- State updates are explicit
- Everything is type-safe
- No magic, just code

---

**Built with clarity. Maintained with discipline. Evolved with intention.**