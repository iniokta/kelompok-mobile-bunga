// Project: Kelompok Mobile Bunga

import 'package:flutter/material.dart';
import 'screens/recipe_list_screen.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelompok Mobile Bunga',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.pink,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const RecipeListScreen(),
    );
  }
}
