import 'package:scoped_model/scoped_model.dart';

class ValueProvider<T> extends Model {
  T _value;

  T get value => _value;
  set value(T newValue) => updateValue(newValue);

  ValueProvider({T initialValue}) {
    value = initialValue;
  }

  updateValue(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}