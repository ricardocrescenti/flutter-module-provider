import 'package:module_provider_example/pages/child_module/services/child_service.dart';
import 'package:module_provider_example/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

class Page02Component extends Component {
	
	/// Initializes [key] for subclasses.
	Page02Component({ Key? key }) : super(key: key);

	@override
	initialize(BuildContext context, Controller controller) {

		super.initialize(context, controller);
		controller.module.service<DataService>();
		controller.module.service<ChildService>();

	}
	
	@override
	Widget build(BuildContext context, Controller controller) {

		return Scaffold(
			appBar: AppBar(
				title: const Text('Page 02'),
				centerTitle: true,
			),
			body: const Center(
				child: Text('Page 02 body')
			),
		);

	}
}