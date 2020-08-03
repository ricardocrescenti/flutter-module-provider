import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to create a route grouper.
/// 
/// ```dart
/// RouterGroup('groupRouteName', routes: [
///   Router('page01', builder: (context) => Page01Component()),
///   Router('page02', builder: (context) => Page02Component())
/// ])
/// ```
/// 
/// The above example will return the following route
/// 
/// - /groupRouteName/page01
/// - /groupRouteName/page02
class RouterGroup extends RouterPattern {
  final List<RouterPattern> routes;

  RouterGroup(String name, {
    @required this.routes,
  }) : super(name);
}