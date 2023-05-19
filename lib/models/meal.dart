import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/models/category.dart';

enum Complexity {
  easy,
  challenging,
  hard,
  unknown,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
  unknown,
}

class Meal {
  Meal({
    this.id,
    required this.categories,
    required this.title,
    this.imageUrl = "https://clipground.com/images/no-image-png-5.jpg",
    this.recipeUrl = "",
    ingredients,
    this.instructions = "",
    this.duration,
    this.complexity = Complexity.unknown,
    this.affordability = Affordability.unknown,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isVegan = false,
    this.isVegetarian = false,
  }) : ingredients = ingredients ?? [];

  String? id;
  List<Category> categories;
  String title;
  String? imageUrl;
  String? recipeUrl;
  List<Ingredient>? ingredients;
  String? instructions;
  int? duration;
  Complexity? complexity;
  Affordability? affordability;
  bool isGlutenFree;
  bool isLactoseFree;
  bool isVegan;
  bool isVegetarian;
}
