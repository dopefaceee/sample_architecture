import 'package:sample_architecture/src/data/constants/api_constants.dart';
import 'package:sample_architecture/src/data/constants/api_secrets.dart';

class Endpoints {

  ///define nowplaying endpoints
  static String nowPlayingMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/now_playing?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

}