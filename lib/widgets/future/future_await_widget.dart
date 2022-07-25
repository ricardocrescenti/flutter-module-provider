import 'package:flutter/material.dart';

/// Default await widget used by `FutureWidget`
class FutureAwaitWidget extends StatelessWidget {
  
  /// Initializes [key] for subclasses.
  const FutureAwaitWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator()
          ]
        )
      )
    );
  }
}