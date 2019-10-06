import 'package:module_provider/classes/disposable.dart';
import 'package:module_provider/module_provider.dart';

class Inject<T> extends Disposable {
  final T Function(Module module, dynamic arg) constructor;
  Inject(this.constructor);
}