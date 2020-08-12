import 'package:module_provider/module_provider.dart';

class ListController extends Controller {
  final ListProvider<String> movies = ListProvider(initialItems: [
    'Star Wars',
    'Terminator 2: Judgment Day',
    'Total Recall',
    'Matrix',
    'Tron: Legacy'
  ]);

  ListController(Module module) : super(module);

  add(String movieName) {
    movies.add(movieName);
  }
}