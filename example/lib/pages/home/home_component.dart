import 'package:counter_example/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

class HomeComponent extends Component {
  @override
  Widget build(BuildContext context, Controller controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module Provider Example'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.brightness_low),
            tooltip: "Change to dark mode",
            onPressed: controller.module.service<AppService>().changeDarkMode,),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(child: Text('Counter example'), onPressed: () => Navigator.of(context).pushNamed('counter')),
            RaisedButton(child: Text('Child module example'), onPressed: () => Navigator.of(context).pushNamed('childmodule'))
          ],
        ),
      ),
    );
  }
}