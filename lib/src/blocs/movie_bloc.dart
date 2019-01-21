import 'dart:async';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';
import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:sample_architecture/src/models/tmdb_movies_response.dart';
import 'package:sample_architecture/src/data/api/tmdb_api.dart';
import 'package:sample_architecture/src/models/tmdb_movie_basic.dart';
import 'package:sample_architecture/src/screens/movies_state.dart';
import 'package:intl/intl.dart';

class MovieBloc extends BlocBase {
  TMDBApi api;
  int page = 0;
  String region;

  MoviesPopulated moviesPopulated = MoviesPopulated([]);

  TabKey tabKey;

  var _streamController = StreamController<MoviesState>.broadcast();
  Sink<MoviesState> get sink => _streamController.sink;

  Stream<MoviesState> get stream => _streamController.stream;

  final _nextPageController = StreamController();

  Sink get nextPage => _nextPageController.sink;

  MovieBloc({this.api, this.tabKey, this.region}) {
    _nextPageController.stream.listen(fetchNextPage);
    init();
  }

  void init() {
    if (page == 0) {
      fetchNextPage();
    }
  }

  fetchNextPage([event]) {
    fetchMoviesFromNetwork();
  }

  void fetchMoviesFromNetwork() async {
    if (_hasNoExistingData()) {
      this.sink.add(MoviesLoading());
    }

    page += 1;
    try {
      final result = await _getApiCall(page);
      if (result.isEmpty && _hasNoExistingData()) {
        this.sink.add(MoviesEmpty());
      } else {
        moviesPopulated.update(newMovies: result.results);
        this.sink.add(moviesPopulated);
      }
    } on Exception catch (e) {
      print('error $e');
      this.sink.add(MoviesError(e.toString()));
    }
  }

  List<TMDBMovieBasic> sortMoviesByReleaseDate() {
    moviesPopulated.movies.sort((a, b) {
      var releaseDateA = DateFormat("yyyy-M-dd").parse(a.releaseDate);
      var releaseDateB = DateFormat("yyyy-M-dd").parse(b.releaseDate);
      if (releaseDateA.isAfter(releaseDateB)) {
        return 1;
      } else if (releaseDateA.isBefore(releaseDateB)) {
        return -1;
      } else {
        return 0;
      }
    });

    return moviesPopulated.movies;
  }

  bool _hasNoExistingData() => moviesPopulated.movies?.isEmpty ?? true;

  void onPrintState(MoviesState state) {
    print("Current state should be $state");
  }

  Future<TMDBMoviesResponse> _getApiCall(int page) {
    Future<TMDBMoviesResponse> apiCall;
    switch (tabKey) {
      case TabKey.kNowPlaying:
        apiCall = api.nowPlayingMovies(page: page);
        break;
      default:
    }
    return apiCall;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    _nextPageController.close();
  }
}
