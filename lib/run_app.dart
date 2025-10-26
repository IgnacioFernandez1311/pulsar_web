import 'package:pulsar_web/pulsar.dart';
import 'package:universal_web/web.dart';
/// Main function to run the List of Components to append to the body and it is also useful to pass it the current Component Provider to register the Components we want to insert in the templates of other Components.
void runApp(View view) {
  document.body?.append(view.build());
}