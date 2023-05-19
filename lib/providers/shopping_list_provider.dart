import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/ingredient.dart';

class ShoppingListNotifier extends StateNotifier<List<Ingredient>> {
  ShoppingListNotifier() : super(dummyShoppingList);

  void addIngredient(Ingredient ingredient) {
    state = [...state, ingredient];
  }

  void removeIngredient(Ingredient ingredient) {
    state = state.where((element) => element != ingredient).toList();
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Ingredient>>((ref) {
  return ShoppingListNotifier();
});
