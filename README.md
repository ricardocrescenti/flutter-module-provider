# module_provider

This package facilitates the creation of applications in the module structure, with service injection, components and state management.

```dart
import 'package:module_provider/module_provider.dart';
```

Below I will explain how `Module`,` Service`, `Component` and` Controller` are used, and then we will explain how to use the state management classes with` ValueProvider`, `ValuesProvider` and` ServiceConsumer` and also how to consume these values, ​​and be notified whenever there are any changes to these values.

---

## **Module**

The `Module` contains the basic structure with services, submodules, and components, keeping services instances. When the module is disposed, all services are also disposed.

On `main.dart`, I informed that the `AppModule` is my root module, how much the module is create, the widget informed in `build` method  is returned.

```dart
import 'package:flutter/material.dart';
import 'package:app_module.dart';

void main() => runApp(AppModule());
```

In `app_module.dart`, I created my module structure, with` Services` and `Components`, and in the` build` method, `HomeComponent` is returned for display on the screen.

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
  initialize(BuildContext context) {
    service<AppService>().changeDarkMode();
  }

  @override
  Widget build(BuildContext context) => component<HomeComponent>();
}
```

Optionally, if you need to initialize something on `Module` initialize, override the `initialize()` method in `Module`.

## **Service**

The `Service` provide functions and properties to components, submodules and other services, he is created and maintained in memory until module be disposed.

In `app_service.dart`, I created the `AppService` and declared the `darkMode` property of type` bool` that defines whether the app will be built in dark mode or not.

```dart
class AppService extends Service {
  bool _darkMode = false;
  bool get darkMode => _darkMode;

  final ValueProvider<int> counter = ValueProvider(initialValue: 0);

  AppService(Module module) : super(module);

  changeDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  incrementCounter() {
    counter.value++;
  }
}
```

When `changeDarkMode()` is called, the `darkMode` property is changed and `notifyListeners()` is called to notify all consumers.

## **Component**

The `Components` are extended `StatefulWidget` widgets, but simpler, it is not necessary to create a` StatefulWidget` and `State` class, and usually have an associated `Controller` to maintain the state of the component.

```dart
class HomeComponent extends Component<HomeController> {
  @override
  initController(BuildContext context, Module module) => HomeController(module);

  @override
  Widget build(BuildContext context, Module module, HomeController controller) { 
    /// return Scaffold(....
  }
}
```

## **Controller**

The `Controller` is used together a `Component` to keep the logic and state separate from the component, leaving  component solely responsible for the layout.

```dart
class HomeController extends Controller {
  final ValueProvider<int> counter = ValueProvider(initialValue: 0);

  HomeController(Module module) : super(module);

  increment() {
    counter.value++;
  }
}
```

# State Management Classes

## **ValueProvider / ValueConsumer**

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
  provider: description,
  builder: (context, value) => Text(value)
);
```

## **ValuesProvider / ValuesConsumer**

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
ValuesConsumer(
  provider: packageInfo,
  builder: (context, values) => Column() {
    childs: Widget[] {
      Text(values['name']),
      Text(values['version'])
    }
  }
);
```

Example for consume a ValueProvider in the ValuesProvider.

```dart
ValueConsumer<String>(
    provider: packageInfo.getValueProvider('version'),
    builder: (context, value) => Text(value)
);
```

## **ServiceConsumer**

The 'ServiceConsumer' is used for consume an specfically service declared in the 'Module', and receive notifications when state of service is changed. 

For example, you have a 'darkMode' property of type bool in the 'Service', and on change this property, yout application need build again to set your application to dark mode.

```dart
ServiceConsumer<AppService>(
      builder: (context, service) {

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