import 'package:flutter/material.dart';
import 'package:useful_classes/useful_classes.dart';

import 'value_bloc.dart';

class ValuesBloc extends Disposable {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final Map<String, ValueBloc<dynamic>> fields;
  
  ValuesBloc(this.fields, {Map<String, dynamic> initValues}) {
    if (initValues != null) {
      updateValues(initValues);
    }
  }

  ValueBloc<dynamic> field(String field) {
    if (fields.containsKey(field)) {
      return fields[field];
    }
    throw 'Invalid field \'$field\' in FieldsBloc.';
  }

  updateValues(Map<String, dynamic> values) {
    values.forEach((key, initValue) {
      if (fields.containsKey(key)) {
        fields[key].updateValue(initValue);
      }
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    fields.forEach((key, field) {
      json[key] = field.value;
    });
    return json;
  }

  @override
  dispose() {
    if (fields != null) {
      fields.forEach((key, field) => field.dispose());
    }
    fields.clear();
    return super.dispose();
  }
}