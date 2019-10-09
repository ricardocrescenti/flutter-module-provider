import 'package:flutter/material.dart';
import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/patterns/inherited_module.dart';

/// Widget for implement components in your app module
abstract class Component<T extends Controller> extends StatefulWidget with OnDispose {
  initController(Module module) => null;

  Widget build(BuildContext context, Module module, T controller);

  @override
  State<StatefulWidget> createState() => _ComponentWidget<T>();

  @mustCallSuper
  dispose() {
    notifyDispose();
  }
}

class _ComponentWidget<T extends Controller> extends State<Component> {
  Module module;
  T controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    this.module = (context.inheritFromWidgetOfExactType(InheritedModule) as InheritedModule).module;
    if (controller == null) {
      controller = widget.initController(module);
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
  }
}