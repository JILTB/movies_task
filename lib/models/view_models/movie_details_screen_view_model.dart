import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/models/view_models/base_view_model.dart';
import 'package:movies_task/services/firebase_service.dart';
import 'package:movies_task/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';

abstract class MovieDetailsScreenViewModelInput {
  void init(String id);

  void addToFavorite(String id);

  void removeFromFavotire(String id);
}

abstract class MovieDetailsScreenViewModelOutput {
  Stream<MovieModel> get movieModel;

  Stream<bool> get isAddedToFav;
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
  MovieDetailsScreenViewModel(this._movieService, this._firebaseService) {
    movieModel = _movieService.movieCache
        .map((list) {
          return list.firstWhere(
            (movieModel) => movieModel.id == _initTrigger.value,
          );
        })
        .shareReplay(maxSize: 1);

    isAddedToFav = Rx.combineLatest2(
      _firebaseService.getLikedMovies(),
      _initTrigger,
      (likedMovies, currentMovieId) {
        return likedMovies.contains(currentMovieId);
      },
    ).shareReplay(maxSize: 1);

    _addToFavoriteTrigger
        .map((movieId) => _firebaseService.likeMovie(movieId))
        .publish()
        .connect()
        .addTo(_subscription);

    _removeFromFavoriteTrigger
        .map((movieId) => _firebaseService.unlikeMovie(movieId))
        .publish()
        .connect()
        .addTo(_subscription);
  }

  final MovieService _movieService;
  final FirebaseService _firebaseService;
  final _initTrigger = BehaviorSubject<String>();
  final _addToFavoriteTrigger = BehaviorSubject<String>();
  final _removeFromFavoriteTrigger = BehaviorSubject<String>();
  final _subscription = CompositeSubscription();
  @override
  MovieDetailsScreenViewModelInput get input => this;

  @override
  MovieDetailsScreenViewModelOutput get output => this;

  @override
  void dispose() {
    _subscription.dispose();
  }

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

  @override
  late final Stream<bool> isAddedToFav;

  @override
  void removeFromFavotire(String id) {
    _removeFromFavoriteTrigger.add(id);
  }
}
