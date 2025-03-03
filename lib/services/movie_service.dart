import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/repositories/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieService {
  final MovieRepository movieRepository;

  Stream<List<MovieModel>> get movieCache => _movieCache;

  final _movieCache = BehaviorSubject<List<MovieModel>>();

  MovieService({required this.movieRepository});

  Future<void> loadMovies() {
    return movieRepository.loadMovies().then((list) => _movieCache.add(list));
  }
}
