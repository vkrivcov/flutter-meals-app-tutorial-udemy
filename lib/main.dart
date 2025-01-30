import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/screens/tabs.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/categories.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,

      // good idea to test it separately here (temp testing)
      // home: MealsScreen(
      //   title: "Some category",
      //   meals: [],
      // )

      // initially we showed categories screen, but then created another
      // screen (tabs screen) to show categories and favourites and give
      // more options to the user
      // home: CategoriesScreen()
      home: const TabsScreen(),
    );
  }
}