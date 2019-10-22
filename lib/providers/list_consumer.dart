import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

import 'list_provider.dart';

class ListConsumer<T> extends Consumer<ListProvider<T>, List<T>> {
  final ListProvider<T> list;
  final Widget Function(BuildContext context, List<T> list) builder;
  
  ListConsumer({
    Key key, 
    @required this.list, 
    @required this.builder}) : super(key: key, provider: list, builder: builder);

  @override
  List<T> getValue(BuildContext context, ConsumerState consumer) {
    return list.items;
  }
}