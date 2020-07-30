import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class RouterGroup extends RouterPattern {
  final List<RouterPattern> routes;

  RouterGroup(String name, {
    @required this.routes,
  }) : super(name);
}