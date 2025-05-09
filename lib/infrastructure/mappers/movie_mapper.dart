


import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {

  static Movie movieDBToEntity(MovieMovieDB movieDb) => Movie(
    adult: movieDb.adult,
    backdropPath: (movieDb.backdropPath != '') 
    ? 'https://image.tmdb.org/t/p/w500${movieDb.backdropPath}' 
    : 'https://ih1.redbubble.net/image.4905811447.8675/flat,450x,075,f-pad,450x450,f8f8f8.jpg',
    genreIds: movieDb.genreIds.map((e)=> e.toString()).toList(),
    id: movieDb.id,
    originalLanguage: movieDb.originalLanguage,
    originalTitle: movieDb.originalTitle,
    overview: movieDb.overview,
    popularity: movieDb.popularity,
    posterPath: (movieDb.posterPath != '')
    ? 'https://image.tmdb.org/t/p/w500${movieDb.posterPath}'
    : 'https://ih1.redbubble.net/image.4905811447.8675/flat,450x,075,f-pad,450x450,f8f8f8.jpg',
    releaseDate: movieDb.releaseDate != null ? movieDb.releaseDate! : DateTime.now(),
    title: movieDb.title,
    video: movieDb.video,
    voteAverage: movieDb.voteAverage,
    voteCount: movieDb.voteCount,
  );


  static Movie movieDetailsToEntity(MovieDetails movieDb) => Movie(
    adult: movieDb.adult,
    backdropPath: (movieDb.backdropPath != '') 
    ? 'https://image.tmdb.org/t/p/w500${movieDb.backdropPath}' 
    : 'https://ih1.redbubble.net/image.4905811447.8675/flat,450x,075,f-pad,450x450,f8f8f8.jpg',
    genreIds: movieDb.genres.map((e)=> e.name).toList(),
    id: movieDb.id,
    originalLanguage: movieDb.originalLanguage,
    originalTitle: movieDb.originalTitle,
    overview: movieDb.overview,
    popularity: movieDb.popularity,
    posterPath: (movieDb.posterPath != '')
    ? 'https://image.tmdb.org/t/p/w500${movieDb.posterPath}'
    : 'https://ih1.redbubble.net/image.4905811447.8675/flat,450x,075,f-pad,450x450,f8f8f8.jpg',
    releaseDate: movieDb.releaseDate,
    title: movieDb.title,
    video: movieDb.video,
    voteAverage: movieDb.voteAverage,
    voteCount: movieDb.voteCount,
  );
}