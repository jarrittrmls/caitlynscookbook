import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  Category({
    required this.title,
    this.color = Colors.orange,
    required this.userId,
  }) : id = uuid.v4();

  Category.fromMap(Map<String, dynamic> data) {
    id = data['catid'];
    title = data['title'];
    color = Color(int.parse(data['color'].toString(), radix: 16));
    userId = data['userId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'catid': id,
      'title': title,
      'color': color!.value.toRadixString(16),
      'userId': userId,
    };
  }

  String? id;
  String? title;
  Color? color;
  String? userId;
}
