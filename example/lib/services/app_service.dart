import 'package:module_provider/module_provider.dart';

class AppService extends Service {
  ValueProvider<bool> darkMode = ValueProvider(initialValue: true);

  AppService(Module module) : super(module);

  changeDarkMode() {
    darkMode.value = !darkMode.value;
  }
}