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
import 'app_module.dart';

void main() {
	runApp(MaterialApp(
		title: 'Module Provider',
		theme: ThemeData(primarySwatch: Colors.blue,),
		home: AppModule()
	));
}
```

app_module.dart

```dart
import 'package:flutter/material.dart';

class AppModule extends Module {
	@override
	List<Inject<Service>> get services => [
		Inject((m, arg) => AppService(m)),
		Inject((m, arg) => AuthService(m, this.service<AppService>())),
	];

	@override
	List<Inject<Module>> get modules => [
		Inject((m, arg) => HomeModule(m)),
		Inject((m, arg) => RegistrationModule(m, arg)),
	];

	@override
	List<Inject<Component>> get components => [
		Inject((m, arg) => MainPage(m)),
		Inject((m, arg) => SplashScreenPage(m)),
	];

	AppModule() : super(null);

	@override
  	Widget build(BuildContext context) => component<MainPage>();
}
```

# State Storage Classes

## ValueModel

Simple class to notify listeners when value is changed, you can modify value setting property 'value' or calling method 'updateValue'.

```dart
final ValueModel<String> description = ValueModel<String>(initialValue: 'Initial Description');
description.value = 'Another Description';
description.updateValue('Another Description');
```

## ValuesModel

Controlling multiple "ValueModel"

```dart
final ValuesModel packageInfo = ValuesModel({
    'name': ValueModel<String>(null),
    'version': ValueModel<String>(null),
});
packageInfo.updateValues({
    'name': 'useful_classes',
    'version': '0.0.1'
});
```

## ValueConsumer

Simple class to make easy to consume and receive changes notification from ValueNotifier

```dart
final ValueModel<String> description = ValueModel<String>(null);
description.value = 'Another Description';

ValueConsumer<String>(
    value: description,
    builder: (context, value) => Text(value)
);
```

