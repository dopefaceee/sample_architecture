import 'package:sample_architecture/src/models/tmdb_movie_basic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tmdb_movies_response.g.dart';

//requirement can be found at https://api.themoviedb.org/3/movie/now_playing?api_key=c47371c6f2992426c23cd74ec56dbc26&language=en-US&page=1&region=id
@JsonSerializable()
class TMDBMoviesResponse {
  int page;
  List<TMDBMovieBasic> results;
  @JsonKey(name: "total_results")
  int totalResults;
  @JsonKey(name: "total_pages")
  int totalPages;
  @JsonKey(name: "errors")
  List<String> errors;

  TMDBMoviesResponse({this.page, this.totalResults, this.totalPages, this.results, this.errors});
  bool get isEmpty => !hasResults();

  hasResults() {
    return results != null && results.length > 0;
  }

  hasErrors() {
    return errors != null && errors.length > 0;
  }

  factory TMDBMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$TMDBMoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TMDBMoviesResponseToJson(this);
}