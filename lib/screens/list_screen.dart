import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_task/di/di.dart';
import 'package:movies_task/extensions/list_extenstion.dart';
import 'package:movies_task/models/view_models/movie_list_screen_view_model.dart';
import 'package:movies_task/widgets/movie_list_item.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final MovieListViewModelViewModelType _viewModel = DI.resolve();
  @override
  void initState() {
    _viewModel.input.initLoad();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies')),
      body: StreamBuilder(
        stream: _viewModel.output.movieModels,
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
                      context.push('/list/movies/${movieModel.id}');
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
