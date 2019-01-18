import 'package:flutter/material.dart';
import 'package:sample_architecture/src/models/tmdb_movie_basic.dart';
import 'package:sample_architecture/src/blocs/movie_bloc.dart';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';
import 'package:sample_architecture/src/widgets/list_controller.dart';

class MovieListWidget extends StatefulWidget {
  final List<TMDBMovieBasic> movies;
  final TabKey tabKey;
  final MovieBloc movieBloc;

  MovieListWidget({Key key, @required this.movies,@required this.tabKey, @required this.movieBloc})
      : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  ListController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ListController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 2000 &&
        !_scrollController.isPaused) {
      this.widget.movieBloc.nextPage.add(this.widget.tabKey); //If there are more than 1 Tab, use like this add(this.widget.TabKey)
      _scrollController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.unPause();

    return ListView.builder(
      controller: _scrollController,
      itemCount: this.widget.movies.length,
      itemBuilder: (context, index) {
        final movie = this.widget.movies[index];
        print("Movie number $index");
        return Container(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      movie.title,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
