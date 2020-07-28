import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/classes/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/widgets/future/future_await_widget.dart';
import 'package:module_provider/widgets/future/future_error_widget.dart';
import 'package:module_provider/widgets/future/future_widget.dart';
import 'package:useful_classes/useful_classes.dart';

/// The `Components` are extended `StatefulWidget` widgets, but simpler, it is
/// not necessary to create a` StatefulWidget` and `State` class, and usually
/// have an associated `Controller` to maintain the state of the component.
/// 
/// In this example it was declared the variable of type `ValueProvider<int>`
/// which will be incremented on calling the `increment()` method, and in the
/// component will be used `ValueConsumer` so that when there is a modification
/// the layout will be updated.
/// 
/// ```dart
/// class HomeComponent extends Component<HomeController> {
///   @override
///   initController(BuildContext context, Module module) => HomeController(module);
/// 
///   @override
///   Widget build(BuildContext context, Module module, HomeController controller) { 
///     /// return Scaffold(....
///   }
/// }
/// ```
abstract class Component<T extends Controller> extends StatefulWidget with OnDispose {
  /// Controller Initializer
  initController(BuildContext context, Module module) => Controller(module);

  /// Initialize something at startup of `Component`, this method id called only 
  /// once when this component is inicialized, before call `build()` method.
  @mustCallSuper
  initialize(BuildContext context, T controller) {
    if (controller != null) {
      controller.initialize(context);
    }
  }

  /// Initialize something at startup of `Component`, this method id called only 
  /// once when this component is inicialized, before call `build()` method.
  @mustCallSuper
  Future futureInitialize(BuildContext context, T controller) {
    if (controller != null) {
      Future futureControllerInitialize = controller.futureInitialize(context);
      if (futureControllerInitialize != null) {
        return futureControllerInitialize;
      }
    }
    return null;
  }

  /// 
  Widget buildFutureAwaitWidget(BuildContext context) {
    return FutureAwaitWidget();
  }
  
  /// 
  Widget buildFutureErrorWidget(BuildContext context, Object error) {
    return FutureErrorWidget();
  }

  /// Build the user interface represented by this component.
  Widget build(BuildContext context, T controller);

  @override
  State<StatefulWidget> createState() => _ComponentWidget<T>();

  /// Called when this object is permanently removed from the tree. The 
  /// `Controller` associated with this component will also be discarded.
  @mustCallSuper
  dispose() {
    notifyDispose();
  }
}

/// Class to maintain `Component` state
class _ComponentWidget<T extends Controller> extends State<Component> {
  bool _initialized = false;
  Future _futureInitialize;

  Module module;
  T controller;

  @override
  void initState() {
    super.initState();
    
    logger.log('Component ${this.widget.runtimeType} initialized');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    this.module = context.dependOnInheritedWidgetOfExactType<InheritedModule>().module;
    if (controller == null) {
      controller = widget.initController(context, module);
    }
    
    if (!_initialized) {
      _initialized = true;
      widget.initialize(context, controller);
      _futureInitialize = widget.futureInitialize(context, controller);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureWidget<void>(
      future: (context) => this._futureInitialize,
      awaitWidget: widget.buildFutureAwaitWidget,
      errorWidget: widget.buildFutureErrorWidget,
      builder: (context, result) => widget.build(context, controller),
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    widget.dispose();
    super.dispose();
    
    logger.log('Component ${this.widget.runtimeType} disposed');
  }
}