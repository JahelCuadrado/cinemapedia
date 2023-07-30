import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_detail_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
    });

  @override
  MovieScreenState createState() => MovieScreenState();
}


class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActor(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    if (movie==null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2,)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(movie: movie,),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1
              )
            )
        ],
      )
    );
  }
}


class _MovieDetails extends StatelessWidget {

  final Movie movie;

  const _MovieDetails({
    required this.movie
    });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                  ),
                ),

                const SizedBox(width: 10,),

                SizedBox(
                  width: (size.width - 40) * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: textStyles.titleLarge,),
                      Text(movie.overview)
                    ],
                  ),
                  )
            ],
          ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              children: [
                ...movie.genreIds.map((e) => Container(
                  margin:  const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(e),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ))
              ],
            ),
          ),

          _ActorsByMovie(movieId: movie.id.toString()),


          const SizedBox(height: 100,)
        
      ],
    );
  }
}


class _ActorsByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2,);
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 5,),

                Text(actor.name, maxLines: 2,),

                Text(
                  actor.character ?? '', 
                  maxLines: 2, 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                    ),
                  ),

              ],
            ),
          );
        },
      ),
    );
  }
}

//.family se añade a cualquier provider para poder mandar un argumento
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {

  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});


class _CustomSliverAppbar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppbar({
    required this.movie,
  });

  @override
  Widget build(BuildContext context, ref) {

    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(onPressed: () async{
          
          //ref.read(localStorageRepositoryProvider).toggleFavorite(movie);

          await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);

          ref.invalidate(isFavoriteProvider(movie.id));



        }, icon: isFavoriteFuture.when(
          loading: ()=> const CircularProgressIndicator(strokeWidth: 2,),
          data: (isFavorite) => isFavorite
          ? const Icon(Icons.favorite_rounded, color: Colors.red,)
          : const Icon(Icons.favorite_border)
          , 
          error: (_,__) => throw UnimplementedError(), 

          ))
        
        //const Icon(Icons.favorite_border))
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),


            const _CustomGradient(
              begin: Alignment.topLeft, 
              stops:[0.0, 0.3], 
              colors: [
                      Colors.black87,
                      Colors.transparent,
                    ]
              ),


            const _CustomGradient(
              begin: Alignment.topRight, 
              stops:[0.0, 0.3], 
              colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
              end: Alignment.centerRight,
              ),



          ],
        ),
      ),
    );
  }
}


class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>      stops;
  final List<Color>       colors;

  const _CustomGradient({
    required this.begin, 
    required this.stops, 
    required this.colors, 
    this.end = Alignment.centerRight
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: begin,
                    end: end,
                    stops: stops,
                    colors: colors
                  )
                ),
              ),
            );
  }
}