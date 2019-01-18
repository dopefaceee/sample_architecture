import 'package:flutter/material.dart';
import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:sample_architecture/src/blocs/movie_bloc.dart';
import 'package:sample_architecture/src/models/tmdb_movie_basic.dart';
import 'package:sample_architecture/src/screens/movies_state.dart';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';
import 'package:sample_architecture/src/widgets/movie_list_widget.dart';
import 'package:sample_architecture/src/widgets/state_widget/loading_widget.dart';
import 'package:sample_architecture/src/widgets/state_widget/empty_widget.dart';
import 'package:sample_architecture/src/widgets/state_widget/error_widget.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();

  StreamBuilder<MoviesState> buildStreamBuilder(
      BuildContext context, MovieBloc movieBloc, TabKey tabKey, int tabIndex ) {
    return StreamBuilder(
        key: Key('streamBuilder'),
        stream: movieBloc.stream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  key: Key('content'),
                  children: <Widget>[
                    //Insert loading state below

                    EmptyWidget(visible: data is MoviesEmpty),

                    LoadingWidget(
                      visible: data is MoviesLoading,
                    ),

                    ErrorsWidget(
                        visible: data is MoviesError,
                        error: data is MoviesError ? data.error : ""),

                    MovieListWidget(
                        movieBloc: movieBloc,
                        tabKey: tabKey,
                        movies: data is MoviesPopulated ? getMovies(data, movieBloc, tabKey) : []),
                  ],
                ),
              )
            ],
          );
        });
  }

  List<TMDBMovieBasic> getMovies(MoviesPopulated data, MovieBloc movieBloc, TabKey tabKey) {
    return data.movies;
  }
}

class _MovieScreenState extends State<MovieScreen> {
  MovieBloc movieBloc;

  @override
  Widget build(BuildContext context) {
    movieBloc = BlocProvider.of<MovieBloc>(context);

    return Column(key: Key("rootColumn"), children: [
      Flexible(
        child: widget.buildStreamBuilder(
          context,
          movieBloc,
          movieBloc.tabKey,
          movieBloc.tabKey.index,
        ),
      ),
    ]);
  }
}