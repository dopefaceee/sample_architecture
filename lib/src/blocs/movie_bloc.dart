import 'dart:async';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';
import 'package:rxdart/rxdart.dart';
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

  //an instance of the MoviesPopulated state that will be used for each Bloc implementation
  MoviesPopulated moviesPopulated = MoviesPopulated([]);

  TabKey tabKey;

  // This is the internal object whose stream/sink is provided by this component
  var _streamController = BehaviorSubject<MoviesState>();
  //var _streamController = StreamController<MoviesState>.broadcast();

  // This is the stream of movies. Use this to show the contents
  Stream<MoviesState> get stream => _streamController.stream;

  final _nextPageController = StreamController();

  Sink get nextPage => _nextPageController.sink;

  MovieBloc({this.api, TabKey this.tabKey, String this.region}) {
    _nextPageController.stream.listen(fetchNextPage);
    init();
  }

  void init() {
    print('initialising bloc for $tabKey');//$tabKey
    _streamController = BehaviorSubject<MoviesState>();
    //q_streamController = StreamController<MoviesState>.broadcast();

    if (page == 0) {
      fetchNextPage();
    }
  }

  fetchNextPage([event]) {
    _streamController.addStream(fetchMoviesFromNetwork());
  }

  Stream<MoviesState> fetchMoviesFromNetwork() async* {
    if(_hasNoExistingData()) {
      yield MoviesLoading();
    }

    page += 1;
    try {
      final result = await _getApiCall(page);
      if (result.isEmpty && _hasNoExistingData()) {
        yield MoviesEmpty();
      } else {
        yield moviesPopulated.update(newMovies: result.results);
      }
    } catch (e) {
      print('error $e');
      yield MoviesError(e.toString());
    }
  }

  //sorts movies by release date in ascending order (i.e going from now to the future)
  List<TMDBMovieBasic> sortMoviesByReleaseDate() {
    moviesPopulated.movies.sort((a,b) {
      var releaseDateA = DateFormat("yyyy-M-dd").parse(a.releaseDate);
      var releaseDateB = DateFormat("yyyy-M-dd").parse(b.releaseDate);
      if(releaseDateA.isAfter(releaseDateB)) {
        return 1;
      }
      else if(releaseDateA.isBefore(releaseDateB)) {
        return -1;
      } else {
        return 0;
      }
    });

    return moviesPopulated.movies;

  }

  bool _hasNoExistingData() => moviesPopulated.movies?.isEmpty ?? true;

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