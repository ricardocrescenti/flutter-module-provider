import 'package:useful_classes/useful_classes.dart';

import '../module_provider.dart';

class Inject<T> extends Disposable {
  final T Function(Module module, dynamic arg) constructor;
  Inject(this.constructor);
}