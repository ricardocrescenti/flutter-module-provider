import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import 'pages/page_01/page_01_component.dart';
import 'pages/page_02/page_02_component.dart';

class ChildModule extends Module {
  @override
  List<RouterPattern> get routes => [
    Router('page01', builder: (context) => Page01Component()),
    Router('page02', builder: (context) => Page02Component())
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
            RaisedButton(child: Text('Page 01'), onPressed: () => Navigator.of(context).pushNamed('page01')),
            RaisedButton(child: Text('Page 02'), onPressed: () => Navigator.of(context).pushNamed('page02'))
          ],
        ),
      ),
    );
  }
}