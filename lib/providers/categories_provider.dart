import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';

/*
class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super(availableCategories);

  void addCategory(Category category) {
    state = [...state, category];
  }

  void updateCategory(Category category) {
    final ingredientOld =
        state.where((element) => element.id == category.id).toList()[0];
    final index = state.indexOf(ingredientOld);
    state.replaceRange(index, index + 1, [category]);
    state = [...state];
  }

  void removeCategory(Category category) {
    state = state.where((element) => element != category).toList();
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier();
});
*/
final firebaseCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  final categoriesCollection = firestore.collection('categories');
  return categoriesCollection
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((snapshots) {
    final categories = snapshots.docs.map((doc) {
      final data = doc.data();
      return Category.fromMap({
        'catid': data['catid'],
        'title': data['title'],
        'color': data['color'], // Convert the color value
        'userId': data['userId'],
      });
    }).toList();
    return categories;
  });
});

Future<void> deleteCategory(Category category) async {
  final firestore = FirebaseFirestore.instance;
  final collectionReference = firestore.collection('categories');
  try {
    final querySnapshot =
        await collectionReference.where('catid', isEqualTo: category.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      // If one or more documents match the query, delete them
      for (final documentSnapshot in querySnapshot.docs) {
        await collectionReference.doc(documentSnapshot.id).delete();
      }
      print('Category deleted successfully');
    } else {
      print('Category not found');
    }
  } catch (error) {
    print('Error deleting category: $error');
  }
}

Future<void> updateCategory(Category updatedCategory) async {
  final firestore = FirebaseFirestore.instance;
  final collectionReference = firestore.collection('categories');

  try {
    final querySnapshot = await collectionReference
        .where('catid', isEqualTo: updatedCategory.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a document with the specified ID exists, update it
      final documentSnapshot = querySnapshot.docs.first;
      await collectionReference.doc(documentSnapshot.id).update({
        'title': updatedCategory.title,
        'color': updatedCategory.color!.value.toRadixString(
            16), // Assuming color is stored as a hexadecimal string
      });
      print('Category with ID ${updatedCategory.id} updated successfully');
    } else {
      print('Category with ID ${updatedCategory.id} not found');
    }
  } catch (error) {
    print('Error updating category: $error');
  }
}

Future<void> addCategory(Category category) async {
  final categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  try {
    final newCategoryData = {
      'catid': category.id,
      'title': category.title,
      'color': category.color!.value.toRadixString(16),
      'userId': category.userId,
    };
    await categoriesCollection.add(newCategoryData);
    print('Category added successfully');
  } catch (error) {
    print('Error adding category: $error');
  }
}
