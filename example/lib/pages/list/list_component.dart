import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import 'list_controller.dart';

class ListComponent extends Component<ListController> {
  @override
  initController(BuildContext context, Module module) => ListController(module);

  @override
  Widget build(BuildContext context, ListController controller) {
    return Scaffold(
      appBar: _buildAppBar(controller),
      body: _buildBody(controller),
      floatingActionButton: _buildAddButton(controller),
    );
  }

  _buildAppBar(ListController controller) {
    return AppBar(
      title: Text('List Example'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.refresh), 
          onPressed: () => controller.resetList())
      ],
    );
  }

  _buildBody(ListController controller) {
    return ListConsumer<String>(
      list: controller.movies,
      builder: (context, movies) {

        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: movies.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(movies[index]),
            trailing: FlatButton(onPressed: () => movies.remove(movies[index]), child: Icon(Icons.delete)),
          ),
          separatorBuilder: (context, index) => Divider(),
        );

      }
    );
  }

  _buildAddButton(ListController controller) {
    return FloatingActionButton(
      onPressed: () => controller.add('Movie ' + controller.movies.length.toString()),
      tooltip: 'Add movie',
      child: Icon(Icons.add),
    );
  }
}