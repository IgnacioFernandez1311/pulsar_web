import 'package:pulsar_web/pulsar.dart';
import 'dart:convert';

// Domain object for todo logic
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
    print(json);
  }

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

// Main app component
final class TodoApp extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/todo.css")];

  final TodoList todos = TodoList();
  String inputValue = '';
  Filter currentFilter = Filter.all;

  // Computed state
  List<Todo> get filteredTodos {
    return switch (currentFilter) {
      Filter.all => todos.items,
      Filter.active => todos.active,
      Filter.completed => todos.completed,
    };
  }

  // OPCIÓN 1: List<TodoItem> + spread
  List<TodoItem> get todoElements => filteredTodos
      .map(
        (todo) => TodoItem(
          todo: todo,
          onToggle: () => handleToggle(todo.id),
          onRemove: () => handleRemove(todo.id),
        ),
      )
      .toList();

  TodoApp() {
    todos.loadTodos();
  }

  // Actions
  void handleAdd(Event e) {
    if (inputValue.trim().isEmpty) return;

    morph(() {
      todos.add(inputValue);
      todos.saveTodos();
      inputValue = '';
    });
  }

  void handleInput(Event e) {
    final target = e.target as HTMLInputElement;
    inputValue = target.value;
  }

  void handleEnter(Event e) {
    String lastKey = "";

    final keyEvent = e as KeyboardEvent;

    if (keyEvent.key == "Enter") {
      lastKey = "Enter";
      print(lastKey);
      handleAdd(e);
    }
  }

  void handleToggle(String id) {
    morph(() {
      todos.toggle(id);
      todos.saveTodos();
    });
  }

  void handleRemove(String id) {
    morph(() {
      todos.remove(id);
      todos.saveTodos();
    });
  }

  void setFilter(Filter filter) {
    morph(() => currentFilter = filter);
  }

  @override
  Morphic render() {
    return Div().classes("todo-app")([
      H1()(['Todo List']),

      // Input
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
            .classes(currentFilter == Filter.active ? 'active' : '')([
          'Active',
        ]),
        Button()
            .onClick((_) => setFilter(Filter.completed))
            .classes(currentFilter == Filter.completed ? 'active' : '')([
          'Completed',
        ]),
      ]),

      // Todo list
      Ul().classes("todo-list")([todoElements]),

      // Stats
      P()(['${todos.active.length} items left']),
    ]);
  }
}

// Child component
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

enum Filter { all, active, completed }

class Todo {
  final String id;
  final String text;
  bool completed;

  Todo({required this.id, required this.text, required this.completed});

  Map<String, dynamic> toJson() {
    return {"id": id, "text": text, "completed": completed};
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      text: json["text"],
      completed: json["completed"],
    );
  }
}

/*

final class Counter extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/counter_app.css")];

  int count = 0;

  void increment(Event event) => morph(() => count++);
  void decrement(Event event) => morph(() => count--);

  @override
  Morphic render() {
    return Div()([
      H1()(["Welcome to Pulsar Web"]),
      Img().src("/assets/Logo.png").width(180)(),
      Hr()(),
      H2()([count]),
      Div().classes("buttons")([
        Button().onClick(decrement).classes("button-circular")(['-']),
        Button().onClick(increment).classes("button-circular")(["+"]),
      ]),
    ]);
  }
}

*/

/*
class CounterApp extends Component {
  @override
  List<Stylesheet> get styles => [css("components/counter/counter_app.css")];

  int count = 0;

  void increment(Event event) => setState(() => count++);

  void decrement(Event event) => setState(() => count--);

  @override
  PulsarNode render() {
    return div(
      children: <PulsarNode>[
        h1(children: [text("Welcome to Pulsar Web")]),
        img(src: "assets/Logo.png", width: 180),
        hr(),
        h2(children: [text("\$count")]),
        div(
          classes: "buttons",
          children: <PulsarNode>[
            button(
              classes: "button-circular",
              onClick: decrement,
              children: <PulsarNode>[text('-')],
            ),
            button(
              classes: "button-circular",
              onClick: increment,
              children: <PulsarNode>[text("+")],
            ),
          ],
        ),
      ],
    );
  }
}
*/
