import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import 'pages/home/home_component.dart';
import 'pages/counter/counter_component.dart';
import 'pages/list/list_component.dart';
import 'pages/child_module/child_module.dart';
import 'services/app_service.dart';
import 'services/data_service.dart';

class AppModule extends Module {
  @override
  List<InjectService> get services => [
    (m) => AppService(m),
    (m) => DataService(m)
  ];

  @override
  List<ModuleRoutePattern> get routes => [
    ModuleRoute('', builder: (context) => HomeComponent()),
    ModuleRoute('counter', builder: (context) => CounterComponent()),
    ModuleRoute('list', builder: (context) => ListComponent()),
    ModuleRoute('childmodule', builder: (context) => ChildModule()),
  ];

  @override
  Widget build(BuildContext context) {

    return ValueConsumer<bool>(
      provider: service<AppService>().darkMode,
      builder: (context, darkMode) {

        return MaterialApp(
          title: 'Module Provider',
          theme: ThemeData(
            brightness: (darkMode ? Brightness.dark : Brightness.light),
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: Module.onGenerateRoute,
        );

      }
    );

  }
}