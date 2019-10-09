import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

import 'list_provider.dart';

class ListConsumer<T> extends Consumer<ListProvider<T>> {
  final ListProvider<T> list;
  final Widget Function(BuildContext context, Module module, ListProvider<T> list) builder;
  
  ListConsumer({
    Key key, 
    @required this.list, 
    @required this.builder}) : super(key: key, value: list, builder: builder);
}