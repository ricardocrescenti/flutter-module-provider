import 'package:flutter/material.dart';

class Consumer<T extends ChangeNotifier> extends StatefulWidget {
  final T value;
  final Widget Function(BuildContext context, T value) builder;
  Consumer({Key key, @required this.value, @required this.builder}) : super(key: key);

  T getValue() {
    return value;
  }

  @override
  _ConsumerState createState() => _ConsumerState<T>();
}

class _ConsumerState<T extends ChangeNotifier> extends State<Consumer<T>> {
  T value;

  listener() {
    setState(() {});
  }

  @override
  void initState() {
    value = widget.getValue();
    value.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value);
  }

  @override
  void dispose() {
    value.removeListener(listener);
    super.dispose();
  }
}