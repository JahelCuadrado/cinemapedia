import 'package:flutter/material.dart';

class CustomButtomNavigation extends StatelessWidget {
  const CustomButtomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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