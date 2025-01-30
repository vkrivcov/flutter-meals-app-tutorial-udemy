import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryGridItem extends StatelessWidget {
  CategoryGridItem({super.key, required this.category, required this.onSelectCategory});

  final Category category;
  final void Function() onSelectCategory;
  final BorderRadius borderRadius = BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    // InkWell will make sure that the item is clickable
    // NOTE: alternative would be GestureDetector that will give way more
    // options to perform user actions, BUT you will not have a nice visual
    // feedback when the user clicks on the item
    return InkWell(
      onTap: onSelectCategory,

      // onTap: () {
      //   // Navigator.of(context).pushNamed('/category-meals', arguments: category);
      // },
      // sets you that nice tapping effect color
      splashColor: Theme.of(context).primaryColor,

      // border radius will make the item look a bit more interesting otherwise
      // if we set border radius to actual container then colour will go outside
      // of actual container and will look strange
      borderRadius: borderRadius,

      // Container will give a lot of options such as setting a background color
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          // color: category.color,  // that one will look very flat and boring
          gradient: LinearGradient(
            colors: [
              category.color.withAlpha((0.55 * 255).toInt()),
              category.color.withAlpha((0.9 * 255).toInt()),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
