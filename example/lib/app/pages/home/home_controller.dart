import 'package:module_provider/module_provider.dart';

class HomeController extends Controller {
  final ValueProvider<int> counter = ValueProvider(initialValue: 0);

  HomeController(Module module) : super(module);

  increment() {
    counter.value++;
  }
}