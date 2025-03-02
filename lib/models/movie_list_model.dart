import 'dart:convert';

import 'package:movies_task/models/movie_model.dart';

class MovieListModel {
  MovieListModel({required this.movies});
  final List<MovieModel> movies;

  factory MovieListModel.fromJson(dynamic json) {
    List<dynamic> jsonList = jsonDecode(json);
    return MovieListModel(
      movies:
          jsonList
              .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
              .toList(),
    );
  }
}
