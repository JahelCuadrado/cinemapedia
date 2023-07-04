import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigation extends StatelessWidget {

  const CustomButtomNavigation({super.key});

  int getCurrentIndex(BuildContext context){

    final String location = GoRouterState.of(context).location;

    switch (location) {

      case '/':
        return 0;

      case '/categories':
        return 1;

      case '/favorites':
        return 2;

      default:
        return 0;


    }
  }

  void onItemTap(BuildContext context, int index){

    switch (index) {
      case 0:
        context.go('/');
      break;
      case 1:
        context.go('/categories');
      break;
      case 2:
        context.go('/favorites');
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTap(context, value),
      items: const [

        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home_max_outlined)
          ),

        BottomNavigationBarItem(
          label: 'Categories',
          icon: Icon(Icons.category_outlined)
          ),

        BottomNavigationBarItem(
          label: 'Favoritos',
          icon: Icon(Icons.favorite_border_outlined)
          )

      ],
    );
  }
}