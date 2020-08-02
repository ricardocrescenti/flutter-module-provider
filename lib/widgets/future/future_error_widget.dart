import 'package:flutter/material.dart';

/// Default error widget used by `FutureWidget`
class FutureErrorWidget extends StatelessWidget {
  const FutureErrorWidget();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 70)
          ]
        )
      )
    );
  }
}