import 'dart:async';

import 'package:module_provider/util/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// The [Service] provide functions and properties to components, modules
/// and other services, he is created and maintained in memory until parent 
/// module be disposed.
/// 
/// In the example below, I declared the `darkMode` property of type [bool]
/// that defines whether the app will be built in dark mode or not.
/// 
/// ```dart
/// class AppService extends Service {
///   bool _darkMode = false;
///   bool get darkMode => _darkMode;
/// 
///   AppService(Module module) : super(module);
/// 
///   changeDarkMode() {
///     _darkMode = !_darkMode;
///   }
/// }
/// ```
abstract class Service with OnDispose {

	/// Parent service module
	final Module module;

	/// List of [StreamSubscription] performed on the service, when discarding
	/// the service, they are automatically canceled.
	final List<StreamSubscription> streamsSubscriptions = [];

	/// Service initializer
	Service(this.module) {
		logger.log('Service $runtimeType initialized');
	}

	/// This method is called when the [Module] is discarded. All StreamSubscription
	/// will also be canceled.
	@override
	void dispose() {
		
		// cancel all streams subscriptions
		for (var subsctiption in streamsSubscriptions) {
			subsctiption.cancel();
		}

		super.dispose();
		
		logger.log('Service $runtimeType disposed');
	}

}