import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/scheduled_meal.dart';
import 'package:meals_app/screens/meal_details.dart';
import 'package:meals_app/providers/scheduled_meals_provider.dart';
import 'package:meals_app/widgets/scheduled_meals.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
              meal: meal,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(firebaseScheduledMealsProvider).when(
          data: (scheduledMeals) {
            return ScheduledMeals(
                key: ObjectKey(scheduledMeals),
                scheduledMeals: scheduledMeals,
                selectMeal: selectMeal,
                onRemoveMeal: deleteScheduledMeal);
          },
          error: (error, stack) => Center(
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
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
