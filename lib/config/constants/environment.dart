
import 'package:flutter_dotenv/flutter_dotenv.dart';

//todo 2 variables de entorno
class Environment {

  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';

}