import 'package:module_provider/module_provider.dart';

class ListController extends Controller {
  final List<String> _basicList = [
    'Star Wars',
    'Terminator 2: Judgment Day',
    'Total Recall',
    'Matrix',
    'Tron: Legacy'
  ];
  final ListProvider<String> movies = ListProvider();

  ListController(Module module) : super(module) {
    movies.addAll(_basicList);
  }

  add(String movieName) {
    movies.add(movieName);
  }

  resetList() {
    movies.clearAddAll(_basicList);
  }
}