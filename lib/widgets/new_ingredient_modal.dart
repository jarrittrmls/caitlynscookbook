import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/providers/shopping_list_provider.dart';

class NewIngredientModal extends ConsumerStatefulWidget {
  const NewIngredientModal({super.key});

  @override
  ConsumerState<NewIngredientModal> createState() => _NewIngredientModalState();
}

class _NewIngredientModalState extends ConsumerState<NewIngredientModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Measurement _measurement = Measurement.teaspoon;

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid item name, quantity, and measurement was entered."),
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
              "Please make sure a valid item name, quantity, and measurement was entered.",
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

  void _submitNewIngredient() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid) {
      _showDialog();
      return;
    }

    ref.read(shoppingListProvider.notifier).addIngredient(
          Ingredient(
              title: _titleController.text,
              quantity: enteredAmount,
              measurement: _measurement),
        );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardPadding + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Item"),
                          ),
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Quantity"),
                          ),
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Item"),
                    ),
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _measurement,
                        items: Measurement.values
                            .map(
                              (measurement) => DropdownMenuItem(
                                value: measurement,
                                child: Text(measurement.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              _measurement = value;
                            }
                          });
                        },
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Quantity"),
                          ),
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitNewIngredient,
                        child: const Text("Add to Shopping List"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _measurement,
                        items: Measurement.values
                            .map(
                              (measurement) => DropdownMenuItem(
                                value: measurement,
                                child: Text(measurement.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              _measurement = value;
                            }
                          });
                        },
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitNewIngredient,
                        child: const Text("Add to Shopping List"),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
