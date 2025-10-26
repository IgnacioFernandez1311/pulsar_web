import 'renderable.dart';

abstract class View extends Renderable {
  @override
  List<Renderable Function()> get imports => [];

  void onInit() {}
}