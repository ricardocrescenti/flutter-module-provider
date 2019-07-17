import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:useful_classes/useful_classes.dart';

class ValueBloc<T> extends Disposable {

  final BehaviorSubject<T> bloc = BehaviorSubject();

  T get value => bloc.value;  
  ValueObservable<T> get value$ => bloc.stream;

  set value(T value) => bloc.sink.add(value);

  ValueBloc({T initValue, Function(T data) onChange}) {
    updateValue(initValue);

    if (onChange != null) {
      value$.listen(onChange);
    }
  }

  updateValue(T newValue) {
    if (newValue != this.value) {
      value = newValue;
    }
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}