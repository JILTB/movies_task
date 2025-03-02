import 'package:movies_task/models/request_model.dart';

class LoadMoviesListModel extends RequestModel {
  @override
  String get path =>
      'FEND16/movie-json-data/master/json/movies-coming-soon.json';

  @override
  MethodType get type => MethodType.get;
}
