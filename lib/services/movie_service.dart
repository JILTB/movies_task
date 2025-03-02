import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/repositories/movie_repository.dart';

class MovieService {
  final MovieRepository movieRepository;

  MovieService({required this.movieRepository});

  Future<List<MovieModel>> loadMovies() => movieRepository.loadMovies();
}
