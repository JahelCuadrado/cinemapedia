

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      pageBuilder: (context, state) => const CupertinoPage(child: HomeScreen()),
      )

  ]
  );