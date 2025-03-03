import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/models/view_models/base_view_model.dart';
import 'package:movies_task/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';

abstract class MovieDetailsScreenViewModelInput {
  void init(String id);

  void addToFavorite(String id);
}

abstract class MovieDetailsScreenViewModelOutput {
  Stream<MovieModel> get movieModel;
}

abstract class MovieDetailsScreenViewModelType extends BaseViewModel {
  MovieDetailsScreenViewModelInput get input;

  MovieDetailsScreenViewModelOutput get output;
}

class MovieDetailsScreenViewModel
    implements
        MovieDetailsScreenViewModelInput,
        MovieDetailsScreenViewModelOutput,
        MovieDetailsScreenViewModelType {
  MovieDetailsScreenViewModel(this._movieService) {
    movieModel = _movieService.movieCache.map((list) {
      return list.firstWhere(
        (movieModel) => movieModel.id == _initTrigger.value,
      );
    });
  }

  final MovieService _movieService;
  final _initTrigger = BehaviorSubject<String>();
  final _addToFavoriteTrigger = BehaviorSubject<String>();
  @override
  MovieDetailsScreenViewModelInput get input => this;

  @override
  MovieDetailsScreenViewModelOutput get output => this;

  @override
  void dispose() {}

  @override
  late final Stream<MovieModel> movieModel;

  @override
  void init(String id) {
    _initTrigger.add(id);
  }

  @override
  void addToFavorite(String id) {
    _addToFavoriteTrigger.add(id);
  }
}
