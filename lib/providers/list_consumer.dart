import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'list_provider.dart';

class ListConsumer<T> extends StatelessWidget {
  final Key key;
  final ListProvider<T> list;
  final Widget Function(BuildContext context, ListProvider<T> list) builder;
  ListConsumer({
    this.key,
    @required this.list,
    @required this.builder});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ListProvider<T>>(
      model: list,
      child: new ScopedModelDescendant<ListProvider<T>>(
        builder: (context, child, model) => builder(context, model),
      ),
    );
  }
}