import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/classes/inject_manager.dart';
import 'package:module_provider/classes/utilities.dart';
import 'package:module_provider/module_provider.dart';

Map<Type, ModuleState> _modules = {};

/// Widget for implement modules in your app
abstract class Module extends StatefulWidget with OnDispose {

  List<Inject<Service>> get services => [];
  T service<T extends Service>({dynamic arg}) => _getService<T>(arg);

  List<Inject<Module>> get modules => [];
  T module<T extends Module>({dynamic arg}) => _getModule<T>(arg);

  List<Inject<Component>> get components => [];
  T component<T extends Component>({dynamic arg}) => _getComponent<T>(arg);

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => ModuleState();

  @mustCallSuper
  dispose() {
    notifyDispose();
  }
  
  _getService<T extends Service>(dynamic arg) {
    ModuleState module = _modules[this.runtimeType];
    return module._servicesInstances.getInstance<T>(this, arg, services, 
      nullInstance: (module.parentModule != null ? () => module.parentModule.service<T>(arg: arg): null));
  }
  _getModule<T extends Module>(dynamic arg) {
    ModuleState module = _modules[this.runtimeType];
    return module._modulesInstances.getInstance<T>(this, arg, modules, 
      nullInstance: (module.parentModule != null ? () => module.parentModule.module<T>(arg: arg): null));
  }
  _getComponent<T extends Component>(dynamic arg) {
    ModuleState module = _modules[this.runtimeType];
    return module._componentsInstances.getInstance<T>(this, arg, components,
      nullInstance: (module.parentModule != null ? () => module.parentModule.component<T>(arg: arg): null));
  }

  static T of<T extends Module>() {
    ModuleState module = _modules[T];
    if (module != null) {
      return module.widget;
    }
    throw Exception('Undeclared module');
  }
}

class ModuleState extends State<Module> {
  Module parentModule;
  final InjectManager<Service> _servicesInstances = InjectManager<Service>();
  final InjectManager<Module> _modulesInstances = InjectManager<Module>();
  final InjectManager<Component> _componentsInstances = InjectManager<Component>(standalone: false);

  @override
  void initState() {
    super.initState();
    _registerModule();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    InheritedModule inheritedModule = (context.inheritFromWidgetOfExactType(InheritedModule) as InheritedModule);
    if (inheritedModule != null) {
      this.parentModule = inheritedModule.module;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedModule(
      module: this.widget,
      child: widget.build(context));
  }

  @override
  void dispose() {
    widget.dispose();
    _modulesInstances.dispose((module) => module.dispose());
    _servicesInstances..dispose((service) => service.dispose());
    _unregisterModule();
    super.dispose();
    
    Utilities.log('Module ${this.runtimeType} disposed');
  }

  _registerModule() {
    if (_modules.containsKey(this.runtimeType)) {
      throw Exception('The module ${this.runtimeType} is already registered.');
    }
    _modules[this.widget.runtimeType] = this;
    Utilities.log('Module ${this.runtimeType} registered');
  }
  _unregisterModule() {
    _modules.remove(this.runtimeType);
    Utilities.log('Module ${this.runtimeType} unregistered');
  }
  
}