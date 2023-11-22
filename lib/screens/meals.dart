import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/meal_details.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends ConsumerWidget {
  const MealsScreen({
    super.key,
    required this.title,
    required this.category,
  });

  final String title;
  final Category category;

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
              meal: meal,
            )));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ref.watch(firebaseMealsProvider).when(
          data: (meals) {
            final filteredMeals = meals
                .where((meal) =>
                    meal.categories.any((c) => c.title == category.title))
                .toList();
            if (filteredMeals.isNotEmpty) {
              return ListView.builder(
                itemCount: filteredMeals.length,
                itemBuilder: ((context, index) => MealItem(
                      meal: filteredMeals[index],
                      onSelectMeal: (meal) {
                        selectMeal(context, meal);
                      },
                    )),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "No meals to show yet...",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Try adding some meals or selecting a different category!",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Something went wrong...",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      )
                    ],
                  ),
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
