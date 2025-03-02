import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/models/view_models/base_view_model.dart';
import 'package:movies_task/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';

abstract class MovieListViewModelViewModelInput {
  void initLoad();
}

abstract class MovieListViewModelViewModelOutput {
  Stream<List<MovieModel>> get movieModels;
}

abstract class MovieListViewModelViewModelType extends BaseViewModel {
  MovieListViewModelViewModelInput get input;

  MovieListViewModelViewModelOutput get output;
}

class MovieListViewModelViewModel
    implements
        MovieListViewModelViewModelInput,
        MovieListViewModelViewModelOutput,
        MovieListViewModelViewModelType {
  MovieListViewModelViewModel(this._movieService) {
    movieModels = _initTrigger
        .asyncMap((_) => _movieService.loadMovies())
        .shareReplay(maxSize: 1);
  }

  final MovieService _movieService;
  final _initTrigger = BehaviorSubject.seeded(null);
  @override
  MovieListViewModelViewModelInput get input => this;

  @override
  MovieListViewModelViewModelOutput get output => this;

  @override
  void dispose() {}

  @override
  late final Stream<List<MovieModel>> movieModels;

  @override
  void initLoad() {}
}
