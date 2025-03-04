import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_task/models/view_models/account_screen_view_model.dart';
import 'package:movies_task/models/view_models/login_screen_view_model.dart';
import 'package:movies_task/models/view_models/movie_details_screen_view_model.dart';
import 'package:movies_task/models/view_models/movie_list_screen_view_model.dart';
import 'package:movies_task/repositories/movie_repository.dart';
import 'package:movies_task/services/firebase_service.dart';
import 'package:movies_task/services/movie_service.dart';
import 'package:movies_task/services/network_services/http_client.dart';
import 'package:movies_task/services/network_services/movie_api.dart';

class DI {
  DI._();

  static T resolve<T extends Object>() => GetIt.instance<T>();

  static Future<void> initialize() async {
    await _registerApis();
    _registerRepositories();
    _registerServices();
    _registerViewModels();
  }

  static Future<void> _registerApis() async {
    GetIt.instance
      ..registerSingleton(
        HttpClient(baseUrl: 'https://raw.githubusercontent.com/'),
      )
      ..registerSingleton(MovieApi(resolve()));
  }

  static Future<void> _registerRepositories() async {
    GetIt.instance
      ..registerSingleton(MovieRepository(movieApi: resolve()))
      ..registerSingleton(FirebaseService(firebaseAuth: FirebaseAuth.instance));
  }

  static Future<void> _registerServices() async {
    GetIt.instance.registerSingleton(MovieService(movieRepository: resolve()));
  }

  static Future<void> _registerViewModels() async {
    GetIt.instance
      ..registerFactory<MovieListViewModelViewModelType>(
        () => MovieListViewModelViewModel(resolve()),
      )
      ..registerFactory<MovieDetailsScreenViewModelType>(
        () => MovieDetailsScreenViewModel(resolve()),
      )
      ..registerFactory<LoginScreenViewModelType>(
        () => LoginScreenViewModel(resolve()),
      )
      ..registerFactory<AccountScreenViewModelType>(
        () => AccountScreenViewModel(resolve()),
      );
  }
}
