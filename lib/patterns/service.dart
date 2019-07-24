import 'package:useful_classes/useful_classes.dart';

import '../module_provider.dart';

/// Class for create services providers in module
abstract class Service with Disposable {
  final Module module;

  Service(this.module);

  @override
  dispose() {
    super.dispose();
  }

}