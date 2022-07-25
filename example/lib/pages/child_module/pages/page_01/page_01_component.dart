import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class Page01Component extends Component {
	
	/// Initializes [key] for subclasses.
	Page01Component({ Key? key }) : super(key: key);

	@override
	initialize(BuildContext context, Controller controller) async {

		await super.initialize(context, controller);
		await Future.delayed(const Duration(seconds: 3));

	}
	
	@override
	Widget build(BuildContext context, Controller controller) {

		return Scaffold(
			appBar: AppBar(
				title: const Text('Page 01'),
				centerTitle: true,
			),
			body: const Center(
				child: Text('Page 01 body')
			),
		);

	}
}