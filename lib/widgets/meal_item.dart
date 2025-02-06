import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/meal.dart';
import 'meal_item_trait.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final void Function() onSelectMeal;
  final Meal meal;

  String get complexityText {
    switch (meal.complexity) {
      case Complexity.simple:
        return "Simple";
      case Complexity.challenging:
        return "Challenging";
      case Complexity.hard:
        return "Hard";
      }
  }

  String get affordabilityText {
    switch (meal.affordability) {
      case Affordability.affordable:
        return "Affordable";
      case Affordability.pricey:
        return "Pricey";
      case Affordability.luxurious:
        return "Luxurious";
      }
  }

  @override
  Widget build(BuildContext context) {
    // Card is really a pre-styled container with some padding and a shadow, by
    // default it has:
    // - build-in elevation (shadow effect)
    // - rounded corners
    // - white background (can be changed)
    // - a more structured design for UI elements like lists, or structured data
    // blocks
    return Card(
      margin: const EdgeInsets.all(8),

      // give it a little rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),

      // enforce the card to have a hard edge clipping as Stack by default
      // ignores it -> goes inline with the above shape property
      clipBehavior: Clip.hardEdge,

      // add a bit of a shadow drop to the card element (kind of 3D effect)
      elevation: 2,

      child: InkWell(
        onTap: onSelectMeal,

        // allows you to position widgets on top of each other (i.e., in a
        // Z-order layering fashion) and its useful when you need overlapping
        // widgets or precisely positioned elements and that's why we use it for
        // here
        child: Stack(
          children: [
            // image will be smoothly faded in on the background
            // NOTE: kTransparentImage is imported from the transparent_image
            // package that simply gives us a dummy image that is transparent
            // but will have the same size as the image that we want to load
            // NOTE 2: MemoryImage is a class that allows us to load an image
            // IMPORTANT: that widget will be displayed on the bottom of stack
            // Hero widget is an animation widget that animate widgets across
            // different screens
            Hero(
              // behind the scenes will be used for identifying widget on this
              // screen and on a target screen -> it must be unique
              // NOTE: images for such animation is the common case, but its not
              // limited to images only
              tag: meal.id,

              // child that will be animated
              child: FadeInImage(
                // loads a placeholder or empty image (in this case) to give a
                // better user experience so instead of having a white screen while
                // it can load a default image (in this case a transparent image)
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
              
                // fit: BoxFit.cover will make sure that the image will be
                // stretched as we want to make image smaller
                fit: BoxFit.cover,
              
                // height and width would be enforced as fit will stretch the image
                height: 200,
                width: double.infinity,
              ),
            ),

            // a very useful image where we can define how it will be positioned
            // on top of the FadeInImage above
            Positioned(
              // stuck to bottom, then stretched from left and right -> those
              // values are essentially saying start from beginning of
              // the left, right and bottom
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // slightly transparent black background to make the text more
                // readable
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 44,
                ),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,

                      // if text is too long it will be wrapped
                      softWrap: true,

                      // if text is too long it will be cut of by ...
                      overflow: TextOverflow.ellipsis,  // Vey long text...
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),

                    // we are using row within the row, usually we would need
                    // expanded to make sure that the row will take as much space
                    // but in this case its constrained by the parent container
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: "${meal.duration} min",
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.work,
                          label: complexityText,
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.attach_money,
                          label: affordabilityText,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
