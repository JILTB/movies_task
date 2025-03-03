import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movies_task/di.dart';
import 'package:movies_task/models/movie_model.dart';
import 'package:movies_task/models/view_models/movie_details_screen_view_model.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieDetailsScreenViewModelType _viewModel = DI.resolve();
  @override
  void initState() {
    _viewModel.input.init(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<MovieModel>(
        stream: _viewModel.output.movieModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();
          final movie = snapshot.data!;
          return Center(
            child: ListView(
              children: [
                if (movie.title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      movie.title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                if (movie.posterurl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: CachedNetworkImage(
                        imageUrl: movie.posterurl!,
                        errorWidget:
                            (context, url, error) =>
                                Icon(Symbols.no_photography),
                        progressIndicatorBuilder:
                            (context, url, progress) =>
                                CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                if (movie.imdbRating != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'imdb Rating: ${movie.imdbRating}',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'user rating: ${_calculateUserRating(movie.ratings ?? []).toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (movie.contentRating != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'content rating: ${movie.contentRating!}',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (movie.releaseDate != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      movie.releaseDate!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (movie.actors != null && movie.actors!.isNotEmpty)
                  ...movie.actors!.map(
                    (actor) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(actor, textAlign: TextAlign.center),
                    ),
                  ),
                if (movie.storyline != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(movie.storyline!, textAlign: TextAlign.center),
                  ),
                if (movie.genres != null && movie.genres!.isNotEmpty)
                  ...movie.genres!.map(
                    (genre) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(genre, textAlign: TextAlign.center),
                    ),
                  ),

                TextButton.icon(
                  style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                  onPressed: () {
                    _viewModel.input.addToFavorite(widget.id);
                  },
                  label: Text('Add to Favorite'),
                  icon: Icon(Symbols.heart_plus),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateUserRating(List<int> userRating) {
    if (userRating.isEmpty) return 0;
    return (userRating.reduce((a, b) => a + b) / userRating.length);
  }
}
