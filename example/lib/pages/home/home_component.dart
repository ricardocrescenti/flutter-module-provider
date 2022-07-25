import 'package:module_provider_example/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class HomeComponent extends Component {
  
  /// Initializes [key] for subclasses.
  HomeComponent({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, Controller controller) {
    return Scaffold(
      appBar: _buildAddBar(controller),
      body: _buildBody(context, controller),
    );
  }

  _buildAddBar(Controller controller) {
    return AppBar(
      title: const Text('Module Provider Example'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.brightness_low),
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
          ElevatedButton(child: const Text('Counter (Value Provider) example'), onPressed: () => Navigator.of(context).pushNamed('counter')),
          ElevatedButton(child: const Text('Movies (List Provider) example'), onPressed: () => Navigator.of(context).pushNamed('list')),
          ElevatedButton(child: const Text('Child module example'), onPressed: () => Navigator.of(context).pushNamed('childmodule'))
        ],
      ),
    );
  }
}