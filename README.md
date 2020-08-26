# Module Provider 👽

Create great applications, organizing your code structure in modules, with dependency injection (services), route management and state control.

- **[Introduction](#introduction)**
- **[How to Install](#how-to-install)**
- **[Modules Structure](#modules-structure)**
  - **[Root Module](#root-module)**
  - **[Childs Module](#childs-module)**
  - **[Service](#service)**
  - **[Component](#component)**
  - **[Controller](#controller)**
- **[State Management](#state-management)**
  - **[ValueProvider](#valueprovider-/-valueconsumer)**
  - **[ValuesProvider](#valuesprovider-/-valuesconsumer)**
  - **[ListProvider](#listprovider-/-listconsumer)**

## Introduction

The **Module Provider** is a package that facilitates the creation of simple and complex applications, using a concept of modules with dependency injection, similar to that used by Angular, having in the module the declaration of services (dependency injection) and routes navigation.

This package also provides classes for state managers, which facilitate the control of data changes and update the dependents (widgets) in each change

## How to install

Add the dependency on `pubspec.yaml`. 

*Informing `^` at the beginning of the version, you will receive all updates that are made from version `2.0.0` up to the version before `3.0.0`.*

```yaml
dependencies:
  module_provider: ^2.0.0
```

Import the package in the source code.

```dart
import 'package:module_provider/module_provider.dart';
```

## Modules Structure

A module is the main structure of the application, where all services used and navigation routes will be declared.

The use of routes is important for applications that have more than one module or have the need to navigate to other screens, this practice also facilitates the reading of the code, because as the routes are declared in the module, it is possible to identify all the screens that the module will open in just one location. If your application does not use navigation, using routes is optional.

The implementation of modules is standard throughout the system, with the exception of the first application module, which will be the `Root Module`, and all other modules will be `Child Modules`.

Below, it will be explained how the declaration of each type of module is made.

#### **Root Module**

As already explained above, the `Root Module` is the main module of the application, the first to be created, which will contain all the sub-modules (`Child Modules`), [Component](#component) and any other type of Widget as descending, in this module, the implementation of the `build` method will be required.

On `main.dart`, I informed that the `AppModule` is my root module, how much the module is create, the widget informed in `build` method is returned. As this is the root module, the `MaterialApp` should be returned.

```dart
import 'package:flutter/material.dart';
import 'package:app_module.dart';

void main() => runApp(AppModule());
```

In `app_module.dart`, I created my module structure, with `Services` and `Routes`. 

The `Widget` created by the `build` method will be `MaterialApp`, and as the module has configured routes, the `Module.onGenerateRoute` method must be passed to `MaterialApp.onGenerateRoute`, so that the route manager can be used of the module.

```dart
import 'package:flutter/material.dart';

class AppModule extends Module {
  @override
  List<Inject<Service>> get services => [
    (module) => AppService(module),
    (module) => DataService(module),
  ];

  @override
  List<RouterPattern> get routes => [
    Router('', (context) => HomePage()),
    Router('page01', (context) => FirstPage()),
    Router('page02', (context) => SecondPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module Provider',
      onGenerateRoute: Module.onGenerateRoute,
    );
  }
}
```

If you do not use routes, the `Module.onGenerateRoute` method does not need to be used, and the main component will be informed directly in the` MaterialApp.home` parameter.

```dart
import 'package:flutter/material.dart';

class AppModule extends Module {
  @override
  List<Inject<Service>> get services => [
    (module) => AppService(module),
    (module) => DataService(module),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module Provider',
      home: HomePage(),
    );
  }
}
```

#### **Childs Module**

The child modules are similar to the root modules, however the `build` method will only be mandatory if no routes are used, or if the root route (/) is not defined.

In the example below, a child module that does not use routes will be created.

```dart
import 'package:flutter/material.dart';

class ChildModule extends Module {
  @override
  List<Inject<Service>> get services => [
    (m, arg) => ChildService(m),
  ];

  @override
  Widget build(BuildContext context) {
    return ChildPage();
  }
}
```

The example below will show how a module that uses routes will look.

```dart
class ChildModule extends Module {
  @override
  List<Inject<Service>> get services => [
    (m, arg) => ChildService(m),
  ];

  @override
  List<RouterPattern> get routes => [
    Router('', (context) => ChildPage()),
    Router('childpage01', (context) => FirstChildPage()),
    Router('childpage02', (context) => SecondChildPage()),
  ];
}
```

### **Service**

The `Service` provide functions and properties to components, submodules and other services, he is created and maintained in memory until module be disposed.

In `app_service.dart`, I created the `AppService` and declared the `darkMode` property of type` bool` that defines whether the app will be built in dark mode or not.

```dart
class AppService extends Service {
  bool _darkMode = false;
  bool get darkMode => _darkMode;

  AppService(Module module) : super(module);
}
```

### **Component**

The `Components` are extended `StatefulWidget` widgets, but simpler, it is not necessary to create a` StatefulWidget` and `State` class, and usually have an associated `Controller` to maintain the state of the component.

Basic example of implementing a component.

```dart
class HomeComponent extends Component {
  @override
  Widget build(BuildContext context, Controller controller) { 
    return Scaffold(
      body: Center(
        child: Text('Home Component')
      )
    );
  }
}
```

Implementation of a component with a custom controller.

```dart
class HomeComponent extends Component<HomeController> {
  @override
  initController(BuildContext context, Module module) => HomeController(module);

  @override
  Widget build(BuildContext context, HomeController controller) { 
    return Scaffold(
      body: Center(
        child: Text(controller.bodyMassage)
      )
    );
  }
}
```

### **Controller**

The `Controller` is used together a `Component` to keep the logic and state separate from the component, leaving  component solely responsible for the layout.

```dart
class HomeController extends Controller {
  String bodyMassage = 'Home Componente';

  HomeController(Module module) : super(module);
}
```

## State Management

State managers are classes that facilitate the control of change transfers, all of which have a consumer so that they can change a screen with each value change.

### **ValueProvider / ValueConsumer**

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

### **ValuesProvider / ValuesConsumer**

This class is similar to `ValueProvider`, but allows the control of several values using a `Map`.

In the bellow example , is declared 'packageInfo' with the values 'name' os type String and value 'version' of type ValueProvider<String>. If you use a ValueProvider in value of ValuesProvider, on get value, is returned the value of ValueProvider, to get the ValueProvider instance, you need use 'getValueProvider' method.

```dart
ValuesProvider packageInfo = ValuesProvider({
  'name': 'package_name',
  'version': ValueProvider<String>(initialValue: ''),
});
```

To update the values on ValuesProvider use `setValues` method passing a `Map<String, dynamic>` and to update a single value, use `setValue` with `fieldName` and `newValue` arguments.

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

### **ListProvider / ListConsumer**

Notify listeners based on changing a list of objects.

This class that follows the same principle of `ValueProvier` and `ValuesProvider` but with inheritance of `ListMixin`, with this you will be able to perform the same operations as a standard `List`, and with each modification of the list the listeners will be notified.

```dart
ListProvider<String> movies = ValueProvider(initialValue: [
  'Star Wars',
  'Terminator 2: Judgment Day'
]);
```

As explained above, you can use the same methods as a standard `List`, below is a basic usage example.

```dart
movies.add('Total Recall');
movies.addAll([
  'Matrix',
  'Tron: Legacy'
]);
```

Example to consume this list. In this case, when changing the list, the Text Widget is rebuilt and shows the new value.

```dart
return ListConsumer<String>(
  list: movies,
  builder: (context, movies) {

    return ListView.separated(
      itemCount: movies.length,
      itemBuilder: (context, index) => Text(movies[index]),
      separatorBuilder: (context, index) => Divider()
    );

  }
);
```