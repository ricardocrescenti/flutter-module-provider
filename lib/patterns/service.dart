import 'package:flutter/foundation.dart';
import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/module_provider.dart';

/// Class for create services providers in module
abstract class Service extends ChangeNotifier with OnDispose {
  final Module module;
  Service(this.module);

  @override
  void dispose() {
    notifyDispose();
    super.dispose();
  }
}