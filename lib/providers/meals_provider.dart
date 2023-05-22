import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super(dummyMeals);

  void addMeal(Meal meal) {
    state = [...state, meal];
  }

  void removeMeal(Meal meal) {
    state = state.where((element) => element != meal).toList();
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier();
});
