import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import './pages/home/home_component.dart';
import './services/app_service.dart';

class AppModule extends Module {
  @override
  List<Inject<Service>> get services => [
    Inject((m, arg) => AppService(m))
  ];

  @override
  List<Inject<Component<Controller>>> get components => [
    Inject((m, arg) => HomeComponent())
  ];

  @override
  Widget build(BuildContext context) {
    return ServiceConsumer<AppService>(
      builder: (context, module, service) {

        return MaterialApp(
          title: 'Counter',
          theme: ThemeData(
            brightness: (service.darkMode ? Brightness.dark : Brightness.light),
            primarySwatch: Colors.blue,
          ),
          home: component<HomeComponent>(),
        );

      }
    );
  }
}