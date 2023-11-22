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
    this.imageUrl,
    this.recipeUrl,
    this.ingredients,
    this.instructions,
    this.duration,
    this.complexity,
    this.affordability,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isVegan = false,
    this.isVegetarian = false,
    required this.userId,
  });

  Meal.fromMap(Map<String, dynamic> data)
      : id = data['mealid'],
        categories = (data['categories'] as List<dynamic>).map((categoryData) {
          if (categoryData is Map<String, dynamic>) {
            return Category.fromMap(categoryData);
          } else if (categoryData is Category) {
            return categoryData;
          }
          throw ArgumentError('Invalid category data');
        }).toList(),
        title = data['title'],
        imageUrl = data['imageUrl'],
        recipeUrl = data['recipeUrl'],
        ingredients =
            (data['ingredients'] as List<dynamic>).map((ingredientData) {
          if (ingredientData is Map<String, dynamic>) {
            return Ingredient.fromMap(ingredientData);
          } else if (ingredientData is Ingredient) {
            return ingredientData;
          }
          throw ArgumentError('Invalid ingredient data');
        }).toList(),
        instructions = data['instructions'],
        duration = data['duration'],
        complexity = _parseComplexity(data['complexity']),
        affordability = _parseAffordability(data['affordability']),
        isGlutenFree = data['isGlutenFree'],
        isLactoseFree = data['isLactoseFree'],
        isVegan = data['isVegan'],
        isVegetarian = data['isVegetarian'],
        userId = data['userId'];

  Map<String, dynamic> toMap() {
    return {
      'mealid': id,
      'categories': categories.map((category) => category.toMap()).toList(),
      'title': title,
      'imageUrl': imageUrl,
      'recipeUrl': recipeUrl,
      'ingredients':
          ingredients?.map((ingredient) => ingredient.toMap()).toList(),
      'instructions': instructions,
      'duration': duration,
      'complexity': complexity.toString(),
      'affordability': affordability.toString(),
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'userId': userId,
    };
  }

  static Complexity _parseComplexity(String value) {
    switch (value) {
      case 'easy':
        return Complexity.easy;
      case 'challenging':
        return Complexity.challenging;
      case 'hard':
        return Complexity.hard;
      default:
        return Complexity.unknown;
    }
  }

  static Affordability _parseAffordability(String value) {
    switch (value) {
      case 'affordable':
        return Affordability.affordable;
      case 'pricey':
        return Affordability.pricey;
      case 'luxurious':
        return Affordability.luxurious;
      default:
        return Affordability.unknown;
    }
  }

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
  String userId;
}
