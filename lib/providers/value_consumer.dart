import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'value_provider.dart';

class ValueConsumer<T> extends StatelessWidget {
  final Key key;
  final ValueProvider<T> value;
  final Widget Function(BuildContext context, ValueProvider<T> value) builder;
  ValueConsumer({
    this.key,
    @required this.value,
    @required this.builder});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ValueProvider<T>>(
      model: value,
      child: new ScopedModelDescendant<ValueProvider<T>>(
        builder: (context, child, model) => builder(context, model),
      ),
    );
  }
}