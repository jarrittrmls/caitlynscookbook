import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Measurement {
  small,
  medium,
  large,
  cup,
  pint,
  quart,
  gallon,
  ounce,
  tablespoon,
  teaspoon,
  gram,
  liter,
  milliliter,
  dash,
  pinch,
  slice,
  clove,
  piece,
  bunch,
  other,
  serving,
}

class Ingredient {
  Ingredient({
    required this.title,
    required this.measurement,
    required this.quantity,
    this.userId,
  }) : id = Uuid().v4();

  Ingredient.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        measurement = _stringToMeasurement(data['measurement']),
        quantity = data['quantity'],
        userId = data['userId'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'measurement': _measurementToString(measurement),
      'quantity': quantity,
      'userId': userId,
    };
  }

  final String id;
  String title;
  Measurement measurement;
  double quantity;
  String? userId;

  static Measurement _stringToMeasurement(String value) {
    return Measurement.values.firstWhere(
      (enumValue) => enumValue.toString() == value,
    );
  }

  static String _measurementToString(Measurement measurement) {
    return measurement.toString();
  }
}
