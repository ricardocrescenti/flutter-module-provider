## 2.1.1

* Fixed the `getValue` and `setValue` method when an array of fields was passed, used when there is a data hierarchy with `List` and `Map`.

## 2.1.0

* Added the types of returns in the `ValueProvider` and `ValuesProvider` methods;
* Improvement in the `getValue` method of `ValuesProvider` when the value of the field is a `Map` or` List`.

## 2.0.0+1

* Updated package icon in the documentation.

## 2.0.0 (New version)

Made several adjustments that will cause code break when upgrading from version 1 to version 2;

* Improved service declaration in the module;
* Added support for navigation with routes;
* Removed the declaration of components and submodules in the module;
* Added future loading on modules and components;
* Improved the `ListProvider` to work like a` List`;
* Removed the parameter `module` from the component, to obtain the module, use the` controller` of the `component`.

## 1.3.1

* Replaced `inheritFromWidgetOfExactType` deprecated method by `dependOnInheritedWidgetOfExactType`.

## 1.3.0

* Added operator [] in ValuesProvider to get values.

## 1.3.0

* Added `initialize()` method in `Component` to allow the user to initialize something at `Component` initialization, this method is called only once before the `build()` method.

## 1.2.0

* Added `initialize()` method in `Module` to allow the user to initialize something at `Module` initialization, this method is called only once before the `build()` method.

## 1.1.0+3

* Removed '{@tool sample}' and '{@end-tool}' from documentation.

## 1.1.0+2

* Added documentation for package classes.
* Renamed parameter `value` in `ValuesProvider` method `build()` to `values`.
* Moved the `inject_manager.dart` file to the 'classes' folder.

## 1.1.0+1

* Updated README.md with another examples and descriptions.

## 1.1.0

* Removed Module parameter from the ValueConsumer and ServiceConsumer.
* Defined to consumers return direct the value in build function.
* Added ValuesConsumer to consume ValuesProvider.
* Updated lisense to "BSD 3-Clause License".

## 1.0.0

* Initial version.