import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/module_provider.dart';

/// Class for manage instances in module
class InjectManager<T extends OnDispose> {
  final bool standalone;
  InjectManager({this.standalone = true});

  List<T> _instances = [];

  T getInstance<P extends T>(Module module, dynamic args, List<Inject<T>> constructors, {T Function() nullInstance}) {
    T instance;

    _instances.forEach((item) {
      if (item is P) {
        instance = item;
      }
    });

    if (instance == null && constructors != null && constructors.length > 0) {
      Inject inject = constructors.firstWhere((item) => item.constructor is P Function(Module module, List<dynamic> args), orElse: () => null); 
      if (inject != null) {
        instance = inject.constructor(module, args);
        if (standalone) {
          instance.onDispose.listen((_) {
            _instances.remove(instance);
          });
          _instances.add(instance);
        }
      }
    }

    if (instance == null && nullInstance != null) {
      instance = nullInstance();
    }

    if (instance == null) {
      throw Exception('Undeclared $T in module $module.');
    }
    
    return instance;
  }

  dispose(Function (T instance) instanceDispose) {
    _instances.forEach((instance) {
      instanceDispose(instance);
      instance.notifyDispose();
    });
    _instances.clear();
  }
}