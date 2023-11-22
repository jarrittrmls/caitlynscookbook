import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/ingredient.dart';

/*
class ShoppingListNotifier extends StateNotifier<List<Ingredient>> {
  ShoppingListNotifier() : super(dummyShoppingList);

  void addIngredient(Ingredient ingredient) {
    state = [...state, ingredient];
  }

  void updateIngredient(Ingredient ingredient) {
    final ingredientOld =
        state.where((element) => element.id == ingredient.id).toList()[0];
    final index = state.indexOf(ingredientOld);
    state.replaceRange(index, index + 1, [ingredient]);
    state = [...state];
  }

  void removeIngredient(Ingredient ingredient) {
    state = state.where((element) => element != ingredient).toList();
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Ingredient>>((ref) {
  return ShoppingListNotifier();
});
*/
final firebaseIngredientsProvider = StreamProvider<List<Ingredient>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  final ingredientsCollection =
      firestore.collection('ingredients'); // Replace with your collection name

  return ingredientsCollection
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((snapshots) {
    final ingredients = snapshots.docs.map((doc) {
      final data = doc.data();
      return Ingredient.fromMap({
        'id': doc.id,
        'title': data['title'],
        'measurement': data['measurement'],
        'quantity': data['quantity'],
        'userId': data['userId'],
      });
    }).toList();
    return ingredients;
  });
});

Future<void> addIngredient(Ingredient ingredient) async {
  final ingredientsCollection =
      FirebaseFirestore.instance.collection('ingredients');
  try {
    final newIngredientData = {
      'title': ingredient.title,
      'measurement': ingredient.measurement.toString(),
      'quantity': ingredient.quantity,
      'userId': ingredient.userId,
    };

    await ingredientsCollection.add(newIngredientData);
    print('Ingredient added successfully');
  } catch (error) {
    print('Error adding ingredient: $error');
  }
}

Future<void> updateIngredient(Ingredient updatedIngredient) async {
  final firestore = FirebaseFirestore.instance;
  final ingredientsCollection =
      firestore.collection('ingredients'); // Replace with your collection name

  try {
    final querySnapshot = await ingredientsCollection
        .where(FieldPath.documentId, isEqualTo: updatedIngredient.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await ingredientsCollection
          .doc(documentSnapshot.id)
          .update(updatedIngredient.toMap());
      print('Ingredient with ID ${updatedIngredient.id} updated successfully');
    } else {
      print('Ingredient with ID ${updatedIngredient.id} not found');
    }
  } catch (error) {
    print('Error updating ingredient: $error');
  }
}

Future<void> deleteIngredient(Ingredient ingredient) async {
  final firestore = FirebaseFirestore.instance;
  final ingredientsCollection =
      firestore.collection('ingredients'); // Replace with your collection name

  try {
    final querySnapshot = await ingredientsCollection
        .where(FieldPath.documentId, isEqualTo: ingredient.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await ingredientsCollection.doc(documentSnapshot.id).delete();
      print('Ingredient with ID ${ingredient.id} deleted successfully');
    } else {
      print('Ingredient with ID ${ingredient.id} not found');
    }
  } catch (error) {
    print('Error deleting ingredient: $error');
  }
}
