import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

class SearchResults extends StatelessWidget {
  const SearchResults(
      {super.key, required this.results, required this.onSelectMeal});

  final results;
  final Function onSelectMeal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                onSelectMeal(results[index]);
              },
              child: ListTile(
                dense: true,
                title: Text(results[index].title,
                    style: Theme.of(context).primaryTextTheme.bodyMedium),
              ),
            );
          }),
    );
  }
}
