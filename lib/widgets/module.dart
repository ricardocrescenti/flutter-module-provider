import 'package:flutter/material.dart';
import 'package:module_provider/classes/disposable.dart';
import 'package:module_provider/classes/inject_manager.dart';
import 'package:module_provider/module_provider.dart';

/// Widget for implement modules in your app
abstract class Module extends StatefulWidget with Disposable {
  final Module parentModule;

  final InjectManager<Service> _servicessInstances = InjectManager<Service>();
  List<Inject<Service>> get services => []; 
  T service<T extends Service>({dynamic arg}) => _servicessInstances.getInstance<T>(this, arg, services, 
    nullInstance: (parentModule != null ? () => parentModule.service<T>(arg: arg): null));

  final InjectManager<Module> _modulesInstances = InjectManager<Module>();
  List<Inject<Module>> get modules => [];
  T module<T extends Module>({dynamic arg}) => _modulesInstances.getInstance<T>(this, arg, modules, 
    nullInstance: (parentModule != null ? () => parentModule.module<T>(arg: arg): null));

  final InjectManager<Component> _componentsInstances = InjectManager<Component>(standalone: false);
  List<Inject<Component>> get components => [];
  T component<T extends Component>({dynamic arg}) => _componentsInstances.getInstance<T>(this, arg, components,
    nullInstance: (parentModule != null ? () => parentModule.component<T>(arg: arg): null));

  Module(this.parentModule);

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    _modules.putIfAbsent(this.runtimeType, () => this);
    return _Module();
  }

  @override
  dispose() {
    _componentsInstances.dispose();
    _modulesInstances.dispose();
    _servicessInstances..dispose();
    _unregisterModule();
    super.dispose();
  }

  _unregisterModule() {
    _modules.remove(this.runtimeType);
  }
  

  static Map<Type, Module> _modules = {};
  static T of<T extends Module>() {
    Module module = _modules[T];
    if (module != null) {
      return module;
    }
    throw Exception('Undeclared module');
  }
}

class _Module extends State<Module> {
  Widget createdWidget;

  @override
  Widget build(BuildContext context) {
    if (createdWidget == null) {
      createdWidget = widget.build(context);
    }
    return createdWidget;
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}