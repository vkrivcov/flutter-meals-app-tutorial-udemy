import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectedScreen});

  final void Function(String identifier) onSelectedScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fastfood,
                    size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 18),
                Text("Cooking Up!",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary))
              ],
            ),
          ),

          // optimised for bundling multiple pieces of information in a single row
          ListTile(
            // sets Icon to the beginning of the list tile (alternative would be
            // adding a Row with Icon and Text)
            leading: Icon(
              Icons.restaurant,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text("Meals",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24)),
            onTap: () {
              // we could easily open a new screen here, BUT for some of the
              // the screens we keep the state in TabsScreen therefore instead
              // we pass a pointer to the function that will be called
              onSelectedScreen("meals");
              // Navigator.of(context).pushReplacementNamed('/');
            },
          ),

          ListTile(
            // sets Icon to the beginning of the list tile (alternative would be
            // adding a Row with Icon and Text)
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text("Filters",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24)),
            onTap: () {
              // we could easily open a new screen here, BUT for some of the
              // the screens we keep the state in TabsScreen therefore instead
              // we pass a pointer to the function that will be called
              onSelectedScreen("filters");
              // Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
