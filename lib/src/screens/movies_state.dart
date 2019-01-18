import 'package:sample_architecture/src/models/tmdb_movie_basic.dart';

class MoviesState {
  MoviesState();
}

class MoviesLoading extends MoviesState {}

class MoviesError extends MoviesState {
  final String error;
  MoviesError(this.error);
}

class MoviesNoResults extends MoviesState {}

class  MoviesPopulated extends MoviesState {
  final List<TMDBMovieBasic> movies;

  //Update movie when populated, like scroll down then hit bottom, append new movies to existing
  update({List<TMDBMovieBasic> newMovies}) {
    return this..movies.addAll(newMovies ?? this.movies);
  }

  MoviesPopulated(this.movies);

}

class MoviesEmpty extends MoviesState {}