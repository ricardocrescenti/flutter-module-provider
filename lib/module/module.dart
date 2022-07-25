import 'package:flutter/material.dart';
import 'package:module_provider/classes/inherited_module.dart';
import 'package:module_provider/classes/inject_manager.dart';
import 'package:module_provider/util/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:module_provider/widgets/future/future_await_widget.dart';
import 'package:module_provider/widgets/future/future_error_widget.dart';
import 'package:module_provider/widgets/future/future_widget.dart';
import 'package:useful_classes/useful_classes.dart';

/// List of initialized modules
Map<Type, ModuleState> _modules = {};

/// The [Module] contains the basic structure with services and routes, keeping
/// services instances in memory. When the module is disposed, all services are 
/// also disposed.
/// 
/// In the example below, I created the module structure, with services and, and
/// in the [build] method, `HomeComponent` is returned for display on the screen.
/// 
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:module_provider/module_provider.dart';
/// 
/// class AppModule extends Module {
///   @override
///   List<Inject<Service>> get services => [
///     Inject((m) => AppService(m)),
///     Inject((m) => DataService(m)),
///   ];
/// 
///   @override
///   Widget build(BuildContext context) => HomeComponent();
/// }
/// ```
/// 
/// The module also allows the implementation of routes. Below will be shown
/// tree examples, the first the implementation of routes in the root module, 
/// and after two examples of routes in a child modules.
/// 
/// 1) Example of implementation of the root module:
/// 
/// ```dart
/// class AppModule extends Module {
///   @override
///   List<RouterPattern> get routes => [
///     Router('', builder: (context) => HomeComponent()),
///     Router('page01', builder: (context) => Page01Component()),
///     Router('page02', builder: (context) => Page02Component()),
///   ];
/// 
///   @override
///   Widget build(BuildContext context) {
/// 
///     return MaterialApp(
///       title: 'Module Provider',
///       theme: ThemeData(
///         brightness: (darkMode ? Brightness.dark : Brightness.light),
///         primarySwatch: Colors.blue,
///       ),
///       onGenerateRoute: Module.onGenerateRoute,
///     );
/// 
///   }
/// }
/// ```
/// 
/// 2) Example of a child module (**without** the [build] method)
/// 
/// ```dart  
/// class ChildModule extends Module {
///   @override
///   List<RouterPattern> get routes => [
///     Router('', builder: (context) => HomeComponent()),
///     Router('page01', builder: (context) => Page01Component()),
///     Router('page02', builder: (context) => Page02Component()),
///   ];
/// }
/// ```
/// 
/// 2) Example of a child module (**with** the [build] method)
/// 
/// ```dart  
/// class ChildModule extends Module {
///   @override
///   List<RouterPattern> get routes => [
///     Router('page01', builder: (context) => Page01Component()),
///     Router('page02', builder: (context) => Page02Component()),
///   ];
/// 
///   @override
///   Widget build(BuildContext context) {
/// 
///     return Scaffold(
///       appBar: AppBar(
///         title: Text('Child module example'),
///         centerTitle: true,
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             RaisedButton(child: Text('Page 01'), onPressed: () => Navigator.of(context).pushNamed('page01')),
///             RaisedButton(child: Text('Page 02'), onPressed: () => Navigator.of(context).pushNamed('page02'))
///           ],
///         ),
///       ),
///     );
/// 
///   }
/// }
/// ```
abstract class Module extends StatefulWidget with OnDispose {

	/// List of [Service] that your module will provide for all objects that are
	/// built on this module or the widgets tree. He is created and maintained 
	/// in memory until module be disposed.
	/// 
	/// ```dart
	/// @override
	/// List<Inject<Service>> get services => [
	///   Inject((m) => AppService(m)),
	///   Inject((m) => DataService(m)),
	/// ];
	/// ```
	List<InjectService> get services => [];
	
	/// List of routes used by the module.
	/// 
	/// If a root route (/) is not specified, the build method will be automatically
	/// added as the root route, with the exception of the root module.
	/// 
	/// For the root module, the [build] method will never be added to the routes,
	/// as it must return a [MaterialApp] and pass the route management to it.
	/// 
	/// Example of how to implement the routes:
	/// 
	/// ```dart
	/// @override
	/// List<RouterPattern> get routes => [
	///   Router('page01', builder: (context) => Page01Component()),
	///   Router('page02', builder: (context) => Page02Component()),
	/// ];
	/// ```
	/// To call the required route, use the method below:
	/// 
	/// ```dart
	/// Navigator.of(context).pushNamed('page01'))
	/// ```
	/// 
	/// Don't worry about putting the slashes (/) at the beginning of each route,
	/// the module route manager will take care of adding this for you.
	List<ModuleRoutePattern> get routes => [];

	/// Initializes [key] for subclasses.
	Module({ Key? key }) : super(key: key);

	/// Module initializer.
	/// 
	/// This method can be used to initialize something needed for your component.
	/// 
	/// If you need to wait for something asynchronous, add `async` to the method,
	/// the module will show loading until the future method will be completed. 
	/// You can modify the loading of the module by overriding the 
	/// [buildFutureAwaitWidget] method.
	/// 
	/// This method is called only once at module startup.
	initialize(BuildContext context) {}

	/// Obtain a module service.
	/// 
	/// If the requested service is not declared in the current module, it will
	/// be attempted to load the service from the parent module (if this module
	/// is not the root module).
	T service<T extends Service>() {

		ModuleState module = _modules[runtimeType]!;
		T? service = module._servicesInstances.getInstance<T>(this, services,
			nullInstance: (module.parentModule != null ? () => module.parentModule!.service<T>(): null)) as T?;

		return service!;

	}
	
	/// Create the module load widget.
	/// 
	/// This method is only used if the [initialize] method is asynchronous.
	/// 
	/// By default it will return the following widget:
	/// 
	/// ```
	/// return Scaffold(
	///   body: Center(
	///     child: Column(
	///       mainAxisSize: MainAxisSize.max,
	///       mainAxisAlignment: MainAxisAlignment.center,
	///       crossAxisAlignment: CrossAxisAlignment.center,
	///       children: <Widget>[
	///         CircularProgressIndicator()
	///       ]
	///     )
	///   )
	/// );
	/// ```
	Widget buildFutureAwaitWidget(BuildContext context) {
		return const FutureAwaitWidget();
	}
	
	/// Create the module load error widget.
	/// 
	/// This method is only used if the [initialize] method is asynchronous and
	/// 
	/// By default it will return the following widget:
	/// 
	/// ```
	/// return Scaffold(
	///   body: Center(
	///     child: Column(
	///       mainAxisSize: MainAxisSize.max,
	///       mainAxisAlignment: MainAxisAlignment.center,
	///       crossAxisAlignment: CrossAxisAlignment.center,
	///       children: <Widget>[
	///         Icon(Icons.error, size: 70)
	///       ]
	///     )
	///   )
	/// );
	/// ```
	Widget buildFutureErrorWidget(BuildContext context, Object? error) {
		return const FutureErrorWidget();
	}

	/// Build the user interface represented by this module.
	/// 
	/// This method is required when the module has no route implementation or is
	/// the root module.
	Widget? build(BuildContext context);

	@override
	State<StatefulWidget> createState() => ModuleState();

	/// Called when this object is permanently removed from the tree. All services 
	/// loaded in memory will be disposed.
	@override
	dispose() {
		super.dispose();
	}
	
	/// Get the reference of an initialized module
	static T of<T extends Module>() {

		ModuleState? module = _modules[T];
		if (module != null) {
			return module.widget as T;
		}

		throw Exception('Undeclared module');

	}

	/// Get the module route manager
	/// 
	/// This method will return the routes from the root module to be used in
	/// [MaterialApp.onGenerateRoute].
	static RouteFactory get onGenerateRoute => _modules[_modules.keys.elementAt(0)]!.onGenerateRoute;
}

/// Class to maintain `Module` state
class ModuleState extends State<Module> with ModuleRouteManager {

	/// Indicates whether the module is the root module
	bool _isRootModule = false;

	/// Indicate whether the module has already been initialized
	bool _initialized = false;
	
	/// Reference of the [Future] used to initialize the component if
	/// the [Module.initialize] method is asynchronous.
	Future<void>? _futureInitialize;

	/// Parent module.
	Module? _parentModule;
	/// Parent module.
	Module? get parentModule => _parentModule;

	/// Service instance manager, responsible for initializing and maintaining
	/// the instances in memory until the module is downloaded.
	final InjectManager<Service> _servicesInstances = InjectManager<Service>();

	@override
	void initState() {

		super.initState();
		_registerModule();

		if (_modules.keys.elementAt(0) == widget.runtimeType) {
			_isRootModule = true;
		}

		// Get information if the module has routes
		final bool moduleHasRoutes = (widget.routes.isNotEmpty);

		if (moduleHasRoutes || !_isRootModule) {

			if (!_isRootModule && (!moduleHasRoutes || !widget.routes.any((route) => route.name.isEmpty || route.name == '/'))) {
				routes['/'] = ModuleRoute('/', builder: (context) => widget.build(context) ?? Container());
			}

			loadRoutes(widget.routes, parentUrl: '/');
			
		}

	}

	@override
	void didChangeDependencies() {

		super.didChangeDependencies();

		_parentModule = context.dependOnInheritedWidgetOfExactType<InheritedModule>()?.module;

		if (!_initialized) {
			_initialized = true;
			_futureInitialize = widget.initialize(context) as Future<void>?;
		}

	}

	@override
	Widget build(BuildContext context) {

		return InheritedModule(
			module: widget,
			child: FutureWidget<void>(
				future: (context) => _futureInitialize,
				awaitWidget: widget.buildFutureAwaitWidget,
				errorWidget: widget.buildFutureErrorWidget,
				builder: (context, result) {

					final Widget? widget = this.widget.build(context);

					if (_isRootModule) {

						if (widget == null) {
							throw Exception('The "build" method was not implemented in ${this.widget.runtimeType}, for root modules or without routes, it is required');
						}
						return widget;

					} else {
						
						return navigator;

					}

					//return widget.build(context);

				}
			),
		);

	}

	@override
	void dispose() {

		widget.dispose();
		_servicesInstances.dispose();
		_unregisterModule();

		super.dispose();
		
		logger.log('Module ${widget.runtimeType} disposed');
	}

	/// Add the module to the list of initialized modules
	_registerModule() {

		if (_modules.containsKey(runtimeType)) {
			throw Exception('The module ${widget.runtimeType} ${_isRootModule ? '(root) ' : ''}is already registered.');
		}
		_modules[widget.runtimeType] = this;
		logger.log('Module ${widget.runtimeType} ${_isRootModule ? '(root) ' : ''}registered');

	}
	
	/// Removes the module from the list of initialized modules
	_unregisterModule() {

		_modules.remove(runtimeType);
		logger.log('Module ${widget.runtimeType} ${_isRootModule ? '(root) ' : ''}unregistered');

	}
}