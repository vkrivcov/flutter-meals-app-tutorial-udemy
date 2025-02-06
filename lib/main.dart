import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/screens/tabs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  // IMPORTANT: wrapping our app with ProviderScope is very important in order
  // to unlock BEHIND the scenes state management functionality and we are
  // essentially wrapping ALL of the widgets here -> entire all will use those
  // features BUT, if you know that only some nested parts of the app would need
  // that feature it would be sufficient to wrap only that part but here we want
  // to use everything
  runApp(const ProviderScope(
    child: App(),
  ));
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
