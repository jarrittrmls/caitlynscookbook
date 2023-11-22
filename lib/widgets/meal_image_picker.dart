import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class MealImagePicker extends StatefulWidget {
  MealImagePicker({super.key, required this.onSelectMeal, this.existingImage});

  final Function onSelectMeal;
  String? existingImage;

  @override
  State<MealImagePicker> createState() => _MealImagePickerState();
}

class _MealImagePickerState extends State<MealImagePicker> {
  File? _pickedImageFile;

  void _pickImage(ImageSource src) async {
    final pickedImage = await ImagePicker().pickImage(
      source: src,
      imageQuality: 100,
      maxWidth: 1000,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
      widget.onSelectMeal(_pickedImageFile);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingImage != null) {
      _pickedImageFile = File(widget.existingImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (_pickedImageFile != null)
          Image.file(
            _pickedImageFile!,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt),
            ),
            IconButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.image),
            ),
          ],
        )
      ],
    );
  }
}
