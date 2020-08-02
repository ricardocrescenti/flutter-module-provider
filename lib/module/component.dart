import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/util/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/widgets/future/future_await_widget.dart';
import 'package:module_provider/widgets/future/future_error_widget.dart';
import 'package:module_provider/widgets/future/future_widget.dart';
import 'package:useful_classes/useful_classes.dart';

/// The [Component] is an extension of [StatefulWidget], but simpler, it is
/// not necessary to create a [StatefulWidget] and [State] class, and usually
/// have an associated [Controller] to maintain the state of the component.
/// 
/// Basic example of [Component] implementation:
/// 
/// ```dart
/// class MyComponent extends Component {
///   @override
///   Widget build(BuildContext context, Controller controller) { 
///     return Scaffold(
///       body: Center(
///         child: Text('Basic Component');
///       )
///     );
///   }
/// }
/// ```
/// 
/// Example of implementing the [Component] with [Controller]:
/// 
/// ```dart
/// class MyController extends Controller {
///   final bodyMessage = 'Component with controller';
/// 
///   MyController(Module module) : super(module);
/// }
/// 
/// class MyComponent extends Component<MyController> {
///   @override
///   initController(BuildContext context, Module module) => MyController(module);
/// 
///   @override
///   Widget build(BuildContext context, MyController controller) { 
///     return Scaffold(
///       body: Center(
///         child: Text(controller.bodyMessage);
///       );
///     );
///   }
/// }
/// ```
abstract class Component<T extends Controller> extends StatefulWidget with OnDispose {

  /// Controller initializer.
  /// 
  /// If the initialization is not overwritten in the component that extended
  /// the [Component], it will create a basic controller obtain the component
  /// parent module.
  /// 
  /// This method is called only once before the component `initialize` mehtod.
  /// 
  /// Example of controller initializer implementation:
  /// 
  /// ```dart
  /// @override
  /// initController(BuildContext context, Module module) => MyController(module);
  /// ```
  initController(BuildContext context, Module module) => Controller(module);

  /// Component initializer.
  /// 
  /// This method can be used to initialize something needed for your component.
  /// 
  /// If you need to wait for something asynchronous, add `async` to the method,
  /// the component will show loading until the future method will be completed. 
  /// You can modify the loading of the component by overriding the 
  /// [buildFutureAwaitWidget] method.
  /// 
  /// This method is called only once at component startup, after controller 
  /// initialization
  @mustCallSuper
  initialize(BuildContext context, T controller) {
    return controller.initialize(context);
  }

  /// Create the component load widget.
  /// 
  /// This method is only used if the [initialize] method is asynchronous.
  /// 
  /// By default it will return the following widget:
  /// 
  /// ```
  /// return Scaffold(
  ///   body: Center(
  ///     child: Column(
  ///       mainAxisSize: MainAxisSize.max,
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       crossAxisAlignment: CrossAxisAlignment.center,
  ///       children: <Widget>[
  ///         CircularProgressIndicator()
  ///       ]
  ///     )
  ///   )
  /// );
  /// ```
  Widget buildFutureAwaitWidget(BuildContext context) {
    return const FutureAwaitWidget();
  }
  
  /// Create the component load error widget.
  /// 
  /// This method is only used if the [initialize] method is asynchronous and
  /// 
  /// By default it will return the following widget:
  /// 
  /// ```
  /// return Scaffold(
  ///   body: Center(
  ///     child: Column(
  ///       mainAxisSize: MainAxisSize.max,
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       crossAxisAlignment: CrossAxisAlignment.center,
  ///       children: <Widget>[
  ///         Icon(Icons.error, size: 70)
  ///       ]
  ///     )
  ///   )
  /// );
  /// ```
  Widget buildFutureErrorWidget(BuildContext context, Object error) {
    return const FutureErrorWidget();
  }

  /// Build the user interface represented by this component.
  Widget build(BuildContext context, T controller);

  @override
  State<StatefulWidget> createState() => _ComponentWidget<T>();

  /// Dispose component when this object is permanently removed from the tree. The 
  /// [Controller] associated with this component will also be discarded.
  @mustCallSuper
  dispose() {
    
    // notify listeners with dispose of this object
    notifyDispose();
  }
}

/// Class to maintain `Component` state
class _ComponentWidget<T extends Controller> extends State<Component> {

  /// Indicate whether the component has already been initialized
  bool _initialized = false;


  /// Reference of the [Future] reference used to initialize the component if
  /// the [Component.initialize] method is asynchronous.
  Future _futureInitialize;

  /// Component parent module
  Module module;

  /// Controller of the component returned by the method [Component.initController]
  T controller;

  @override
  void initState() {
    super.initState();
    
    logger.log('Component ${this.widget.runtimeType} initialized');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // get parent module
    this.module = context.dependOnInheritedWidgetOfExactType<InheritedModule>().module;

    // initialize controller
    if (controller == null) {
      controller = widget.initController(context, module);
    }
    
    // call the component initialization method
    if (!_initialized) {
      _initialized = true;
      _futureInitialize = widget.initialize(context, controller) as Future;
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
    
    // dispose controller
    if (controller != null) {
      controller.dispose();
    }

    // dispose widget
    widget.dispose();

    super.dispose();

    logger.log('Component ${this.widget.runtimeType} disposed');
  }
}