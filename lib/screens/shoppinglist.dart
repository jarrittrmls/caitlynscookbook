import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/providers/shopping_list_provider.dart';

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
    final shoppingList = ref.watch(shoppingListProvider);

    return ReorderableListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
            color: Theme.of(context).colorScheme.error,
            margin: Theme.of(context).cardTheme.margin),
        key: ValueKey(shoppingList[index]),
        onDismissed: (direction) {
          setState(() {
            ref
                .read(shoppingListProvider.notifier)
                .removeIngredient(shoppingList[index]);
          });
        },
        child: InkWell(
          onTap: () {},
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
                  Text("${formatFloat(shoppingList[index].quantity)} ",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text("${shoppingList[index].measurement.name} ",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(shoppingList[index].title,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
      itemCount: shoppingList.length,
      onReorder: (int start, int current) {
        // dragging from top to bottom
        if (start < current) {
          int end = current - 1;
          Ingredient startItem = shoppingList[start];
          int i = 0;
          int local = start;
          do {
            shoppingList[local] = shoppingList[++local];
            i++;
          } while (i < end - start);
          shoppingList[end] = startItem;
        }
        // dragging from bottom to top
        else if (start > current) {
          Ingredient startItem = shoppingList[start];
          for (int i = start; i > current; i--) {
            shoppingList[i] = shoppingList[i - 1];
          }
          shoppingList[current] = startItem;
        }
        setState(() {});
      },
    );
  }
}
