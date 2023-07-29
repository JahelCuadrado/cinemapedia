

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

// Método para verificar si una película está marcada como favorita.
// Devuelve true si la película con el ID especificado es una favorita,
// o false si no lo es.
@override
Future<bool> isMovieFavorite(int movieId) async {
  // Obtener la instancia de la base de datos Isar.
  final isar = await db;

  // Realizar una consulta para buscar una película por su ID en la tabla "movies".
  final Movie? isFavoriteMovie = await isar.movies
      .filter() // Iniciar una consulta sin filtros específicos.
      .idEqualTo(movieId) // Agregar un filtro para buscar la película por su ID.
      .findFirst(); // Encontrar la primera película que cumple con los criterios de la consulta.

  // Devolver true si se encontró una película (es favorita), o false si no se encontró.
  return isFavoriteMovie != null;
}

// Método para cargar una lista de películas desde la base de datos.
// El método permite especificar un límite y un desplazamiento para paginar los resultados.
@override
Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
  // Obtener la instancia de la base de datos Isar.
  final isar = await db;

  // Realizar una consulta para obtener una lista de películas.
  // Se aplica el límite y el desplazamiento para paginar los resultados.
  return isar.movies.where().offset(offset).limit(limit).findAll();
}

// Método para alternar el estado de una película como favorita o no favorita.
@override
Future<void> toggleFavorite(Movie movie) async {
  // Obtener la instancia de la base de datos Isar.
  final isar = await db;

  // Verificar si la película ya está marcada como favorita.
  final favoriteMovie = await isar.movies
      .filter() // Iniciar una consulta sin filtros específicos.
      .idEqualTo(movie.id) // Agregar un filtro para buscar la película por su ID.
      .findFirst(); // Encontrar la primera película que cumple con los criterios de la consulta.

  // Si la película es una favorita, eliminarla de la tabla "movies".
  if (favoriteMovie != null) {
    isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarIid!));
  }

  // Si la película no es una favorita, agregarla a la tabla "movies".
  isar.writeTxnSync(() => isar.movies.putSync(movie));
}

}