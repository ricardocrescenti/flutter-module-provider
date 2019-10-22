import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class ValueConsumer<T> extends Consumer<ValueProvider<T>, T> {
  final Key key;
  final ValueProvider<T> provider;
  final Widget Function(BuildContext context, T value) builder;
  
  ValueConsumer({
    this.key,
    @required this.provider,
    @required this.builder});

  @override
  T getValue(BuildContext context, ConsumerState consumer) {
    return provider.value;
  }
}