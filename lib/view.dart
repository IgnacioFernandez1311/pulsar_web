import 'renderable.dart';

abstract class View extends Renderable {
  @override
  List<Renderable> get imports => [];

  void onInit() {}
}