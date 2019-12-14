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