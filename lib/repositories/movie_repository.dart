import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/services/network_services/movie_api.dart';

class MovieRepository {
  final MovieApi movieApi;

  MovieRepository({required this.movieApi});

  Future<List<MovieModel>> loadMovies() =>
      movieApi.loadMovies().then((list) => list.movies);
}
