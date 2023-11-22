import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/scheduled_meals_provider.dart';

/*
class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super(dummyMeals);

  void addMeal(Meal meal) {
    state = [...state, meal];
  }

  void updateMeal(Meal meal) {
    final ingredientOld =
        state.where((element) => element.id == meal.id).toList()[0];
    final index = state.indexOf(ingredientOld);
    state.replaceRange(index, index + 1, [meal]);
    state = [...state];
  }

  void removeMeal(Meal meal) {
    state = state.where((element) => element != meal).toList();
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier();
});
*/
final firebaseMealsProvider = StreamProvider<List<Meal>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  final mealsCollection = firestore.collection('meals');

  return mealsCollection
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((snapshots) {
    final meals = snapshots.docs.map((doc) {
      final data = doc.data();
      return Meal.fromMap({
        'mealid': doc.id,
        'categories': (data['categories'] as List<dynamic>)
            .map((category) => Category.fromMap({
                  'catid': category['catid'],
                  'title': category['title'],
                  'color': category['color'], // Convert the color value
                }))
            .toList(),
        'title': data['title'],
        'imageUrl': data['imageUrl'],
        'recipeUrl': data['recipeUrl'],
        'ingredients': (data['ingredients'] as List<dynamic>?)
            ?.map((ingredient) => Ingredient.fromMap(ingredient))
            .toList(),
        'instructions': data['instructions'],
        'duration': data['duration'],
        'complexity': data['complexity'],
        'affordability': data['affordability'],
        'isGlutenFree': data['isGlutenFree'],
        'isLactoseFree': data['isLactoseFree'],
        'isVegan': data['isVegan'],
        'isVegetarian': data['isVegetarian'],
        'userId': data['userId'],
      });
    }).toList();
    return meals;
  });
});

Future<void> addMeal(Meal meal) async {
  final mealsCollection = FirebaseFirestore.instance.collection('meals');
  try {
    final newMealData = {
      'title': meal.title,
      'imageUrl': meal.imageUrl,
      'categories': meal.categories
          .map((category) => {
                'catid': category.id,
                'title': category.title,
                'color': category.color!.value.toRadixString(16),
              })
          .toList(),
      'recipeUrl': meal.recipeUrl,
      'ingredients': meal.ingredients
          ?.map((ingredient) => {
                'id': ingredient.id,
                'title': ingredient.title,
                'measurement': ingredient.measurement.toString(),
                'quantity': ingredient.quantity,
              })
          .toList(),
      'instructions': meal.instructions,
      'duration': meal.duration,
      'complexity': meal.complexity.toString(),
      'affordability': meal.affordability.toString(),
      'isGlutenFree': meal.isGlutenFree,
      'isLactoseFree': meal.isLactoseFree,
      'isVegan': meal.isVegan,
      'isVegetarian': meal.isVegetarian,
      'userId': meal.userId,
    };

    await mealsCollection.add(newMealData);
    print('Meal added successfully');
  } catch (error) {
    print('Error adding meal: $error');
  }
}

Future<void> updateMeal(Meal updatedMeal) async {
  final firestore = FirebaseFirestore.instance;
  final mealsCollection = firestore.collection('meals');

  try {
    final querySnapshot = await mealsCollection
        .where(FieldPath.documentId, isEqualTo: updatedMeal.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await mealsCollection
          .doc(documentSnapshot.id)
          .update(updatedMeal.toMap());
      print('Meal with ID ${updatedMeal.id} updated successfully');
    } else {
      print('Meal with ID ${updatedMeal.id} not found');
    }
  } catch (error) {
    print('Error updating meal: $error');
  }
}

Future<void> deleteMeal(Meal meal) async {
  final firestore = FirebaseFirestore.instance;
  final mealsCollection = firestore.collection('meals');
  final scheduledMealsCollection = firestore.collection('scheduledMeals');

  try {
    final querySnapshot = await mealsCollection
        .where(FieldPath.documentId, isEqualTo: meal.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await mealsCollection.doc(documentSnapshot.id).delete();

      print('Meal with ID ${meal.id} deleted successfully');
    } else {
      print('Meal with ID ${meal.id} not found');
    }

    final scheduledMealsQuery = await scheduledMealsCollection
        .where('meal.mealid', isEqualTo: meal.id)
        .get();
    for (final scheduledMealDoc in scheduledMealsQuery.docs) {
      await scheduledMealsCollection.doc(scheduledMealDoc.id).delete();
      print(
          'ScheduledMeal with ID ${scheduledMealDoc.id} deleted successfully');
    }
  } catch (error) {
    print('Error deleting meal: $error');
  }
}
