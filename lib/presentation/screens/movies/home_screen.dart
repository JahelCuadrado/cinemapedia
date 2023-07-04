import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  static const String name = 'home-screen';
  final Widget childView; //todo shellroutes 1

  const HomeScreen({
    super.key, 
    required this.childView
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: const CustomButtomNavigation(),
    );
  }
}