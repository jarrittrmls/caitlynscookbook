import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/scheduled_meal.dart';
import 'package:meals_app/screens/meal_details.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<ScheduledMeal> scheduledMeals = dummyScheduledMeals;

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
              meal: meal,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 14; i++)
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    clipBehavior: Clip.hardEdge,
                    elevation: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        textAlign: TextAlign.center,
                        formatter.format(
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day + i,
                          ),
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: scheduledMeals
                        .where(
                            (meal) => meal.day.day == (DateTime.now().day + i))
                        .toList()
                        .length,
                    itemBuilder: (ctx, index) => Dismissible(
                      background: Container(
                          color: Theme.of(context).colorScheme.error,
                          margin: Theme.of(context).cardTheme.margin),
                      key: ValueKey(scheduledMeals[index]),
                      onDismissed: (direction) {
                        setState(() {
                          scheduledMeals.remove(scheduledMeals
                              .where((meal) =>
                                  meal.day.day == (DateTime.now().day + i))
                              .toList()[index]);
                        });
                      },
                      child: InkWell(
                        onTap: () {
                          selectMeal(context, scheduledMeals[index].meal);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.white,
                          clipBehavior: Clip.hardEdge,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 16,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 16,
                            ),
                            child: Text(scheduledMeals
                                .where((meal) =>
                                    meal.day.day == (DateTime.now().day + i))
                                .toList()[index]
                                .meal
                                .title),
                          ),
                        ),
                      ),
                    ),
                    shrinkWrap: true,
                    primary: false,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
