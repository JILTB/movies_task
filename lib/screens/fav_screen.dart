import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_task/di.dart';
import 'package:movies_task/list_extenstion.dart';
import 'package:movies_task/models/view_models/favorite_movies_screen_view_model.dart';
import 'package:movies_task/widgets/movie_list_item.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final FavoriteMoviesScreenViewModelType _viewModel = DI.resolve();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liked Movies')),
      body: StreamBuilder(
        stream: _viewModel.output.favoriteMovies,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                padding: EdgeInsets.only(left: 16, right: 16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movieModel = snapshot.data![index];
                  return MovieListItem(
                    title: movieModel.title,
                    imageUrl: movieModel.posterurl,
                    imdbRating: movieModel.imdbRating,
                    userRating:
                        (movieModel.ratings ?? []).calculateUserRating(),
                    onTap: () {
                      context.push('/fav/movies/${movieModel.id}');
                    },
                  );
                },
              )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
