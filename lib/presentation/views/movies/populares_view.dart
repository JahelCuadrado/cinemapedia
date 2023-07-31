import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularesView extends ConsumerStatefulWidget {
  const PopularesView({super.key});

  @override
  ConsumerState<PopularesView> createState() => _PopularesViewState();
}

class _PopularesViewState extends ConsumerState<PopularesView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final movies = ref.watch(popularMoviesProvider);

    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2,));
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage: ref.read(popularMoviesProvider.notifier).loadNextPage,
        movies: movies
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}