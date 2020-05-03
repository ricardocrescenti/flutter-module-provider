import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

typedef RouteValidation = bool Function(BuildContext context);
typedef RouteBuilder = Widget Function(BuildContext context);

class Router extends RouterPattern {
  final List<RouteValidation> canPush;
  final List<RouteValidation> canPop;
  final RouteBuilder builder;

  Router(String name, {
    this.canPush,
    this.canPop,
    @required this.builder
  }) : super(name);
}