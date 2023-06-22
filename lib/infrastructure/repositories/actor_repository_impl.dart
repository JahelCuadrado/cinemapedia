

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repositorie.dart';

class ActorRepositoryImpl extends ActorsRepository{

  final ActorsDatasource datasource;

  ActorRepositoryImpl({
    required this.datasource
  });

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }



}