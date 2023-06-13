import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {

  //Creamos una instancia del getnowplaying del repositorio
  final fetchMoreMovies = ref.watch( movieReposityProvider ).getNowPlaying;

  //devolvemos el notificador y le pasamos por parámetreo la funcion
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});


final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {

  //Creamos una instancia del getnowplaying del repositorio
  final fetchMoreMovies = ref.watch( movieReposityProvider ).getPopular;

  //devolvemos el notificador y le pasamos por parámetreo la funcion
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});


final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {

  //Creamos una instancia del getnowplaying del repositorio
  final fetchMoreMovies = ref.watch( movieReposityProvider ).getTopRated;

  //devolvemos el notificador y le pasamos por parámetreo la funcion
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});


final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {

  //Creamos una instancia del getnowplaying del repositorio
  final fetchMoreMovies = ref.watch( movieReposityProvider ).getUpcoming;

  //devolvemos el notificador y le pasamos por parámetreo la funcion
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});


//declaramos una funcion callback del mismo tipo que getnowplaying
typedef MovieCallback = Future<List<Movie>> Function({ int page });


class MoviesNotifier extends StateNotifier<List<Movie>> {
  
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  //recibe por parámetro la funcion
  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);

  //Estafuncion llama al getnowplayin del repositorie, le pasa el page y actualiza el estado.
  Future<void> loadNextPage() async{

    if(isLoading) return;
    
    isLoading = true;
    currentPage++;   
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    

    //sumamos la lista de peliculas del estado + la nueva lista de peliculas
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }


}