import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/patterns/inherited_module.dart';

class Consumer<T extends ChangeNotifier> extends StatefulWidget {
  final T value;
  final Widget Function(BuildContext context, Module module, T value) builder;
  
  Consumer({Key key, @required this.value, @required this.builder}) : super(key: key);

  T getValue(BuildContext context, ConsumerState consumer) {
    return value;
  }

  @override
  ConsumerState createState() => ConsumerState<T>();
}

class ConsumerState<T extends ChangeNotifier> extends State<Consumer<T>> {
  Module module;
  T value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    module = (context.inheritFromWidgetOfExactType(InheritedModule) as InheritedModule).module;

    if (value == null) {
      _initValue(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, module, value);
  }

  @override
  void dispose() {
    value.removeListener(_listener);
    super.dispose();
  }

  _initValue(BuildContext context) {
    value = widget.getValue(context, this);
    value.addListener(_listener);
  }

  _listener() {
    setState(() {});
  }
}