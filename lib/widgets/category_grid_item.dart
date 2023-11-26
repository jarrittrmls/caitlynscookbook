import 'package:flutter/material.dart';
import 'package:meals_app/providers/categories_provider.dart';
import 'package:meals_app/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
    required this.onEditCategory,
    required this.onRemoveCategory,
  });

  final Category category;
  final void Function() onSelectCategory;
  final void Function() onEditCategory;
  final void Function() onRemoveCategory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: InkWell(
            onTap: onSelectCategory,
            onLongPress: onEditCategory,
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    category.color!.withOpacity(0.55),
                    category.color!.withOpacity(0.9),
                  ],
                ),
              ),
              child: Text(
                category.title!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onRemoveCategory,
          ),
        ),
      ],
    );
  }
}
