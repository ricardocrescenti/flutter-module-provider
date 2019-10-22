import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class ValuesConsumer extends Consumer<ValuesProvider, UnmodifiableMapView<String, dynamic>> {
  final Key key;
  final ValuesProvider provider;
  final Widget Function(BuildContext context, UnmodifiableMapView<String, dynamic> value) builder;
  
  ValuesConsumer({
    this.key,
    @required this.provider,
    @required this.builder});

  @override
  UnmodifiableMapView<String, dynamic> getValue(BuildContext context, ConsumerState consumer) {
    return provider.values;
  }
}