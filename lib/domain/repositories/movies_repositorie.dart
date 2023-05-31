
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieRepositorie{

  Future<List<Movie>> getNowPlaying({ int page = 1});

}