import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

class Page01Component extends Component {
  @override
  initialize(BuildContext context, Controller controller) async {
    await super.initialize(context, controller);
    await Future.delayed(Duration(seconds: 3));
  }
  
  @override
  Widget build(BuildContext context, Controller controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 01'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Page 01 body')
      ),
    );
  }
}