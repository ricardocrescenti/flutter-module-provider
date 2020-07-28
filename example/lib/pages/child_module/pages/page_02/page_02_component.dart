import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

class Page02Component extends Component {
  @override
  Widget build(BuildContext context, Controller controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 02'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Page 02 body')
      ),
    );
  }
}