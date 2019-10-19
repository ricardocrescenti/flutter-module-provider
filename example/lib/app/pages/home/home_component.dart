import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import '../../services/app_service.dart';
import 'home_controller.dart';

class HomeComponent extends Component<HomeController> {
  @override
  initController(BuildContext context, Module module) => HomeController(module);

  @override
  Widget build(BuildContext context, Module module, HomeController controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.brightness_low),
            tooltip: "Change to dark mode",
            onPressed: module.service<AppService>().changeDarkMode,)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:',),
            ValueConsumer<int>(
              value: controller.counter,
              builder: (context, module, value) {
                return Text(
                  '${value.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}