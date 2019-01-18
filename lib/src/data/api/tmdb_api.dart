import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:sample_architecture/src/models/tmdb_movies_response.dart';
import 'package:sample_architecture/src/data/api/endpoints.dart';

class TMDBApi {

  Future<TMDBMoviesResponse> nowPlayingMovies({int page}) async {
    final response = await _makeRequest(Endpoints.nowPlayingMoviesUrl(page));
    return TMDBMoviesResponse.fromJson(json.decode(response.body));
  }

  Future<http.Response> _makeRequest(String url) async {
    print("request to ----> " + url);
    return await http.get(url);
  }

}
