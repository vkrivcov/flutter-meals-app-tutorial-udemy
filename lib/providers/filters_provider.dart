import 'package:flutter_meals_app_tutorial_udemy/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}


class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  // initial state
  FiltersNotifier() : super({
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  });

  void setFilter(Filter filter, bool isActive) {
    // NOTE: as a reminder - original state is immutable and the following
    // if not allowed
    // state[filter] = isActive; // not allowed! => mutating state
    // ...state will explicitly copy the existing key and we will add a new key instead
    state = {
      ...state,
      filter: isActive
    };
  }

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) => FiltersNotifier());

// NOTE: if multiple providers are related to each other it does make sense to
// put them in one file, but its up to us if we want to do it
// in this case it will be a simple provider and not a state provider and we
// will chain couple of them together
final filteredMealsProvider = Provider((ref) {
  // ref in this case will allow us to read or watch providers
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  // this provider depends on w things:
  // - meals provider that never changes (but in theory it can change)
  // - filters provider (above)
  return meals.where((meal) {
    // if gluten free meal filter is set to true and mean is NOT gluten free,
    // THEN I don't want to include it
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    // we want to keep the meals that are not part of the above block
    return true;
  }).toList();
});