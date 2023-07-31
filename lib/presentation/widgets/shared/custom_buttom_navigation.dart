import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigation extends StatelessWidget {

  final int currentIndex;

  const CustomButtomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index){

    // switch (index) {
    //   case 0:
    //     context.go('/home/0');
    //     break;

    //   case 1:
    //     context.go('/home/1');
    //     break;

    //   case 2:
    //     context.go('/home/2');
    //     break;
    // }

    // print('/home/$index');

    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      items: const [

        BottomNavigationBarItem(
          label: 'Inicio',
          icon: Icon(Icons.home_max_outlined)
          ),

        BottomNavigationBarItem(
          label: 'Populares',
          icon: Icon(Icons.whatshot_outlined)
          ),

        BottomNavigationBarItem(
          label: 'Favoritos',
          icon: Icon(Icons.favorite_border_outlined)
          )

      ],
    );
  }
}