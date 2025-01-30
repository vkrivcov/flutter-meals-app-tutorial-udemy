import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/data/dummy_dart.dart';
import 'package:flutter_meals_app_tutorial_udemy/models/category.dart';
import 'package:flutter_meals_app_tutorial_udemy/screens/meals.dart';
import 'package:flutter_meals_app_tutorial_udemy/widgets/category_grid_item.dart';

import '../models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.onToggleFavourite, required this.availableMeals});

  final void Function(Meal meal) onToggleFavourite;

  // meals after selecting filters
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {
    // get the meals that we want using where statement, that essentially
    // match a specific condition
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      // MaterialPageRoute is a route that will take you to a new screen and it
      // will be top most screen that users will see
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavourite: onToggleFavourite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // its quite common for different screens to use Scaffold widget for its
    // own styling (e.g. there might be different app bars, floating action
    // buttons, etc.) => note its been removed as its now controlled by TabsScreen
    // GridView.builder is useful when you have a long list and it will nicely
    // distribute everything in a grid view
    return GridView(
      padding: const EdgeInsets.all(16), // some padding around the grid

      // essentially it its just setting number of columns
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20, // some spacing between columns
          mainAxisSpacing: 10 // some spacing between rows
          ),
      children: [
        ...availableCategories.map(
          (category) => CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          ),
        ),

        // alternative way would be
        // for(final category in availableCategories)
        //   CategoryGridItem(category: category)
      ],
    );
  }
}
