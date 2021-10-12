import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:module_provider/module_provider.dart';

import 'pages/home/home_component.dart';
import 'pages/counter/counter_component.dart';
import 'pages/list/list_component.dart';
import 'pages/child_module/child_module.dart';
import 'services/app_service.dart';
import 'services/data_service.dart';

class AppModule extends Module {
  @override
  List<InjectService> get services => [
    (m) => AppService(m),
    (m) => DataService(m)
  ];

  @override
  List<ModuleRoutePattern> get routes => [
    ModuleRoute('', builder: (context) => HomeComponent()),
    ModuleRoute('counter', builder: (context) => CounterComponent()),
    ModuleRoute('list', builder: (context) => ListComponent()),
    ModuleRoute('childmodule', builder: (context) => ChildModule()),
  ];

  @override
  Widget build(BuildContext context) {

    // ValuesProvider values = ValuesProvider({
    //   'a': 'a',
    //   'b': ValueProvider(initialValue: 'b'),
    //   'c': ['ca', {
    //     "caa": "caa",
    //     "cab": "cab"
    //   }],
    //   'd': ListProvider(initialItems: ['da', {
    //     "daa": "daa",
    //     "dab": "dab"
    //   }]),
    //   'e': ValuesProvider({
    //     'ea': 'ea',
    //     'eb': ValueProvider(initialValue: 'eab'),
    //     'ec': ['eca', 'ecb'],
    //     'ed': ListProvider(initialItems: ['eda', 'edb']),
    //   })
    // });

    // dynamic a = values.getValue('a');
    // dynamic b = values.getValue('b');
    // dynamic c = values.getValue('c');
    // dynamic ca = values.getValue(['c','0']);
    // dynamic cb = values.getValue(['c','1']);
    // dynamic cba = values.getValue(['c','1','caa']);
    // dynamic cbb = values.getValue(['c','1','cab']);
    // dynamic d = values.getValue('d');
    // dynamic da = values.getValue(['d','0']);
    // dynamic db = values.getValue(['d','1']);
    // dynamic daa = values.getValue(['d','1','daa']);
    // dynamic dab = values.getValue(['d','1','dab']);
    // dynamic e = values.getValue('e');
    // dynamic ea = values.getValue(['e','ea']);
    // dynamic eb = values.getValue(['e','eb']);
    // dynamic ec = values.getValue(['e','ec']);
    // dynamic eca = values.getValue(['e','ec','0']);
    // dynamic ecb = values.getValue(['e','ec','1']);
    // dynamic ed = values.getValue(['e','ed']);
    // dynamic eda = values.getValue(['e','ed','0']);
    // dynamic edb = values.getValue(['e','ed','1']);

    // values.setValue('a', 'ok');
    // values.setValue('b', 'ok');
    // //values.setValue('c', 'ok');
    // values.setValue(['c','0'], 'ok');
    // //values.setValue(['c','1'], 'ok');
    // values.setValue(['c','1','caa'], 'ok');
    // values.setValue(['c','1','cab'], 'ok');
    // //values.setValue('d', 'ok');
    // values.setValue(['d','0'], 'ok');
    // //values.setValue(['d','1'], 'ok');
    // values.setValue(['d','1','daa'], 'ok');
    // values.setValue(['d','1','dab'], 'ok');
    // //values.setValue('e', 'ok');
    // values.setValue(['e','ea'], 'ok');
    // values.setValue(['e','eb'], 'ok');
    // //values.setValue(['e','ec'], 'ok');
    // values.setValue(['e','ec','0'], 'ok');
    // values.setValue(['e','ec','1'], 'ok');
    // //values.setValue(['e','ed'], 'ok');
    // values.setValue(['e','ed','0'], 'ok');
    // values.setValue(['e','ed','1'], 'ok');

    // a = values.getValue(['a']);
    // b = values.getValueProvider(['b']);
    // c = values.getValue(['c']);
    // ca = values.getValue(['c','0']);
    // cb = values.getValue(['c','1']);
    // cba = values.getValue(['c','1','caa']);
    // cbb = values.getValue(['c','1','cab']);
    // d = values.getValue(['d']);
    // da = values.getValue(['d','0']);
    // db = values.getValue(['d','1']);
    // daa = values.getValue(['d','1','daa']);
    // dab = values.getValue(['d','1','dab']);
    // e = values.getValue(['e']);
    // ea = values.getValue(['e','ea']);
    // eb = values.getValue(['e','eb']);
    // ec = values.getValue(['e','ec']);
    // eca = values.getValue(['e','ec','0']);
    // ecb = values.getValue(['e','ec','1']);
    // ed = values.getValue(['e','ed']);
    // eda = values.getValue(['e','ed','0']);
    // edb = values.getValue(['e','ed','1']);

    // dynamic teste = values.getValues();

    // MapProvider values = MapProvider(
    //   initialMap: {
    //     '0': {
    //       'aa': 'aa',
    //       'bb': 'bb'
    //     },
    //     'a': 'a',
    //     'b': ValueProvider(initialValue: 'b'),
    //     'c': ['ca', {
    //       "caa": "caa",
    //       "cab": "cab"
    //     }],
    //     'd': ListProvider(initialItems: ['da', {
    //       "daa": "daa",
    //       "dab": "dab"
    //     }], automaticConvertValuesToProvider: true),
    //     'e': ValuesProvider({
    //       'ea': 'ea',
    //       'eb': ValueProvider(initialValue: 'eab'),
    //       'ec': ['eca', 'ecb'],
    //       'ed': ListProvider(initialItems: ['eda', 'edb']),
    //     })
    //   },
    //   automaticConvertValuesToProvider: true
    // );
    // print(values);

    return ValueConsumer<bool>(
      provider: service<AppService>().darkMode,
      builder: (context, darkMode) {

        return MaterialApp(
          title: 'Module Provider',
          theme: ThemeData(
            brightness: (darkMode ? Brightness.dark : Brightness.light),
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: Module.onGenerateRoute,
        );

      }
    );

  }
}