import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/classes/inject_manager.dart';
import 'package:module_provider/util/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/widgets/future/future_await_widget.dart';
import 'package:module_provider/widgets/future/future_error_widget.dart';
import 'package:module_provider/widgets/future/future_widget.dart';
import 'package:useful_classes/useful_classes.dart';

/// 
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
///     Inject((m) => AppService(m)),
///     Inject((m) => DataService(m)),
///   ];
/// 
///   @override
///   List<Inject<Component>> get components => [
///     Inject((m) => HomeComponent()),
///     Inject((m) => TaskListComponent()),
///     Inject((m) => AddEditTaskComponent()),
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
  ///   Inject((m) => AppService(m)),
  ///   Inject((m) => DataService(m)),
  /// ];
  /// ```
  List<Inject<Service>> get services => [];
  
  /// Load the routes to use in this module
  List<RouterPattern> get routes => null;

  /// Initialize something at startup of `Module`, this method id called only 
  /// once when this module is inicialized, before call `build()` method.
  initialize(BuildContext context) {}

  /// 
  T service<T extends Service>() {
    ModuleState module = _modules[this.runtimeType];
    return module._servicesInstances.getInstance<T>(this, services, 
      nullInstance: (module.parentModule != null ? () => module.parentModule.service<T>(): null));
  }
  
  /// 
  Widget buildFutureAwaitWidget(BuildContext context) {
    return FutureAwaitWidget();
  }
  
  /// 
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
  
  /// 
  static T of<T extends Module>() {
    ModuleState module = _modules[T];
    if (module != null) {
      return module.widget;
    }
    throw Exception('Undeclared module');
  }

  /// 
  static get onGenerateRoute => _modules[_modules.keys.elementAt(0)].onGenerateRoute;

}

/// Class to maintain `Module` state
class ModuleState extends State<Module> with RouterImplementation {
  bool _isRootModule = false;
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

    if (_modules.keys.elementAt(0) == this.widget.runtimeType) {
      _isRootModule = true;
    }

    if (widget.routes != null || !_isRootModule) {

      if (!_isRootModule && !this.widget.routes.any((route) => route.name.isEmpty || route.name == '/')) {
        routes['/'] = Router('/', builder: widget.build);
      }

      loadRoutes(widget.routes, parentUrl: '/');
      
    }
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
      _futureInitialize = widget.initialize(context) as Future;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedModule(
      module: this.widget,
      child: FutureWidget<void>(
        future: (context) => this._futureInitialize,
        awaitWidget: this.widget.buildFutureAwaitWidget,
        errorWidget: this.widget.buildFutureErrorWidget,
        builder: (context, result) {

          final Widget widget = this.widget.build(context);

          if (this._isRootModule) {

            if (widget == null) {
              throw Exception('The "build" method was not implemented in ${this.widget.runtimeType}, for root modules or without routes, it is required');
            }
            return widget;

          } else {
            
            return navigador;

          }

          //return widget.build(context);

        }
      ),
    );
  }

  @override
  void dispose() {
    widget.dispose();
    _modulesInstances.dispose((module) => module.dispose());
    _servicesInstances.dispose((service) => service.dispose());
    _unregisterModule();
    super.dispose();
    
    logger.log('Module ${this.widget.runtimeType} disposed');
  }

  _registerModule() {
    if (_modules.containsKey(this.runtimeType)) {
      throw Exception('The module ${this.widget.runtimeType} ${this._isRootModule ? '(root) ' : ''}is already registered.');
    }
    _modules[this.widget.runtimeType] = this;
    logger.log('Module ${this.widget.runtimeType} ${this._isRootModule ? '(root) ' : ''}registered');
  }
  _unregisterModule() {
    _modules.remove(this.runtimeType);
    logger.log('Module ${this.widget.runtimeType} ${this._isRootModule ? '(root) ' : ''}unregistered');
  }
}