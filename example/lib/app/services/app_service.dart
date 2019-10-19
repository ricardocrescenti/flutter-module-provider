import 'package:module_provider/module_provider.dart';

class AppService extends Service {
  bool _darkMode = false;
  bool get darkMode => _darkMode;

  AppService(Module module) : super(module);

  changeDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}