
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
    final getActor = ref.watch(actorRepositoryProvider).getActorsByMovie;
    return ActorsByMovieNotifier(getActor: getActor);
});

typedef GetActordCallback = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>>{

  final GetActordCallback getActor;

  ActorsByMovieNotifier({
    required this.getActor
    }): super({});

  Future<void> loadActor(String movieId) async{
    if ( state[movieId] != null ) return;
    final List<Actor> actors = await getActor(movieId);
    state = { ...state, movieId: actors };

  }

}