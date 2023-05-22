import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/widgets/webview.dart';

class MealDetailsScreen extends ConsumerStatefulWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  void _openWebview(context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Webview(meal: meal),
      ),
    );
  }

  String formatFloat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    //final favoriteMeals = ref.watch(favoriteMealsProvider);
    //final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
        appBar: AppBar(title: Text(widget.meal.title), actions: [
          /*
          IconButton(
              onPressed: () {
                final wasAdded = ref
                    .read(favoriteMealsProvider.notifier)
                    .toggleMealFavoriteStatus(meal);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasAdded
                        ? "${meal.title} was favorited"
                        : "${meal.title} was unfavorited"),
                  ),
                );
              },
              icon: Icon(isFavorite ? Icons.star : Icons.star_border)),
        */
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Delete ${widget.meal.title}?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${widget.meal.title} was deleted"),
                            ),
                          );

                          setState(() {
                            ref
                                .read(mealsProvider.notifier)
                                .removeMeal(widget.meal);
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete)),
        ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                widget.meal.imageUrl!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 14,
              ),
              if (widget.meal.recipeUrl!.isNotEmpty)
                TextButton(
                    onPressed: () {
                      widget._openWebview(context);
                    },
                    child: Text("View ${widget.meal.title} recipe online")),
              if (widget.meal.ingredients!.isNotEmpty)
                Text(
                  "Ingredients",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const SizedBox(height: 14),
              for (final ingredient in widget.meal.ingredients!)
                Row(
                  children: [
                    Text(
                      "${widget.formatFloat(ingredient.quantity)} ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Text(
                      "${ingredient.measurement.name} ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Text(
                      ingredient.title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              if (widget.meal.instructions!.isNotEmpty)
                Text(
                  "Instructions",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const SizedBox(height: 14),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Text(
                  widget.meal.instructions!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ));
  }
}
