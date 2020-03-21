import 'package:flutter/material.dart';

/// Default error widget used by `FutureWidget`
class FutureErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [
      Icon(Icons.error, size: 70,)
    ];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        )
      )
    );
  }
}