import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/providers/shopping_list_provider.dart';
import 'package:meals_app/widgets/edit_ingredient_modal.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  String formatFloat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(firebaseIngredientsProvider).when(
          data: (ingredients) {
            return ReorderableListView.builder(
              itemBuilder: (ctx, index) => Dismissible(
                background: Container(
                    color: Theme.of(context).colorScheme.error,
                    margin: Theme.of(context).cardTheme.margin),
                key: ValueKey(ingredients[index]),
                onDismissed: (direction) {
                  setState(() {
                    deleteIngredient(ingredients[index]);
                  });
                },
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) =>
                          EditIngredientModal(ingredient: ingredients[index]),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white,
                    clipBehavior: Clip.hardEdge,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 16,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Text("${formatFloat(ingredients[index].quantity)} ",
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text("${ingredients[index].measurement.name} ",
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text(ingredients[index].title,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: ingredients.length,
              onReorder: (int start, int current) {
                // dragging from top to bottom
                if (start < current) {
                  int end = current - 1;
                  Ingredient startItem = ingredients[start];
                  int i = 0;
                  int local = start;
                  do {
                    ingredients[local] = ingredients[++local];
                    i++;
                  } while (i < end - start);
                  ingredients[end] = startItem;
                }
                // dragging from bottom to top
                else if (start > current) {
                  Ingredient startItem = ingredients[start];
                  for (int i = start; i > current; i--) {
                    ingredients[i] = ingredients[i - 1];
                  }
                  ingredients[current] = startItem;
                }
                setState(() {});
              },
            );
          },
          error: (error, stack) => Center(
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
