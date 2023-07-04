

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    

    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [

        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const CupertinoPage(child: HomeView());
          },
          routes: [
            
              GoRoute(
                path: 'movie/:id',
                name: MovieScreen.name,
                pageBuilder: (context, state) {

                  //Extraemos el id de los parámetros de la ruta          
                  final movieId = state.pathParameters['id'] ?? 'no-id';

                  //creamos la pantalla con el id
                  return CupertinoPage(child: MovieScreen(movieId: movieId));
                } 
              ),
          ]
          ),

        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) {
            return const CupertinoPage(child: FavoritesView());
          },
          ),

      ]
    ),


    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   pageBuilder: (context, state) => const CupertinoPage(
    //     child: HomeScreen(childView: FavoritesView(),) //tod shellroutes 2
    //     ),

    //   //Guardamos dentro del parámetros routes todas las rutas hijas
    //   routes: [

        // GoRoute(
        //   path: 'movie/:id',
        //   name: MovieScreen.name,
        //   pageBuilder: (context, state) {

        //     //Extraemos el id de los parámetros de la ruta          
        //     final movieId = state.pathParameters['id'] ?? 'no-id';

        //     //creamos la pantalla con el id
        //     return CupertinoPage(child: MovieScreen(movieId: movieId));
        //   } 
        // ),
        
    //   ]
    //   ),
    


  ]
  );