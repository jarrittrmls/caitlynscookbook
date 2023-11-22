import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/categories_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/providers/categories_provider.dart';
import 'package:meals_app/widgets/edit_category_modal.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({
    super.key,
  });

  void _selectCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title!,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCategories = ref.watch(firebaseCategoriesProvider);
    Widget content;

    void _editCategory(BuildContext context, Category category) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => EditCategoryModal(category: category),
      );
    }

    void _removeCategory(Category category) {
      var meals = ref.watch(firebaseMealsProvider).when(
            data: (meals) => meals,
            loading: () =>
                [], // Return an empty list or handle loading state accordingly
            error: (error, stack) {
              // Handle error state accordingly, for now, returning an empty list
              print('Error: $error');
              return [];
            },
          );
      if (meals.isEmpty) {
        deleteCategory(category);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              "Oops",
              style: Theme.of(context)
                  .primaryTextTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            content: Text(
                "It looks like there are still meals registered to this category. Try unregistering them first before deleting the category.",
                style: Theme.of(context).primaryTextTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: ref.watch(firebaseCategoriesProvider).when(
          data: (categories) {
            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No meals to show yet...",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ],
                ),
              );
            } else {
              return GridView(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  for (final category in categories)
                    CategoryGridItem(
                      category: category,
                      onSelectCategory: () {
                        _selectCategory(context, category);
                      },
                      onEditCategory: () {
                        _editCategory(context, category);
                      },
                      onRemoveCategory: () {
                        _removeCategory(category);
                      },
                    )
                ],
              );
            }
          },
          error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Something went wrong...",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
