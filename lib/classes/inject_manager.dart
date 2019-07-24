import 'package:useful_classes/useful_classes.dart';

import '../module_provider.dart';

/// Class for manage instances in module
class InjectManager<T extends Disposable> extends Disposable {
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
      Inject inject = constructors.firstWhere((item) => item.constructor is P Function(Module module, List<dynamic> args)); 
      if (inject != null) {
        instance = inject.constructor(module, args);
        print('++++++++++ Created instance $instance from $module.');
        if (standalone) {
          instance.onDispose.listen((_) {
            print('---------- Removing instance $instance from $module.');
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

  @override
  dispose() {
    _instances.forEach((instance) {
      instance.dispose();
    });
    _instances.clear();
    super.dispose();
  }
}