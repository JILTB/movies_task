import 'package:movies_task/models/movie_list_model.dart';
import 'package:movies_task/models/requests/load_movies_list.dart';
import 'package:movies_task/services/network_services/base_api.dart';

class MovieApi extends BaseApi {
  MovieApi(super.httpClient);

  Future<MovieListModel> loadMovies() {
    final model = LoadMoviesListModel();

    return makeRequest(model, mapper: (json) => MovieListModel.fromJson(json));
  }
}
