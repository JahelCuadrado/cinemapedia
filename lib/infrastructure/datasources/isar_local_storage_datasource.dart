

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarLocalStorageDatasource extends LocalStorageDatasource{

  //Es un future porque la base de datos tiene que estar lista antes de manejar una base de datos.
  late Future<Isar> db; //TODO database 1

  IsarLocalStorageDatasource(){ //TODO database 2
  //Inicializamos la base de datos
   db = openDB();
  }

  Future<Isar> openDB() async{ //TODO database 3

    //obtenemos gracias al paquete path_provider el directorio de datos por defecto de la aplaicación
    final dir = await getApplicationDocumentsDirectory();

    //comprobamos que no existe ninguna instancia de la bbdd
    if (Isar.instanceNames.isEmpty) {

      //Si no existe ninguna instancia se abre una nueva instancia de la BBDD, a esta instancia se le indica el Squema con el que vamos a trabajar, en este caso le enviamos el squema de nuestra instancia, el que se creó con el comando, despues habilitamos el inspector (Esto permitirá acceder y utilizar el inspector para analizar y examinar la base de datos Isar.) y le pasamos el directorio donde se va a guardar la bbdd
      return await Isar.open(
        [MovieSchema],
        inspector: true,
        directory: dir.path
        );
    }

    //En caso de que si existiese una instancia de la base de dato se obtiene y se devuelve esta.
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
  
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies
    .filter()
    .idEqualTo(movieId)
    .findFirst();


    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
        
    final isar = await db;

    return isar.movies.where()
    .offset(offset)
    .limit(limit)
    .findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {

    final isar = await db;

    final favoriteMovie = await isar.movies
    .filter()
    .idEqualTo(movie.id)
    .findFirst();

    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarIid!));
    }

    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }

}