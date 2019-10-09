import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class ServiceConsumer<T extends Service> extends Consumer<T> {
  final Key key;
  final Widget Function(BuildContext context, Module module, T service) builder;

  ServiceConsumer({
    this.key,
    @required this.builder}) : super(key: key, builder: builder);

    @override
  T getValue(BuildContext context, ConsumerState consumer) {
    return consumer.module.service<T>();
  }
}