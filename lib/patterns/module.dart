import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/classes/inject_manager.dart';
import 'package:module_provider/classes/utilities.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/widgets/future/future_await_widget.dart';
import 'package:module_provider/widgets/future/future_error_widget.dart';
import 'package:module_provider/widgets/future/future_widget.dart';

Map<Type, ModuleState> _modules = {};

/// The `Module` contains the basic structure with services, submodules, and 
/// components, keeping services instances. When the module is disposed, all
/// services are also disposed.
/// 
/// In the example below, I created the module structure, with `Services` and
/// `Components`, and in the `build` method, `HomeComponent` is returned for 
/// display on the screen.
/// 
/// ```dart
/// import 'package:flutter/material.dart';
/// 
/// class AppModule extends Module {
///   @override
///   List<Inject<Service>> get services => [
///     Inject((m, arg) => AppService(m)),
///     Inject((m, arg) => DataService(m)),
///   ];
/// 
///   @override
///   List<Inject<Component>> get components => [
///     Inject((m, arg) => HomeComponent()),
///     Inject((m, arg) => TaskListComponent()),
///     Inject((m, arg) => AddEditTaskComponent()),
///   ];
/// 
///   @override
///   Widget build(BuildContext context) => component<HomeComponent>();
/// }
/// ```
abstract class Module extends StatefulWidget with OnDispose {

  /// List of `Service` that your module will provide for all objects that are
  /// built on this module or the widgets tree. He is created and maintained 
  /// in memory until module be disposed.
  /// 
  /// ```dart
  /// @override
  /// List<Inject<Service>> get services => [
  ///   Inject((m, arg) => AppService(m)),
  ///   Inject((m, arg) => DataService(m)),
  /// ];
  /// ```
  List<Inject<Service>> get services => [];

  /// Load the requested `Service`, if the service is not available in the
  /// current module, an attempt will be made to load this service from the
  /// parent module.
  T service<T extends Service>({dynamic arg}) => _getService<T>(arg);

  /// List of `Module` that can be loaded into your module, should be used
  /// when you need to load another module structure with a service and
  /// component structure.
  /// 
  /// ```dart
  /// @override
  /// List<Inject<Module>> get modules => [
  ///   Inject((m, arg) => RegistrarionModule(m)),
  ///   Inject((m, arg) => PaymentModule(m)),
  /// ];
  /// ```
  List<Inject<Module>> get modules => [];

  /// Load the requested `Module`, if the module is not available in the
  /// current module, an attempt will be made to load this module from the
  /// parent module.
  T module<T extends Module>({dynamic arg}) => _getModule<T>(arg);
  
  /// Initialize something at startup of `Module`, this method id called only 
  /// once when this module is inicialized, before call `build()` method.
  initialize(BuildContext context) {}

  /// Initialize something at startup of `Module`, this method id called only 
  /// once when this module is inicialized, before call `build()` method.
  Future futureInitialize(BuildContext context) => null;

  Widget buildFutureAwaitWidget(BuildContext context) {
    return FutureAwaitWidget();
  }
  
  Widget buildFutureErrorWidget(BuildContext context, Object error) {
    return FutureErrorWidget();
  }

  /// Build the user interface represented by this module.
  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => ModuleState();

  /// Called when this object is permanently removed from the tree. All services 
  /// loaded in memory will be disposed.
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

  static T of<T extends Module>() {
    ModuleState module = _modules[T];
    if (module != null) {
      return module.widget;
    }
    throw Exception('Undeclared module');
  }
}

/// Class to maintain `Module` state
class ModuleState extends State<Module> {
  bool _initialized = false;
  Future<void> _futureInitialize;

  Module _parentModule;
  Module get parentModule => _parentModule;

  final InjectManager<Service> _servicesInstances = InjectManager<Service>();
  final InjectManager<Module> _modulesInstances = InjectManager<Module>(standalone: false);

  @override
  void initState() {
    super.initState();
    _registerModule();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    InheritedModule inheritedModule = context.dependOnInheritedWidgetOfExactType<InheritedModule>();
    if (inheritedModule != null) {
      this._parentModule = inheritedModule.module;
    }

    if (!_initialized) {
      _initialized = true;
      widget.initialize(context);
      _futureInitialize = widget.futureInitialize(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedModule(
      module: this.widget,
      child: FutureWidget<void>(
        future: (context) => this._futureInitialize,
        awaitWidget: widget.buildFutureAwaitWidget,
        errorWidget: widget.buildFutureErrorWidget,
        builder: (context, result) => widget.build(context)
      ),
    );
  }

  @override
  void dispose() {
    widget.dispose();
    _modulesInstances.dispose((module) => module.dispose());
    _servicesInstances..dispose((service) => service.dispose());
    _unregisterModule();
    super.dispose();
    
    Utilities.log('Module ${this.widget.runtimeType} disposed');
  }

  _registerModule() {
    if (_modules.containsKey(this.runtimeType)) {
      throw Exception('The module ${this.widget.runtimeType} is already registered.');
    }
    _modules[this.widget.runtimeType] = this;
    Utilities.log('Module ${this.widget.runtimeType} registered');
  }
  _unregisterModule() {
    _modules.remove(this.runtimeType);
    Utilities.log('Module ${this.widget.runtimeType} unregistered');
  }
  
}