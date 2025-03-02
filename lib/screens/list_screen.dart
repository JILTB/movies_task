import 'package:flutter/material.dart';
import 'package:movies_task/di.dart';
import 'package:movies_task/models/view_models/movie_list_screen_view_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final MovieListViewModelViewModelType _viewModel = DI.resolve();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _viewModel.output.movieModels,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder:
                    (context, index) =>
                        ListTile(title: Text(snapshot.data![index].id)),
              )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
