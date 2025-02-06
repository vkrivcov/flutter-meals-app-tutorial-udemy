import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/data/dummy_dart.dart';
import 'package:flutter_meals_app_tutorial_udemy/models/category.dart';
import 'package:flutter_meals_app_tutorial_udemy/screens/meals.dart';
import 'package:flutter_meals_app_tutorial_udemy/widgets/category_grid_item.dart';

import '../models/meal.dart';

// NOTE: in order to use animations is has to extend StatefulWidget as when we
// add an explicit animation we must work with the state object as behind the
// scenes an animation set the state and change the state and every time its
// playing hence need to has a state
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  // meals after selecting filters
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// with is mixin i.e. another class merged into this class
// NOTE: not used often, only when really using explicit animations
// SingleTickerProviderStateMixin behind the scenes introduce bunch of animation
// features that are required for animation controller
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // late tells that value will be used as soon as it will be used, but not
  // right now
  late AnimationController _animationController;

  // animation controller must be set in init and before the build method would
  // be executed
  // NOTE: it will only be executed once so if we more between the screen stacks
  // the animation will not be played
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this, // refers to SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 300),

      // animation boundaries i.e. lets say animation is based on some margin
      // value and animation controller for the above Duration will move
      // between those values
      // 0 and 1 are default really and we add them for illustration purposes
      lowerBound: 0,
      upperBound: 1,
    );

    // IMPORTANT: by default animation will not be started hence we need to
    // start it
    _animationController.forward();
  }

  // aside of default parent cleanup we do a little big of our own cleanup here
  @override
  void dispose() {
    // its better to make sure that we wont cause any OOM etc. by explicitly
    // removing animation controller every time we leave the screen
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    // get the meals that we want using where statement, that essentially
    // match a specific condition
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      // MaterialPageRoute is a route that will take you to a new screen and it
      // will be top most screen that users will see
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(title: category.title, meals: filteredMeals),
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
    return AnimatedBuilder(
      animation: _animationController,

      // explicitly say what child should be animated as we typically DON'T want
      // to run animation 60 times per second (default) and only explicit
      // parts of it would be
      child: GridView(
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
      ),

      // over here we will add properties of a child that will be animated
      // where child referred to the child we declared above
      // NOTE: as mentioned before in here only padding of a child will be
      // rebuilt 60 times a second and NOT the whole GridView widget content
      // IMPORTANT: this works and looks not too bad, but there is a better way
      //   builder: (context, child) => Padding(
      //       // initially a padding is set to 100 and value of lowerBound is set to
      //       // 0 (i.e. 0 * 100), but after a ticker delay it will be 1 hence
      //       // 1 * 100 = 100 and 100 - 100 will be 0
      //       // in other words initially padding is set to 100 and after a delay
      //       // it will slide up to 0 by doing the calculations below
      //       padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //       child: child),
      // );
      // works exactly as above, but its more optimised and gives more features:
      // - animate gives more control of how the animation is played
      builder: (context, child) => SlideTransition(
          // essentially a tween of couple of values
          // position: _animationController.drive(
          //     Tween(
          //       begin: Offset(0, 0.6),  // x and y axis
          //       end: Offset(0, 0)
          //     )
          // ),

          // NOTE: there is also another way of doing it using .animate which
          // gives more control of how animation is played/feels
          position: Tween(
            begin: Offset(0, 0.6), // x and y axis
            end: Offset(0, 0),
          ).animate(
            // controls the way how the animation between 2 offsets will be
            // played over the available animation time
            CurvedAnimation(
              parent: _animationController,

              // this is what controls the visuals of the animation
              curve: Curves.easeInOut,
            ),
          ),
          child: child),
    );
  }
}
