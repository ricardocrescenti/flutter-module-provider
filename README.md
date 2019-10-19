# module_provider

Package to facilitate creation applications in modules structure pattern.

```dart
import 'package:module_provider/module_provider.dart';
```

**Module:** The module contain the basic structure with services, submodules and components, keeping the instances of services and submodules. When module is dispose, all services are disposed also.

**Service:** The service provide functions and properties to components, submodules and other services, he is created and maintained in memory until module be disposed.

**Component:** Componentes are a pages or widgets extended from StatefulWidget, but with a simple class, don't needing create a StatefullWidget and State class.

**Controller:** The controller are utilized inside a components, for maintain the logical separated from component.

# Simple exemple to use Module Provider

On main.dart, i will informed that the 'AppModule' is my root module, how much the module is create, the structure of widgets informed in build method of the module is returned. 

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
		Inject((m, arg) => DataService(m)),
	];

	@override
	List<Inject<Component>> get components => [
		Inject((m, arg) => HomeComponent()),
		Inject((m, arg) => TaskListComponent()),
		Inject((m, arg) => AddEditTaskComponent()),
	];

	@override
  	Widget build(BuildContext context) => component<HomeComponent>();
}
```

# State Management Classes

## ValueProvider

Simple class to notify listeners when value is changed.

```dart
ValueProvider<String> description = ValueProvider(initialValue: 'Initial Description');
```

You can modify value setting property 'value' or calling method 'setValue'.

```dart
description.value = 'Another Description';
description.setValue('Another Description');
```

Example to consume this value. In this case, when changing the description value, the Text Widget is rebuilt and shows the new value.

```dart
ValueConsumer<String>(
    value: description,
    builder: (context, value) => Text(value)
);
```

## ValuesProvider

Controlling multiple values and ValueProvider.

In the bellow example , is declared 'packageInfo' with the values 'name' os type String and value 'version' of type ValueProvider<String>. If you use a ValueProvider in value of ValuesProvider, on get value, is returned the value of ValueProvider, to get the ValueProvider instance, you need use 'getValueProvider' method.

```dart
ValuesProvider packageInfo = ValuesProvider({
    'name': 'package_name',
    'version': ValueProvider<String>(initialValue: ''),
});
```

To update the values on ValuesProvider use 'setValues' method passing a Map<String, dynamic>, and to update a single value, use 'setValue' with 'fieldName' and 'newValue' arguments.

```dart
packageInfo.setValues({
    'name': 'module_provider',
    'version': '1.0.0'
});
```

Example for consume all values of the ValuesProvider.

```dart
ValueConsumer<String>(
    value: packageInfo,
    builder: (context, values) => Column() {
		childs: Widget[] {
			Text(values.getValue('name'),
			Text(values.getValue('version'))
		}
	}
);
```

Example for consume a ValueProvider in the ValuesProvider.

```dart
ValueConsumer<String>(
    value: packageInfo.getValueProvider('version'),
    builder: (context, value) => Text(value)
);
```

## ServiceConsumer

The 'ServiceConsumer' is used for consume an specfically service declared in the 'Module', and receive notifications when state of service is changed. 

For example, you have a 'darkMode' property of type bool in the 'Service', and on change this property, yout application need build again to set your application to dark mode.

```dart
ServiceConsumer<AppService>(
      builder: (context, module, service) {

        return MaterialApp(
          title: 'Task List',
          theme: ThemeData(
            brightness: (service.darkMode ? Brightness.dark : Brightness.light),
            primarySwatch: Colors.blue,
          ),
          initialRoute: Page.home,
          routes: {
            Page.home: (context) => component<HomeComponent>(),
            Page.addEdit: (context) => component<AddEditTaskComponent>(),
          },
        );

      }
    )
```