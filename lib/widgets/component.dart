import 'package:flutter/material.dart';
import 'package:module_provider/classes/inject_manager.dart';
import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// Widget for implement components in your app module
abstract class Component<T extends Controller> extends StatefulWidget with Disposable {
  final Module module;
  final InjectManager<Controller> _instanceManager = InjectManager<Controller>(standalone: true);

  Component(this.module);

  T get controller {
    if (initController != null) {
      return _instanceManager.getInstance<T>(module, null, [Inject((m, args) => initController(this.module))]);
    }
    return null;
  }

  T Function(Module module) get initController;

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => _ComponentWidget<T>();

  @override
  dispose() {
    print('>>>>>>>>>> $this.dispose');
    _instanceManager.dispose();
    super.dispose();
  }
}

class _ComponentWidget<T extends Controller> extends State<Component> {
  Widget createdWidget;
  
  @override
  Widget build(BuildContext context) {
    if (createdWidget == null) {
      createdWidget = widget.build(context);
      print('>>>>>>>>>> $widget.build created widget');
    }
    return createdWidget;
  }

  @override
  void dispose() {
    print('>>>>>>>>>> $this.dispose');
    widget.dispose();
    super.dispose();
  }
}