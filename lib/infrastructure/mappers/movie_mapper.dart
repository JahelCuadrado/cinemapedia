import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {

  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
      : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
      : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
      );

  static Movie movieDetailsToEntity(MovieDbDetailsResponse movieDetail) => Movie(
      adult: movieDetail.adult,
      backdropPath: (movieDetail.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath}'
      : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg',
      genreIds: movieDetail.genres.map((e) => e.name).toList(),
      id: movieDetail.id,
      originalLanguage: movieDetail.originalLanguage,
      originalTitle: movieDetail.originalTitle,
      overview: movieDetail.overview,
      popularity: movieDetail.popularity,
      posterPath: (movieDetail.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${movieDetail.posterPath}'
      : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg',
      releaseDate: movieDetail.releaseDate,
      title: movieDetail.title,
      video: movieDetail.video,
      voteAverage: movieDetail.voteAverage,
      voteCount: movieDetail.voteCount
      );

}
