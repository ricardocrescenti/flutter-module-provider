import 'package:counter_example/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

class HomeComponent extends Component {
  @override
  Widget build(BuildContext context, Controller controller) {
    return Scaffold(
      appBar: _buildAddBar(controller),
      body: _buildBody(context, controller),
    );
  }

  _buildAddBar(Controller controller) {
    return AppBar(
      title: Text('Module Provider Example'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.brightness_low),
          tooltip: "Change to dark mode",
          onPressed: controller.module.service<AppService>().changeDarkMode,),
      ],
    );
  }

  _buildBody(BuildContext context, Controller controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(child: Text('Counter (Value Provider) example'), onPressed: () => Navigator.of(context).pushNamed('counter')),
          ElevatedButton(child: Text('Movies (List Provider) example'), onPressed: () => Navigator.of(context).pushNamed('list')),
          ElevatedButton(child: Text('Child module example'), onPressed: () => Navigator.of(context).pushNamed('childmodule'))
        ],
      ),
    );
  }
}