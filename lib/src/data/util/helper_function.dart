import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:sample_architecture/src/blocs/movie_bloc.dart';
import 'package:sample_architecture/src/data/api/tmdb_api.dart';
import 'package:sample_architecture/src/screens/movie_screen.dart';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';

BlocProvider<MovieBloc> getNowPlayingProvider() {
  return BlocProvider<MovieBloc>(
    child: MovieScreen(),
    bloc: MovieBloc(api: TMDBApi(), tabKey: TabKey.kNowPlaying),
  );
}

