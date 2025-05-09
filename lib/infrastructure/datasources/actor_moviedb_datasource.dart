


import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';


class ActorMoviedbDatasource extends ActorsDatasource {
    final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'es-MX'
    }
  ));


  List<Actor> _jsonToActors(Map<String,dynamic> json) {

    final actorDBResponse = CreditsResponse.fromJson(json);
    final List<Actor> movies = 
    actorDBResponse.cast
    .where((actor) => actor.profilePath != 'no-poster')
    .map((e)=> ActorMapper.castToEntity(e) ).toList();

    return movies;
  }
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActors(response.data);
  }

}