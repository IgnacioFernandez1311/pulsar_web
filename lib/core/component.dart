// lib/core/component.dart

import 'package:pulsar_web/engine/morphic/morphic.dart';
import 'package:pulsar_web/engine/runtime/component_runtime.dart';
import 'package:pulsar_web/engine/stylesheet/stylesheet.dart';
import 'package:pulsar_web/engine/renderer/render_context.dart';

/// Base class for all Pulsar components.
///
/// A [Component] is a **long-lived object with identity** — it is never
/// recreated on re-render. Instead, it morphs its output in-place when
/// state changes via [morph].
///
/// ## Lifecycle
///
/// 1. Instantiate the component and store it as a **field** (never inline).
/// 2. The runtime calls [attach] once when the component is mounted.
/// 3. State changes are driven by [morph], which runs an updater function
///    and triggers a granular DOM reconciliation scoped to this component.
/// 4. [detach] is called when the component is removed from the tree.
///
/// ## Rules
///
/// - [render] **must be pure**: no side effects, no lazy iteration inside it.
///   Compute derived data in getters and reference those getters from [render].
/// - Components must be stored as **fields**, not created inline, so that
///   identity and state are preserved across re-renders.
///
/// ## Example
///
/// ```dart
/// final class Counter extends Component {
///   int count = 0;
///
///   void increment(Event _) => morph(() => count++);
///   void decrement(Event _) => morph(() => count--);
///
///   @override
///   Morphic render() {
///     return Div()([
///       H2()([count]),
///       Button().onClick(decrement)(['-']),
///       Button().onClick(increment)(['+']),
///     ]);
///   }
/// }
/// ```
abstract base class Component {
  ComponentRuntime? _runtime;
  bool attached = false;

  ComponentRuntime get runtime {
    final contextComponent = RenderContext.currentComponent;
    if (contextComponent == this) {
      return RenderContext.runtime;
    }

    final r = _runtime;
    if (r == null) {
      throw StateError('Component is not mounted');
    }
    return r;
  }

  ComponentRuntime? get componentRuntime => _runtime;

  List<Stylesheet> get styles => const [];

  void attach(ComponentRuntime runtime) {
    if (attached) {
      if (_runtime != runtime) {
        throw StateError('Component already attached to different runtime');
      }
      return;
    }

    attached = true;
    _runtime = runtime;

    for (final style in styles) {
      runtime.styles.use(style);
    }
  }

  void detach() {
    if (!attached) return;

    // Unregister from the runtime so its DOM node and tree snapshot
    // are released. This prevents stale diffs on components that have
    // been removed from the tree.
    _runtime?.unregisterComponent(this);

    attached = false;
    _runtime = null;
  }

  void onMorph() {}

  void morph(void Function() updater) {
    updater();
    update();
  }

  void update() {
    if (!attached) {
      throw StateError(
        'Cannot update: component is not mounted. '
        'Make sure component is stored as field, not created inline.',
      );
    }
    // Granular update: only this component's subtree is re-rendered and
    // diffed. No other component or DOM node is touched.
    runtime.requestUpdateFor(this);
  }

  /// Produces the Morphic tree for this component's current state.
  ///
  /// **Must be pure.** Do not call [morph] or mutate state inside [render].
  /// Do not use `.map()`, `.where()`, or `.fold()` directly in [render] —
  /// move those to getters instead:
  ///
  /// ```dart
  /// // ✅ correct — computed in a getter
  /// List<Morphic> get todoElements => filteredTodos.map(...).toList();
  ///
  /// @override
  /// Morphic render() => Ul()([todoElements]);
  ///
  /// // ❌ wrong — lazy iteration inside render
  /// @override
  /// Morphic render() => Ul()([ todos.map((t) => TodoItem(todo: t)) ]);
  /// ```
  Morphic render();
}
