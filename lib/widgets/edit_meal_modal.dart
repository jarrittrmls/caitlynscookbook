import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/categories_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/widgets/meal_image_picker.dart';
import 'package:meals_app/widgets/new_meal_ingredient_modal.dart';

class EditMealModal extends ConsumerStatefulWidget {
  const EditMealModal({super.key, required this.meal});
  final Meal meal;

  @override
  ConsumerState<EditMealModal> createState() => _EditMealModalState();
}

class _EditMealModalState extends ConsumerState<EditMealModal> {
  List<Ingredient> ingredients = [];
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _durationController = TextEditingController();
  var _selectedCategories = <Category>[];
  var _tempSelectedCategories = <Category>[];
  Complexity _complexity = Complexity.easy;
  var _affordability = Affordability.unknown;
  int iAffordability = 0;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.meal.title;
    _linkController.text = widget.meal.recipeUrl.toString();
    _instructionsController.text = widget.meal.instructions.toString();
    _durationController.text = widget.meal.duration.toString();
    ingredients = widget.meal.ingredients!;
    _selectedCategories = widget.meal.categories;
    _complexity = widget.meal.complexity!;
    _affordability = widget.meal.affordability!;
    imageUrl = widget.meal.imageUrl;
    mapAffordability();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure all inputs are valid, remember only the recipe name is required."),
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
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Invalid Input",
              style: Theme.of(context).primaryTextTheme.titleLarge),
          content: Text(
              "Please make sure all inputs are valid, remember only the recipe name is required.",
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

  void _setImage(File img) {
    imageUrl = img.path;
  }

  void _submitNewMeal() {
    final enteredDuration = int.tryParse(_durationController.text);
    final durationIsInvalid = enteredDuration == null || enteredDuration <= 0;
    int? duration = null;

    if (_titleController.text.trim().isEmpty ||
        _selectedCategories.isEmpty ||
        (durationIsInvalid && _durationController.text.trim().isNotEmpty)) {
      _showDialog();
      return;
    }

    if (_durationController.text.trim().isNotEmpty) {
      duration = enteredDuration;
    }

    widget.meal.title = _titleController.text;
    widget.meal.categories = _selectedCategories;

    widget.meal.recipeUrl = _linkController.text;
    widget.meal.ingredients = ingredients;
    widget.meal.instructions = _instructionsController.text;
    widget.meal.affordability = _affordability;
    widget.meal.complexity = _complexity;
    widget.meal.duration = duration;

    updateMeal(widget.meal);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _instructionsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void mapAffordability() {
    if (_affordability == Affordability.affordable) {
      iAffordability = 1;
    } else if (_affordability == Affordability.pricey) {
      iAffordability = 2;
    } else if (_affordability == Affordability.luxurious) {
      iAffordability = 3;
    } else {
      iAffordability = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = ref.watch(firebaseCategoriesProvider).when(
          data: (availableCategories) => availableCategories,
          loading: () =>
              [], // Return an empty list or handle loading state accordingly
          error: (error, stack) {
            // Handle error state accordingly, for now, returning an empty list
            print('Error: $error');
            return [];
          },
        );
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    String formatFloat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
    }

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardPadding + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Recipe Name *"),
                  ),
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text("Photo",
                    style: Theme.of(context).primaryTextTheme.bodyLarge),
                MealImagePicker(
                  onSelectMeal: _setImage,
                  existingImage: imageUrl,
                ),
                Row(
                  children: [
                    Text("Categories *",
                        style: Theme.of(context).primaryTextTheme.bodyLarge),
                    IconButton(
                      onPressed: () {
                        _tempSelectedCategories = _selectedCategories;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext ctx,
                                        StateSetter setTempState) =>
                                    AlertDialog(
                                  title: Text("Choose Categories",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleLarge),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for (var category
                                            in availableCategories)
                                          CheckboxListTile(
                                            value: _tempSelectedCategories
                                                .contains(category),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (checked) {
                                              setTempState(() {
                                                if (checked!) {
                                                  _tempSelectedCategories
                                                      .add(category);
                                                } else {
                                                  _tempSelectedCategories
                                                      .remove(category);
                                                }
                                              });
                                            },
                                            title: Text(
                                              category.title!,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyMedium,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);

                                        setState(() {
                                          _selectedCategories =
                                              _tempSelectedCategories;
                                        });
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                if (_selectedCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No categories selected... ",
                        style: Theme.of(context).primaryTextTheme.bodyMedium),
                  )
                else
                  for (var category in _selectedCategories)
                    Card(
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
                            Text(category.title!,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(width: 16),
                TextField(
                  controller: _linkController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("URL to recipe"),
                  ),
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Ingredients",
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                useSafeArea: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (ctx) => NewMealIngredientModal(
                                  ingredients: ingredients,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: ReorderableListView.builder(
                          itemBuilder: (ctx, index) => Dismissible(
                            background: Container(
                                color: Theme.of(context).colorScheme.error,
                                margin: Theme.of(context).cardTheme.margin),
                            key: ValueKey(ingredients[index]),
                            onDismissed: (direction) {
                              setState(() {
                                ingredients.removeAt(index);
                              });
                            },
                            child: InkWell(
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
                                      Text(
                                          "${formatFloat(ingredients[index].quantity)} ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Text(
                                          "${ingredients[index].measurement.name} ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Text(ingredients[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          itemCount: ingredients.length,
                          shrinkWrap: true,
                          primary: false,
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
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _instructionsController,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 32,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    label: Text("Instructions"),
                  ),
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Duration (minutes)"),
                          ),
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 32),
                      DropdownButton(
                        value: Complexity.easy,
                        items: Complexity.values
                            .where((element) => element != Complexity.unknown)
                            .map(
                              (complexity) => DropdownMenuItem(
                                value: complexity,
                                child: Text(complexity.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              _complexity = value;
                            }
                          });
                        },
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      const SizedBox(width: 32),
                      SizedBox(
                        width: 20,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (iAffordability == 1) {
                                _affordability = Affordability.unknown;
                                iAffordability = 0;
                              } else {
                                _affordability = Affordability.affordable;
                                iAffordability = 1;
                              }
                            });
                          },
                          child: Text(
                            "\$",
                            style: TextStyle(
                                color: ((iAffordability > 0)
                                    ? Colors.white
                                    : Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (iAffordability == 2) {
                                _affordability = Affordability.unknown;
                                iAffordability = 0;
                              } else {
                                _affordability = Affordability.pricey;
                                iAffordability = 2;
                              }
                            });
                          },
                          child: Text(
                            "\$",
                            style: TextStyle(
                                color: ((iAffordability > 1)
                                    ? Colors.white
                                    : Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (iAffordability == 3) {
                                iAffordability = 0;
                                _affordability = Affordability.unknown;
                              } else {
                                iAffordability = 3;
                                _affordability = Affordability.luxurious;
                              }
                            });
                          },
                          child: Text(
                            "\$",
                            style: TextStyle(
                              color: ((iAffordability > 2)
                                  ? Colors.white
                                  : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _submitNewMeal,
                      child: const Text("Update Recipe"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
