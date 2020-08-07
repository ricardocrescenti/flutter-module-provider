import 'package:module_provider/module_provider.dart';

class ChildService extends Service {
  ChildService(Module module) : super(module);

  @override
  void dispose() {
    print('############ ChildService disposed');
    super.dispose();
  }
}