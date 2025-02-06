import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/providers/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/filter_item_global_state.dart';

// changed initial class of FilterScreen to demonstrate a global state
// management i.e. we will update filters in the provider and simply update the
// filters state here when something will change + we could switch extending
// to ConsumerWidget as we will NOT hold any local state
// NOTE: for simplicity there is an exact (and modified copy of this class)
class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return a provider watcher
    final activeFilters = ref.watch(filtersProvider);

    // return scaffold as its a new screen that will requite bits such as drawer
    // etc.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Filters"),
      ),

      // here we use it save and return the state of the switches so we can then
      // use them on the filters screen to actually filter the meals
      // other use-cases are to prevent back button from closing the screen etc.
      body:
        // we want to display a list of switches (useful widgets when you want to
        // switch them on/off (settings like alternative)
        Column(
          // ideally we want to outsource it, but to save time we will just copy
          // and paste it here
          children: [
            FilterItem(
              title: "Gluten-Free",
              subTitle: "Only include gluten-free meals.",
              initialFilterSelection: activeFilters[Filter.glutenFree]!,
              filter: Filter.glutenFree,
            ),
            FilterItem(
              title: "Lactose-Free",
              subTitle: "Only include lactose-free meals.",
              initialFilterSelection: activeFilters[Filter.lactoseFree]!,
              filter: Filter.lactoseFree,
            ),
            FilterItem(
              title: "Vegetarian",
              subTitle: "Only include vegetarian meals.",
              initialFilterSelection: activeFilters[Filter.vegetarian]!,
              filter: Filter.vegetarian,
            ),
            FilterItem(
              title: "Vegan",
              subTitle: "Only include Vegan meals.",
              initialFilterSelection: activeFilters[Filter.vegan]!,
              filter: Filter.vegan,
            ),
          ],
        ),
    );
  }
}
