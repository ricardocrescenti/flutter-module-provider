import 'package:module_provider/module_provider.dart';

class CounterController extends Controller {
  final ValueProvider<int> counter = ValueProvider(initialValue: 0);

  CounterController(Module module) : super(module);

  increment() {
    counter.value++;
  }
}