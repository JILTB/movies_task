import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/models/view_models/base_view_model.dart';
import 'package:movies_task/services/firebase_service.dart';
import 'package:movies_task/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';

abstract class FavoriteMoviesScreenViewModelInput {}

abstract class FavoriteMoviesScreenViewModelOutput {
  Stream<List<MovieModel>> get favoriteMovies;
}

abstract class FavoriteMoviesScreenViewModelType extends BaseViewModel {
  FavoriteMoviesScreenViewModelInput get input;

  FavoriteMoviesScreenViewModelOutput get output;
}

class FavoriteMoviesScreenViewModel
    implements
        FavoriteMoviesScreenViewModelInput,
        FavoriteMoviesScreenViewModelOutput,
        FavoriteMoviesScreenViewModelType {
  FavoriteMoviesScreenViewModel(this._firebaseService, this._movieService) {
    final likedMoviesId = _firebaseService.getLikedMovies().shareReplay(
      maxSize: 1,
    );

    final allMovies = _movieService.movieCache.shareReplay(maxSize: 1);

    favoriteMovies = Rx.combineLatest2(
      likedMoviesId,
      allMovies,
      (liked, all) => all.where((movie) => liked.contains(movie.id)).toList(),
    );
  }

  final FirebaseService _firebaseService;
  final MovieService _movieService;
  @override
  FavoriteMoviesScreenViewModelInput get input => this;

  @override
  FavoriteMoviesScreenViewModelOutput get output => this;

  @override
  void dispose() {}

  @override
  late final Stream<List<MovieModel>> favoriteMovies;
}
