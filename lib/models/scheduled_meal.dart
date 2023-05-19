import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('EEEE, d MMM, yyyy');

const uuid = Uuid();

class ScheduledMeal {
  const ScheduledMeal({required this.day, required this.meal});

  final DateTime day;
  final Meal meal;

  String get formattedDate {
    return formatter.format(day);
  }

  Meal get getMeal {
    return meal;
  }
}
