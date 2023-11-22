import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/scheduled_meal.dart';

import '../models/meal.dart';

/*
class ScheduledMealsNotifier extends StateNotifier<List<ScheduledMeal>> {
  ScheduledMealsNotifier() : super(dummyScheduledMeals);

  void addMeal(ScheduledMeal meal) {
    state = [...state, meal];
  }

  void removeMeal(ScheduledMeal meal) {
    state = state.where((element) => element != meal).toList();
  }
}

final scheduledMealsProvider =
    StateNotifierProvider<ScheduledMealsNotifier, List<ScheduledMeal>>((ref) {
  return ScheduledMealsNotifier();
});
*/
final firebaseScheduledMealsProvider =
    StreamProvider<List<ScheduledMeal>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  final scheduledMealsCollection = firestore.collection('scheduledMeals');

  return scheduledMealsCollection
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((snapshots) {
    final scheduledMeals = snapshots.docs.map((doc) {
      final data = doc.data();
      return ScheduledMeal.fromMap({
        'scheduledMealId': data['scheduledMealId'],
        'day': data['day'],
        'meal': Meal.fromMap(data['meal']),
      });
    }).toList();
    return scheduledMeals;
  });
});

Future<void> addScheduledMeal(ScheduledMeal scheduledMeal) async {
  final scheduledMealsCollection =
      FirebaseFirestore.instance.collection('scheduledMeals');
  try {
    final newScheduledMealData = {
      'scheduledMealId': scheduledMeal.scheduledMealId,
      'day': scheduledMeal.day,
      'meal': scheduledMeal.getMeal.toMap(),
      'userId': scheduledMeal.userId,
    };

    await scheduledMealsCollection.add(newScheduledMealData);
    print('ScheduledMeal added successfully');
  } catch (error) {
    print('Error adding ScheduledMeal: $error');
  }
}

Future<void> updateScheduledMeal(ScheduledMeal updatedScheduledMeal) async {
  final firestore = FirebaseFirestore.instance;
  final scheduledMealsCollection = firestore.collection('scheduledMeals');

  try {
    final querySnapshot = await scheduledMealsCollection
        .where(FieldPath.documentId,
            isEqualTo: updatedScheduledMeal.scheduledMealId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await scheduledMealsCollection
          .doc(documentSnapshot.id)
          .update(updatedScheduledMeal.toMap());
      print('ScheduledMeal updated successfully');
    } else {
      print('ScheduledMeal not found');
    }
  } catch (error) {
    print('Error updating ScheduledMeal: $error');
  }
}

Future<void> deleteScheduledMeal(ScheduledMeal scheduledMeal) async {
  final firestore = FirebaseFirestore.instance;
  final scheduledMealsCollection = firestore.collection('scheduledMeals');

  try {
    final querySnapshot = await scheduledMealsCollection
        .where('scheduledMealId', isEqualTo: scheduledMeal.scheduledMealId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await scheduledMealsCollection.doc(documentSnapshot.id).delete();
      print('ScheduledMeal deleted successfully');
    } else {
      print('ScheduledMeal not found');
    }
  } catch (error) {
    print('Error deleting ScheduledMeal: $error');
  }
}
