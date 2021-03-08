import 'package:counter_example/pages/child_module/services/child_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import 'pages/page_01/page_01_component.dart';
import 'pages/page_02/page_02_component.dart';

class ChildModule extends Module {
  @override
  List<InjectService> get services => [
    (m) => ChildService(m)
  ];

  @override
  List<ModuleRoutePattern> get routes => [
    ModuleRoute('page01', builder: (context) => Page01Component()),
    ModuleRoute('page02', builder: (context) => Page02Component())
  ];

  @override
  initialize(BuildContext context) async {
    await super.initialize(context);
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child module example'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(child: Text('Page 01'), onPressed: () => Navigator.of(context).pushNamed('page01')),
            ElevatedButton(child: Text('Page 02'), onPressed: () => Navigator.of(context).pushNamed('page02'))
          ],
        ),
      ),
    );
  }
}