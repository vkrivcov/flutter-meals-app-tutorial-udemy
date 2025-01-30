import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/widgets/meal_item.dart';

import '../models/meal.dart';
import 'meal_details.dart';

class MealsScreen extends StatelessWidget {
  // NOTE: pay attention to title as its optional here
  const MealsScreen(
      {super.key,
      this.title,
      required this.meals,
      required this.onToggleFavourite});

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavourite;

  void _onSelectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      // MaterialPageRoute is a route that will take you to a new screen and it
      // will be top most screen that users will see
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
          onToggleFavourite: onToggleFavourite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) => MealItem(
              meal: meals[index],
              onSelectMeal: () {
                _onSelectMeal(ctx, meals[index]);
              },
            ));

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Uh oh ... nothing here",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
            SizedBox(height: 16),
            Text(
              "Try selecting a different category",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            )
          ],
        ),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
        appBar: AppBar(title: Text(title!)),

        // ListView.builder is useful when you have a long list, as well as it
        // will be more efficient than ListView
        body: content);
  }
}
