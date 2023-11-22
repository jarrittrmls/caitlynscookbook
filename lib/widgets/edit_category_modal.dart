import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/providers/categories_provider.dart';

class EditCategoryModal extends ConsumerStatefulWidget {
  const EditCategoryModal({super.key, required this.category});

  final Category category;

  @override
  ConsumerState<EditCategoryModal> createState() => _EditCategoryModalState();
}

class _EditCategoryModalState extends ConsumerState<EditCategoryModal> {
  final _titleController = TextEditingController();
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.category.title!;
    currentColor = widget.category.color!;
    pickerColor = currentColor;
  }

  void _showColorPicker() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (Color color) {
              setState(() {
                pickerColor = color;
              });
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid category name and color was entered."),
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
    } else {}
  }

  void _updateCategory() {
    if (_titleController.text.trim().isEmpty) {
      _showDialog();
      return;
    }
    widget.category.title = _titleController.text;
    widget.category.color = currentColor;

    updateCategory(widget.category);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardPadding + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Category Title"),
                ),
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
              InkWell(
                onTap: _showColorPicker,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        "Category Color",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.brush),
                        Container(
                          width: 100,
                          height: 25,
                          color: currentColor,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _updateCategory,
                    child: const Text("Update Category"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
