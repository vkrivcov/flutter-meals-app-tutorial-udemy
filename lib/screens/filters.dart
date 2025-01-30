import 'package:flutter/material.dart';

import '../widgets/filter_item.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FiltersScreen> createState() {
    return _FiltersState();
  }
}

class _FiltersState extends State<FiltersScreen> {
  // NOTE: old way of how we did it initially
  // we will manage state of switch list tiles here
  // bool glutenFilterSet = false;
  // bool lactoseFilterSet = false;
  // bool vegetarianFilterSet = false;
  // bool veganFilterSet = false;

  // store filters dynamically (default all to false)
  // NOTE: ideally we would set its value to currentFilters with the help of
  // widget, but its only available in build method therefore we need to set it
  // using initState() function
  final Map<Filter, bool> _filters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

  // runs before init build method
  @override
  void initState() {
    super.initState();

    // can in theory assign whole map
    _filters[Filter.glutenFree] = widget.currentFilters[Filter.glutenFree]!;
    _filters[Filter.lactoseFree] = widget.currentFilters[Filter.lactoseFree]!;
    _filters[Filter.vegetarian] = widget.currentFilters[Filter.vegetarian]!;
    _filters[Filter.vegan] = widget.currentFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    // return scaffold as its a new screen that will requite bits such as drawer
    // etc.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Filters"),
      ),

      // IF WE want we can reuse a drawer here as we used on the tabs screen
      // but for this example we are happy with the back button
      // initially with the app bar there was a back navigation, it is replaced
      // with a drawer for a different navigation style
      // NOTE: even though we replaced the back navigation with a drawer, we still
      // able to go back using device back button if we want to
      // drawer: Drawer(
      //   child: MainDrawer(onSelectedScreen: (identifier) {
      //     if (identifier == "meals") {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      //     }
      //   }),
      // ),

      // here we use it save and return the state of the switches so we can then
      // use them on the filters screen to actually filter the meals
      // other use-cases are to prevent back button from closing the screen etc.
      body: PopScope(
        // when false, blocks the current route from being popped.
        // This includes the root route, where upon popping, the Flutter app would exit
        canPop: false,

        // function will be called when the back button is pressed i.e. when a
        // user wants to go back to the previous screen and will return the map
        // that we created
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if(didPop) return;
          Navigator.of(context).pop(_filters);
        },

        // we want to display a list of switches (useful widgets when you want to
        // switch them on/off (settings like alternative)
        child: Column(
          // ideally we want to outsource it, but to save time we will just copy
          // and paste it here
          children: [
            // ONE way to build SwitchListTile, BUT we wrapped it inside a
            // reusable widget
            // convenience widget to display a switch in a list tile (i.e. a row),
            // gives an ability to switch on/off and a title, label and other bits
            // SwitchListTile(
            //   // boolean value indicating if its on or off
            //   value: glutenFilterSet,
            //
            //   // function that receives a boolean value when the switch is toggled
            //   // NOTE: is checked is the just an action when the switch is toggled
            //   onChanged: (isChecked) {
            //     setState(() {
            //       glutenFilterSet = isChecked;
            //     });
            //   },
            //
            //   title: Text(
            //     "Gluten-Free",
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleLarge!
            //         .copyWith(color: Theme.of(context).colorScheme.onSurface),
            //   ),
            //
            //   // simply for extra explanation
            //   subtitle: Text(
            //     "Only include gluten-free meals.",
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleMedium!
            //         .copyWith(color: Theme.of(context).colorScheme.onSurface),
            //   ),
            //
            //   // color when switch is activated or not
            //   // onTertiary: as per docs balance color between primary and secondary
            //   activeColor: Theme.of(context).colorScheme.onTertiary,
            //   contentPadding: const EdgeInsets.only(left: 34, right: 22),
            // ),
        
            // SwitchListTile(
            //   // boolean value indicating if its on or off
            //   value: lactoseFilterSet,
            //
            //   // function that receives a boolean value when the switch is toggled
            //   // NOTE: is checked is the just an action when the switch is toggled
            //   onChanged: (isChecked) {
            //     setState(() {
            //       lactoseFilterSet = isChecked;
            //     });
            //   },
            //
            //   title: Text(
            //     "Lactose-Free",
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleLarge!
            //         .copyWith(color: Theme.of(context).colorScheme.onSurface),
            //   ),
            //
            //   // simply for extra explanation
            //   subtitle: Text(
            //     "Only include lactose-free meals.",
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleMedium!
            //         .copyWith(color: Theme.of(context).colorScheme.onSurface),
            //   ),
            //
            //   // color when switch is activated or not
            //   // onTertiary: as per docs balance color between primary and secondary
            //   activeColor: Theme.of(context).colorScheme.onTertiary,
            //   contentPadding: const EdgeInsets.only(left: 34, right: 22),
            // ),
            FilterItem(
              title: "Gluten-Free",
              subTitle: "Only include gluten-free meals.",
              initialFilterSelection: _filters[Filter.glutenFree]!,
              onFilterChanged: (isChecked) {
                _filters[Filter.glutenFree] = isChecked;
              },
            ),
            FilterItem(
              title: "Lactose-Free",
              subTitle: "Only include lactose-free meals.",
              initialFilterSelection: _filters[Filter.lactoseFree]!,
              onFilterChanged: (isChecked) {
                _filters[Filter.lactoseFree] = isChecked;
              },
            ),
            FilterItem(
              title: "Vegetarian",
              subTitle: "Only include vegetarian meals.",
              initialFilterSelection: _filters[Filter.vegetarian]!,
              onFilterChanged: (isChecked) {
                _filters[Filter.vegetarian] = isChecked;
              },
            ),
            FilterItem(
              title: "Vegan",
              subTitle: "Only include Vegan meals.",
              initialFilterSelection: _filters[Filter.vegan]!,
              onFilterChanged: (isChecked) {
                _filters[Filter.vegan] = isChecked;
              },
            ),
          ],
        ),
      ),
    );
  }
}
