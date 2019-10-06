import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ServiceConsumer<T extends Service> extends StatelessWidget {
  final Key key;
  final T service;
  final Widget Function(BuildContext context, T service) builder;
  ServiceConsumer({
    this.key,
    @required this.service,
    @required this.builder});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
      model: service,
      child: new ScopedModelDescendant<T>(
        builder: (context, child, service) => builder(context, service),
      ),
    );
  }
}