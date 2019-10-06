import 'package:module_provider/classes/disposable.dart';
import 'package:module_provider/module_provider.dart';
import 'package:scoped_model/scoped_model.dart';

/// Class for create services providers in module
abstract class Service extends Model with Disposable {
  final Module module;

  Service(this.module);

  @override
  dispose() {
    super.dispose();
  }

}