import 'package:flutter/material.dart';
import 'package:meals_app/widgets/create_category_modal.dart';
import 'package:meals_app/widgets/create_meal_modal.dart';
import 'package:meals_app/widgets/new_ingredient_modal.dart';
import 'package:meals_app/widgets/schedule_meal_modal.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  @override
  Widget build(BuildContext context) {
    String selectedMenu;
    List<PopupMenuItem<String>> menuItems = [];
    menuItems.clear();

    if (widget.pageIndex == 0) {
      selectedMenu = "Schedule Meal";
      menuItems.add(
        const PopupMenuItem<String>(
          value: "Schedule Meal",
          child: Text("Schedule Meal"),
        ),
      );
    } else if (widget.pageIndex == 1) {
      selectedMenu = "Create Category";
      menuItems.add(
        const PopupMenuItem<String>(
          value: "Create Category",
          child: Text("Create Category"),
        ),
      );
      menuItems.add(
        const PopupMenuItem<String>(
          value: "Create Meal",
          child: Text("Create Meal"),
        ),
      );
    } else {
      selectedMenu = "Add to Shopping List";
      menuItems.add(
        const PopupMenuItem<String>(
          value: "Add to Shopping List",
          child: Text("Add to Shopping List"),
        ),
      );
    }
    return PopupMenuButton<String>(
        initialValue: selectedMenu,
        // Callback that sets the selected popup menu item.
        onSelected: (String item) {
          Widget modal;

          if (item == "Schedule Meal") {
            modal = const ScheduleMealModal();
          } else if (item == "Create Category") {
            modal = const CreateCategoryModal();
          } else if (item == "Create Meal") {
            modal = const CreateMealModal();
          } else {
            modal = const NewIngredientModal();
          }

          setState(() {
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (ctx) => modal,
            );
          });
        },
        itemBuilder: (BuildContext context) => menuItems);
  }
}
