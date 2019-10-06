import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/module_provider.dart';

class Inject<T> extends OnDispose {
  final T Function(Module module, dynamic arg) constructor;
  Inject(this.constructor);
}