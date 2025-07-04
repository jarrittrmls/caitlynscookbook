import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  String get complexityText {
    return meal.complexity!.name[0].toUpperCase() +
        meal.complexity!.name.substring(1, meal.complexity!.name.length);
  }

  String get affordabilityText {
    if (meal.affordability == Affordability.affordable) {
      return "\$";
    } else if (meal.affordability == Affordability.pricey) {
      return "\$\$";
    } else {
      return "\$\$\$";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(meal);
        },
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: meal.imageUrl ==
                      "https://clipground.com/images/no-image-png-5.jpg"
                  ? const NetworkImage(
                      "https://clipground.com/images/no-image-png-5.jpg")
                  : Image.file(File(meal.imageUrl!))
                      .image, // Change to image from blob? fileImage?
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (meal.duration != null)
                          MealItemTrait(
                            icon: Icons.schedule,
                            label: '${meal.duration} min',
                          ),
                        const SizedBox(width: 12),
                        if (meal.complexity != Complexity.unknown)
                          MealItemTrait(
                            icon: Icons.work,
                            label: complexityText,
                          ),
                        const SizedBox(width: 12),
                        if (meal.affordability != Affordability.unknown)
                          Text(
                            affordabilityText,
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
