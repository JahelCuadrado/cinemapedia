import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';


//todo sistema de busqueda 2
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTime;

  SearchMovieDelegate({
    required this.searchMovies,
    this.initialMovies = const[]
  });


  void clearStreams(){
    debounceMovies.close();
  }


  void _onQueryChanged(String query) {

    isLoadingStream.add(true);

    if (_debounceTime?.isActive ?? false) _debounceTime!.cancel();

    _debounceTime = Timer(const Duration(milliseconds: 500), () async {

    final movies = await searchMovies(query);
    initialMovies = movies;
    debounceMovies.add(movies);
    isLoadingStream.add(false);

    },);
  }



  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }



  @override
  String get searchFieldLabel => 'Buscar pelicula';

  //query es una variables global propia del search delegate que controla el contenido de la caja de texto de busqueda

  //botones a la derecha de la barra de busqueda, en este caso se muestra solo si la caja de busqueda tiene contenido, al pulsar se vacia
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

      StreamBuilder(
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          
          if(snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(onPressed: () {
                query = '';
              }, icon: const Icon(Icons.refresh_rounded)),
            );
          }

        return FadeIn(
        child: IconButton(onPressed: () {
          query = '';
        }, icon: const Icon(Icons.clear)),
      );
          

        },
      )

,



      
      ];
  }

  //leading son los iconos de la izquierda y close es una funcion propia de searchdelegate que cierra la pantalla de busqueda.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      clearStreams();
      close(context, null);
    }, icon: const Icon(Icons.arrow_back));
  }


  //Los results es el contenido que aparece cuando presionamos enter
  @override 
  Widget buildResults(BuildContext context) {    
    return buildResultsAndSuggestions();
  }


  //el suggestion es el contenido que aparece mientras estamos escribiendo
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
  
}


class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie, 
    required this.onMovieSelected
    });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath),
              ),
            ),
    
            const SizedBox(width: 10),
    
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium,),
    
                  (movie.overview.length > 100)
                   ? Text('${movie.overview.substring(0,100)}...')
                   : Text(movie.overview),
    
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      const SizedBox(width: 5,),
                      Text(
                        HumanFormats.humanReadableNumber(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(color:Colors.yellow.shade900 ),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}