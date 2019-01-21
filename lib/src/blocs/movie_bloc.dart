import 'dart:async';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';
import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:sample_architecture/src/models/tmdb_movies_response.dart';
import 'package:sample_architecture/src/data/api/tmdb_api.dart';
import 'package:sample_architecture/src/models/tmdb_movie_basic.dart';
import 'package:sample_architecture/src/screens/movies_state.dart';
import 'package:intl/intl.dart';

///movie bloc class
class MovieBloc extends BlocBase {
  ///define which api to used
  TMDBApi api;
  ///initial page
  int page = 0;
  ///define region movie
  String region;

  ///init moviespopulated with empty array
  MoviesPopulated moviesPopulated = MoviesPopulated([]);

  ///init tabkey
  TabKey tabKey;

  ///multiple subscribe using broadcast
  final _streamController = StreamController<MoviesState>.broadcast();

  ///sink for moviestate
  Sink<MoviesState> get sink => _streamController.sink;

  ///stream getter
  Stream<MoviesState> get stream => _streamController.stream;

  final _nextPageController = StreamController();

  ///sink for nextpage
  Sink get nextPage => _nextPageController.sink;

  ///movie bloc constructor
  MovieBloc({this.api, this.tabKey, this.region}) {
    _nextPageController.stream.listen(fetchNextPage);
    init();
  }

  ///init method
  void init() {
    if (page == 0) {
      fetchNextPage();
    }
  }

  ///fetch next page
  void fetchNextPage([event]) {
    fetchMoviesFromNetwork();
  }

  ///fetch data
  void fetchMoviesFromNetwork() async {
    if (_hasNoExistingData()) {
      sink.add(MoviesLoading());
    }

    page += 1;
    try {
      final result = await _getApiCall(page);
      if (result.isEmpty && _hasNoExistingData()) {
        sink.add(MoviesEmpty());
      } else {
        moviesPopulated.update(newMovies: result.results);
        sink.add(moviesPopulated);
      }
    } on Exception catch (e) {
      print('error $e');
      sink.add(MoviesError(e.toString()));
    }
  }

  ///sort movie by release date
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

  ///define which state is running
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
