import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

import 'counter_controller.dart';

class CounterComponent extends Component<CounterController> {
  
  /// Initializes [key] for subclasses.
  CounterComponent({ Key? key }) : super(key: key);

  @override
  initController(BuildContext context, Module module) => CounterController(module);

  @override
  Widget build(BuildContext context, CounterController controller) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(controller),
      floatingActionButton: _buildIncrementButton(controller),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text('Counter Example'),
      centerTitle: true,
    );
  }

  _buildBody(CounterController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:',),
          ValueConsumer<int>(
            provider: controller.counter,
            builder: (context, value) {
              return Text(
                value.toString(),
                style: Theme.of(context).textTheme.headline4,
              );
            }
          ),
        ],
      ),
    );
  }

  _buildIncrementButton(CounterController controller) {
    return FloatingActionButton(
      onPressed: controller.increment,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}