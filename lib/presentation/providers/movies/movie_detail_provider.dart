
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Vamos a guardar los datos de un objeto pelicula en este caso en caché, para ello creamos un provider que va a manejar un mapa de tipos String (que sera el id de la pelicula), Movie (que será el objeto de la pelicula)


final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
    final getMovie = ref.watch(movieReposityProvider).getMovieById;
    return MovieMapNotifier(getMovie: getMovie);
});

typedef GetMovieCallback = Future<Movie>Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>>{

  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie
    }): super({});

  //Ahora, a la hora de pedir la peliculas comprobamos que no exista ya dentro del estado
  Future<void> loadMovie(String movieId) async{
    if ( state[movieId] != null ) return;
    final movie = await getMovie(movieId);
    state = { ...state, movieId: movie };

  }

}