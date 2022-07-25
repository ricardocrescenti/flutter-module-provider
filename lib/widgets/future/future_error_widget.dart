import 'package:flutter/material.dart';

/// Default error widget used by `FutureWidget`
class FutureErrorWidget extends StatelessWidget {
  
  /// Initializes [key] for subclasses.
  const FutureErrorWidget({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.error, size: 70)
          ]
        )
      )
    );
  }
}