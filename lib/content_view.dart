import 'view.dart';

abstract class ContentView extends View {
  @override
  Future<String> get template;
}