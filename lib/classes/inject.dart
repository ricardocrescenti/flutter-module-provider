import 'package:module_provider/module_provider.dart';

/// Basic type used in `InjectManager` to implement dependency injection
typedef Inject<T> = T Function(Module module);

/// Basic type for dependency injection used in module services
typedef InjectService = Service Function(Module module);