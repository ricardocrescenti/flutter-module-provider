import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/module_provider.dart';

abstract class Consumer<T extends ChangeNotifier, V> extends StatefulWidget {
  final T provider;
  final Widget Function(BuildContext context, V value) builder;
  
  Consumer({Key key, @required this.provider, @required this.builder}) : super(key: key);

  T getProvider(BuildContext context, ConsumerState consumer) {
    return provider;
  }
  V getValue(BuildContext context, ConsumerState consumer);

  @override
  ConsumerState createState() => ConsumerState<T, V>();
}

class ConsumerState<T extends ChangeNotifier, V> extends State<Consumer<T, V>> {
  Module _module;
  Module get module => _module;

  T _provider;
  T get provider => _provider;

  V _value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_provider == null) {
      _initConsumer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_listener);
    super.dispose();
  }

  _initConsumer() {
    _module = (context.inheritFromWidgetOfExactType(InheritedModule) as InheritedModule).module;
    _provider = widget.getProvider(context, this);
    _value = widget.getValue(context, this);
    _provider.addListener(_listener);
  }

  _listener() {
    setState(() {
      _value = widget.getValue(context, this);
    });
  }
}