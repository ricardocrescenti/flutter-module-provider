import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

//typedef RouteValidation = bool Function(BuildContext context);
/// 
/// ```dart
/// Router('product', builder: (context) => HomeComponent())
/// ```
typedef RouteBuilder = Widget Function(BuildContext context);


class ModuleRoute extends ModuleRoutePattern {
	//final List<RouteValidation> canPush;
	//final List<RouteValidation> canPop;
	final RouteBuilder builder;

	ModuleRoute(String name, {
		//this.canPush,
		//this.canPop,
		@required this.builder
	}) : super(name);
}