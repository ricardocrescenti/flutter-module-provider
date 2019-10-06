import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class ServiceConsumer<T extends Service> extends Consumer<T> {
  final Key key;
  final Module module;
  final Widget Function(BuildContext context, T service) builder;

  ServiceConsumer({
    this.key,
    @required this.module,
    @required this.builder});

  @override
  T getValue() {
    return module.service<T>();
  }
}