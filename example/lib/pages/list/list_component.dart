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
      appBar: AppBar(
        title: Text('List Example'),
        centerTitle: true,
      ),
      body: ListConsumer<String>(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.add('batata'),
        tooltip: 'Add movie',
        child: Icon(Icons.add),
      ),
    );
  }
}