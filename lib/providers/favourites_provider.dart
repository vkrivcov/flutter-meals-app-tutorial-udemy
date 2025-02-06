import 'package:flutter_meals_app_tutorial_udemy/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// used in tandem with StateNotifierProvider (below), convention is to end it
// with XxNotifier
class FavouritesMealsNotifier extends StateNotifier<List<Meal>> {
  // set the initial value to the provider and initially we are setting an empty
  // list of meals
  // IMPORTANT: please bare in mind -> we should NEVER change the value of the
  // initial list i.e. [] that is passed to super in this case
  // NOTE: generally you are not allowed to edit a value in memory as we did
  // before but instead replace it every time
  FavouritesMealsNotifier() : super([]);

  bool toggleMealFavouriteStatus(Meal meal) {
    final mealIsFavourite = state.contains(meal);

    if (mealIsFavourite) {
      state = state.where((m) => m.id != meal.id).toList();

      // return false if the item was removed
      return false;
    } else {
      // ...spread operator -> essentially loops over all the meals and taking
      // them one by one
      state = [...state, meal];

      // return true if item was added
      return true;
    }

    // state is a globally available properly
    // state = [];

  }
}

// StateNotifierProvider optimised for the data that can change
// NOTE: it does not know the type of data that is returned therefore we need
// to explicitly tell what is it
final favouriteMealsProvider = StateNotifierProvider<FavouritesMealsNotifier, List<Meal>>((ref) {
  return FavouritesMealsNotifier();
});