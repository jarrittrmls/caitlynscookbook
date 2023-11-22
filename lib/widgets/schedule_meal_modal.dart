import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/scheduled_meal.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/providers/scheduled_meals_provider.dart';
import 'package:meals_app/widgets/search_results.dart';

class ScheduleMealModal extends ConsumerStatefulWidget {
  const ScheduleMealModal({super.key});

  @override
  ConsumerState<ScheduleMealModal> createState() => _ScheduleMealModalState();
}

class _ScheduleMealModalState extends ConsumerState<ScheduleMealModal> {
  final _searchTextController = TextEditingController();
  DateTime? _selectedDate;
  Meal? _selectedMeal;
  var results = <Meal>[];

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year, now.month, now.day + 14);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid date and meal are selected."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text("Okay",
                  style: Theme.of(context).primaryTextTheme.bodyMedium),
            ),
          ],
        ),
      );
    } else {
      // Android or other platforms
      // Handle the dialog for other platforms if needed
    }
  }

  void _submitNewMeal() {
    if (_selectedDate == null || _selectedMeal == null) {
      _showDialog();
      return;
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    addScheduledMeal(
        ScheduledMeal(day: _selectedDate!, meal: _selectedMeal!, userId: uid));
    Navigator.pop(context);
  }

  void _selectMeal(Meal meal) {
    _selectedMeal = meal;
    _searchTextController.text = meal.title;
    setState(() {
      results.clear();
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final formatter = DateFormat.yMd();
    var scheduledMeals = ref.watch(firebaseMealsProvider).when(
          data: (scheduledMeals) => scheduledMeals,
          loading: () =>
              [], // Return an empty list or handle loading state accordingly
          error: (error, stack) {
            // Handle error state accordingly, for now, returning an empty list
            print('Error: $error');
            return [];
          },
        );

    var meals =
        scheduledMeals.map((scheduledMeal) => scheduledMeal as Meal).toList();

    void _runFilter(String enteredKeyword) {
      List<Meal> tempResults = <Meal>[];
      if (enteredKeyword.isEmpty) {
        tempResults = meals;
        tempResults.clear();
      } else {
        tempResults = meals
            .where((meal) =>
                meal.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      setState(() {
        results = tempResults;
        print(results.length);
      });
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
                Text(
                  "Choose the Meal: ",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        height: 40,
                        child: TextField(
                          controller: _searchTextController,
                          textAlignVertical: TextAlignVertical.bottom,
                          cursorColor: Colors.grey,
                          onSubmitted: (input) {
                            _runFilter(input);
                          },
                          onChanged: (input) {
                            _runFilter(input);
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 18),
                            prefixIcon: Container(
                              padding: EdgeInsets.all(0),
                              width: 12,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (results.isNotEmpty)
                  SearchResults(results: results, onSelectMeal: _selectMeal),
                const SizedBox(height: 32),
                Text(
                  "Choose the Date: ",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? "No date selected"
                          : formatter.format(_selectedDate!),
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
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
                      child: const Text("Schedule Meal"),
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
