import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/classes/utilities.dart';
import 'package:module_provider/module_provider.dart';

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
  initController(BuildContext context, Module module) => null;

  /// Build the user interface represented by this component.
  Widget build(BuildContext context, Module module, T controller);

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
  Module module;
  T controller;

  @override
  void initState() {
    super.initState();
    
    Utilities.log('Component ${widget.runtimeType} initialized');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    this.module = (context.inheritFromWidgetOfExactType(InheritedModule) as InheritedModule).module;
    if (controller == null) {
      controller = widget.initController(context, module);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.build(context, module, controller);
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    widget.dispose();
    super.dispose();
    
    Utilities.log('Component ${this} disposed');
  }
}