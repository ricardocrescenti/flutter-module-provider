import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// Widget for implement components in your app module
abstract class Component<T extends Controller> extends StatefulWidget with Disposable {
  final Module module;
  Component(this.module);

  T Function(Module module) get initController => null;

  Widget build(BuildContext context, T controller);

  @override
  State<StatefulWidget> createState() => _ComponentWidget<T>();

  @override
  dispose() {
    print('>>>>>>>>>> $this.dispose (widget)');
    super.dispose();
  }
}

class _ComponentWidget<T extends Controller> extends State<Component> {
  Module module;
  T Function(Module module) initController;
  T controller;

  @override
  void initState() {
    this.module = widget.module;
    this.initController = widget.initController;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if (controller == null && initController != null) {
      controller = initController(module);
    }

    return widget.build(context, controller);
  }

  @override
  void dispose() {
    print('>>>>>>>>>> $this.dispose (state)');
    super.dispose();
  }
}