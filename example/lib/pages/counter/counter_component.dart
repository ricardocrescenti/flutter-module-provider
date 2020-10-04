import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import 'counter_controller.dart';

class CounterComponent extends Component<CounterController> {
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
      title: Text('Counter Example'),
      centerTitle: true,
    );
  }

  _buildBody(CounterController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You have pushed the button this many times:',),
          ValueConsumer<int>(
            provider: controller.counter,
            builder: (context, value) {
              return Text(
                '${value}',
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
      child: Icon(Icons.add),
    );
  }
}