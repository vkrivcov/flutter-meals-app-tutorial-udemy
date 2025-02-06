import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_meals_app_tutorial_udemy/models/meal.dart';
import 'package:flutter_meals_app_tutorial_udemy/providers/favourites_provider.dart';

// NOTE: this class uses an example of Explicit Animation for the Favourite icon
// while in Categories screen we used an Implicit animation where we build one
// from scratch
class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  // NOTE: in order to use riverpod provider we need to extend ConsumerWidget
  // class as well as pass WidgetRef argument
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // since we want to change different icons based on whether meals is in
    // favourite or not we will use the provider -> we simply check if meals
    // is a part of favourite meals
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final isFavourite = favouriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
              // IMPORTANT: we are adding an Explicit animation to the icon here
              // and in this case we only want to animate the Icon only and not
              // the whole button
              // AnimatedSwitcher allows to animate the transition from one widget
              // to another
              icon: AnimatedSwitcher(
                // child in this case is a Widget where we want to animate i.e.
                // out icon
                // animation in this case will be an explicit (will create one
                // behind the scenes) one and will come from AnimatedSwitcher
                transitionBuilder: (child, animation) {
                  // IMPORTANT: this return Transition widget will describe "how"
                  // you want to animate
                  return RotationTransition(
                    // by setting turns: animation is looks a bit wild as the
                    // default lowerBound = 0 and upperBound = 1 (as we seen
                    // in explicit animation
                    turns: Tween(
                      begin: 0.8,
                      end: 1.0
                    ).animate(animation),
                    child: child, // refers to current child which is our Icon
                  );
                },
                duration: const Duration(milliseconds: 300),

                // NOTE: for the animation "key" is important here as Flutter
                // is simply not able to understand what is really needs to be
                // animate as all it can see is Icon and then another Icon
                child: Icon(
                  isFavourite ? Icons.star : Icons.star_border,

                  // this will tell us whether its true or false and Flutter
                  // will actually see that something has changed here and will
                  // then trigger our animation
                  key: ValueKey(isFavourite),
                ),
              ),

              // NOTE: we don't use the .watch() here, but instead we use read()
              // which will get access (with .notifier) to the
              // FavouritesMealsNotifier and then we access toggleMealFavouriteStatus
              // that will update the list of favourite items
              onPressed: () {
                final wasAdded = ref
                    .read(favouriteMealsProvider.notifier)
                    .toggleMealFavouriteStatus(meal);

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasAdded
                        ? "Meal added as a favourite"
                        : "Meal removed"),
                    duration: const Duration(seconds: 4),
                  ),
                );
              }),
        ],
      ),

      // NOTE: was Column before but text was overflows, ListView could be used
      // but styling was off and would need to be fixed, SingleScrollView was
      // the best fit as nothing needed to be changed
      body: SingleChildScrollView(
        child: Column(
          children: [
            // in here we also need to make a logical connection by wrapping the
            // same image with Hero and tag it with a unique id which is a
            // meal.id in this case
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            const SizedBox(height: 24),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),
            for (final step in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
