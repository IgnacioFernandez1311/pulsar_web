## 0.4.3
- New README.

## 0.4.2
- README rewrite.

## 0.4.1
- Added several HTML DOM event on tags like onClick, onDoubleClick, onFocus, onSubmit, etc. attrs map is still available for edge case attributes.
- Added data map for data attributes.
- Added BooleanAttribute for bool attributes values.

## 0.4.0
- Core rewrite - stable NodeTree architecture.

## 0.3.1
- Quick fix for double state execution on first interaction.

## 0.3.0
- New functionallity and syntax for prop parsing, `<ComponentName prop="literalValue" otherprop="{{dynamicValue}}"/>`.
- Added `state.statename`, `prop.propname` and `trigger.triggerName` for props and states usage via noSuchMethod.
- `props` map is no longer needed.
- `methodRegistry` map is no longer needed.


## 0.2.1
- Changed Syntax for the inserts from `{% insert "ComponentName" %}` to `<ComponentName />`.
- Changed the syntax for the ContentView slot from `{% content %}` to `<@View />`.
- Changed the way to import Renderable elements into imports property-
- Changed the way to define routes.

## 0.2.0
- Removed the `Registry` class and `Provider` class because they are no longer needed.
- Classes hierarchy restructured to add the parent class `Renderable`. Now `Component` and `View` extends from `Renderable`.
- Added View super class with LayoutView and `ContentView` as children.
- Function `runApp()` modified. It no longer receives a `List<Component>` but a single `View`. Removed componentProvider because is no longer needed.
- Added LayoutView, a class to handle the Layout for the views that needs persistante UI as a Navbar or a Footer.
- Added `ContentView`, a class to handle a view that can be a main view or contained as the content of a `LayoutView`. It can be used as the main view in the `runApp()` function.
- Added Routing system for LayoutViews. The class `Router` can define all the possible routes for the Layout.


## 0.1.4
- Fix for the components styleId escape characters.

## 0.1.3
- Added universal_web instead of web package.
- Added the disclaimer at the begining of the README file.
- Added an example for better documentation.

## 0.1.2
- Added support for `pulsar_cli`.

## 0.1.1
- Added documentation to the classes and methods for a better understanding.

## 0.1.0
- Added Provider for components and template inserts for reactive components.

## 0.0.2

- Initial version.
