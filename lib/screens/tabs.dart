import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/calendar.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/shoppinglist.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/widgets/new_ingredient_modal.dart';
import 'package:meals_app/widgets/popup_menu.dart';
import 'package:meals_app/widgets/schedule_meal_modal.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    /*
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
      */
  }

  @override
  Widget build(BuildContext context) {
    //final availableMeals = ref.watch(filteredMealsProvider);
    FloatingActionButton? createButton;
    Widget activePage = const CategoriesScreen();
    var activePageTitle = "Calendar";

    if (_selectedPageIndex == 1) {
      activePage = const CategoriesScreen();
      activePageTitle = "Recipes";
      createButton = null;
    } else if (_selectedPageIndex == 2) {
      activePage = const ShoppingListScreen();
      activePageTitle = "Shopping List";
      createButton = FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (ctx) => const NewIngredientModal(),
            );
          },
          child: const Icon(Icons.add));
    } else {
      activePage = const CalendarScreen();
      activePageTitle = "Calendar";
      createButton = FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (ctx) => const ScheduleMealModal(),
            );
          },
          child: const Icon(Icons.add));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          PopupMenu(pageIndex: _selectedPageIndex),
        ],
      ),
      floatingActionButton: createButton,
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Recipes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Shopping List"),
        ],
      ),
    );
  }
}
