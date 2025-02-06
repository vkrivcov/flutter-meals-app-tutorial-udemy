// a screen that loads other embedded screens
// NOTE: this is a stateful widget as we want to manage the state of the tabs
import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/providers/favourites_provider.dart';
import 'package:flutter_meals_app_tutorial_udemy/providers/filters_provider.dart';
import 'package:flutter_meals_app_tutorial_udemy/screens/categories.dart';
import 'package:flutter_meals_app_tutorial_udemy/screens/meals.dart';
import 'package:flutter_meals_app_tutorial_udemy/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'filters_global_state.dart';  // we need to import it in the class object in order to use the state

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// IMPORTANT: we substituted StatefulWidget with ConsumerStatefulWidget which
// essentially tells that its still a stateful widget, but we want to "listen"
// for changes from the providers that we have enabled in the project
// NOTE: if it would be StatelessWidget then we would need to extend ConsumerWidget
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  // NOTE: instead of State we are using ConsumerState now
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  // NOTE: we are not using it anymore and that properly can now be removed
  // NOTE: not needed anymore as we are getting it from the provider
  // final List<Meal> _favouriteMeals = [];
  // Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // NOTE: all managed by riverpod now
  // void _toggleMealFavouritesStatus(Meal meal) {
  //   bool isExisting = _favouriteMeals.contains(meal);
  //
  //   // set state is needed here to actually rebuild the list of favourite meals
  //   // and hence update the UI
  //   if (isExisting) {
  //     setState(() {
  //       _favouriteMeals.remove(meal);
  //       _showInfoMessage("Meal is no longer a favourite");
  //     });
  //   } else {
  //     setState(() {
  //       _showInfoMessage("Marked as a favourite");
  //       _favouriteMeals.add(meal);
  //     });
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // we pass a pointer to this function to the MainDrawer widget so we can
  // execute it from this class as we store the state here of favourites etc.
  // async + await is needed here are results are not returned immediately as
  // user can select filters after some time so essentially working with futures
  // and will wait for those results to be returned back
  void _setScreen(String identifier) async {
    // pop anything that is on top of the stack (in this case an open drawer)
    Navigator.of(context).pop();

    if (identifier == "filters") {
      // NOTE: this is a typical way of putting another screen on top of the
      // stack and it will allow navigation back to the previous screen using
      // a back button on the device
      // NOTE: <Map<Filter, bool>> is there to tell that we are returning
      // specifically that type to the final results variable

      // NOTE: below is a previous version of how we listened for returned data
      // from filters
      // final result = await Navigator.of(context).push<Map<Filter, bool>>(
      //   MaterialPageRoute(
      //     builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters,),
      //   ),
      // );

      // new way of just setting the screen ans state will be handled there
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(),
        ),
      );

      // NOTE: we are also not managing state here like this anymore and
      // everything is done using a provider
      // we want to update the state here
      // setState(() {
      //   // since results could be null we want to set a default (i.e. ??) if
      //   // that would be the case
      //   _selectedFilters = result ?? kInitialFilters;
      // });

      // BUT if you want to REPLACE the screen and will not really allow users
      // to go back to the previous screen then use pushReplacement
      // IMPORTANT: if there was NO screen before that one is WILL actually
      // close the app and in reality we don't want that
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (ctx) => const FiltersScreen(),
      //   ),
      // );
    }
    // NOTE: no need to execute this as we are already on the categories screen
    // and pop in the beginning of the function will close the drawer
    // else {
    //   // since we will go to the categories as a other identifier then we will
    //   // just close the drawer
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: ref (riverpod property_ is essentially a listener to the provider
    // there are 2 options:
    // - read to reads the properties of the provider
    // - watch to listen to the change to the build is triggered automatically
    // IMPORTANT: official riverpod documentation suggests that we .watch as
    // much as possible
    // below we setup a listener to the mealsProvider so the build would be
    // executed when mealsProvider would change

    // NOTE: now instead of this we will use a chained provider that we
    // implemented in filters_provider and has access to both meals and selected
    // filters
    // final meals = ref.watch(mealsProvider);
    // final availableFilters = ref.watch(filtersProvider);
    final availableMeals = ref.watch(filteredMealsProvider);

    // default is a categories screen
    Widget activePage = CategoriesScreen(
      // NOTE: state function is not passed anymore here as state is by riverpod
      // onToggleFavourite: _toggleMealFavouritesStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    // essentially refers to Favourites BottomNavigationBarItem as index 0
    // is Categories BottomNavigationBarItem
    if (_selectedPageIndex == 1) {
      // add a provider watcher here
      final favouriteMeals = ref.watch(favouriteMealsProvider);

      // NOTE: we are not passing any title here so App bar will not be shown
      // on the meals screen
      activePage = MealsScreen(
        meals: favouriteMeals,
        // NOTE: state function is not passed anymore here as state is by riverpod
        // onToggleFavourite: _toggleMealFavouritesStatus,
      );
      activePageTitle = "Your Favourites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),

      // drawer IS PER screen, same as app bar
      drawer: MainDrawer(
        onSelectedScreen: _setScreen,
      ),

      body: activePage,

      // a super common widget that is used to navigate between different screens
      bottomNavigationBar: BottomNavigationBar(
        // index will be passed to the function
        onTap: _selectPage,

        // controls the state and highlight the selected tab
        currentIndex: _selectedPageIndex,

        // essentially the same as a ListView.builder, but for tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
