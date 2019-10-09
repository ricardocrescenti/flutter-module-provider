import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class ValueConsumer<T> extends Consumer<ValueProvider<T>> {
  final Key key;
  final ValueProvider<T> value;
  final Widget Function(BuildContext context, Module module, ValueProvider<T> value) builder;
  
  ValueConsumer({
    this.key,
    @required this.value,
    @required this.builder});
}