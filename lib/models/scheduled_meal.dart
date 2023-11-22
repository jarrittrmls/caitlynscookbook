import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('EEEE, d MMM, yyyy');

const uuid = Uuid();

class ScheduledMeal {
  ScheduledMeal({
    required this.day,
    required this.meal,
    required this.userId,
  }) : scheduledMealId = uuid.v4();

  DateTime? day;
  Meal? meal;
  String? scheduledMealId;
  String? userId;

  String get formattedDate {
    return formatter.format(day!);
  }

  Meal get getMeal {
    return meal!;
  }

  ScheduledMeal.fromMap(Map<String, dynamic> data) {
    scheduledMealId = data['scheduledMealId'];
    meal = data['meal'];
    day = (data['day'] as Timestamp).toDate();
    userId = data['userId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'scheduledMealId': scheduledMealId,
      'day': day,
      'meal': meal!.toMap(),
      'userId': meal!.userId,
    };
  }
}
