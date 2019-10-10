# module_provider

Package to facilitate the creation applications in hierarquical modules structure

```dart
import 'package:module_provider/module_provider.dart';
```

**Module:** The module contain the basic structure for determined component, it is created when 'Component' is builded, and disposed when the 'Component' is disposed. When module is dispose, all services are disposable also.

**Service:** The service provide a class containing functions and properties to components, modules and another services, he is created and maintained in memory, when module be disposable, all services also be disposed.

**Component:** Componentes are a pages or widgets extended from StatefulWidget, but with a simple class, don't needing create a StatefullWidget and State class. All components need the module referente on your constructor.

**Controller:** The controller are utilized inside a components, for maintain the logical separated from component, and avoid the recreation of variables when widget build is called.

# Simple exemple to use Module Provider

On main.dart, i will informed that the 'AppModule' is my root module, so the component returned from 'build' function inside the module will be showed.

```dart
import 'package:flutter/material.dart';
import 'package:app_module.dart';

void main() => runApp(AppModule());
```

app_module.dart

```dart
import 'package:flutter/material.dart';

class AppModule extends Module {
	@override
	List<Inject<Service>> get services => [
		Inject((m, arg) => AppService(m)),
		Inject((m, arg) => AuthService(m)),
	];

	@override
	List<Inject<Module>> get modules => [
		Inject((m, arg) => HomeModule(m)),
		Inject((m, arg) => RegistrationModule(m, arg)),
	];

	@override
	List<Inject<Component>> get components => [
		Inject((m, arg) => MainPage()),
		Inject((m, arg) => SplashScreenPage()),
	];

	@override
  	Widget build(BuildContext context) => component<MainPage>();
}
```

# State Storage Classes

## ValueProvider and ValueConsumer

Simple class to notify listeners when value is changed, you can modify value setting property 'value' or calling method 'updateValue'.

```dart
final ValueProvider<String> description = ValueProvider(initialValue: 'Initial Description');
description.value = 'Another Description';
description.updateValue('Another Description');

ValueConsumer<String>(
    value: description,
    builder: (context, value) => Text(value)
);
```

## ValuesProvider and ValuesConsumer

Controlling multiple "ValueModel"

```dart
final ValuesModel packageInfo = ValuesModel({
    'name': '',
    'version': '',
});
packageInfo.updateValues({
    'name': 'useful_classes',
    'version': '0.0.1'
});

ValueConsumer<String>(
    value: description,
    builder: (context, values) => Column() {
		childs: Widget[] {
			Text(values.values['name']),
			Text(value.vallues['version'])
		} 
	}
);
```

## ValueConsumer

Simple class to make easy to consume and receive changes notification from ValueNotifier

```dart
final ValueModel<String> description = ValueModel<String>(null);
description.value = 'Another Description';


```

## ServiceConsumer

Simple class to make easy to consume and receive changes notification from ValueNotifier

```dart
ValueConsumer<AppService>(
    builder: (context, module, service) => Text(service.app_name)
);
```

