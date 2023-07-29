import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO traer el nombre de las peliculas como tarea

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {

@override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Views'),
      ),
      body: ListView.builder(
        itemCount: favoritesMovies.length,
        itemBuilder: (context, index){

          final movie = favoritesMovies[index];

          return ListTile(
            title: 
            Text(movie.title)
            ,
          );
        }
        )
    );
  }
}