import 'package:flutter/material.dart';

import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/scheduled_meal.dart';

// Constants in Dart should be written in lowerCamelcase.
final availableCategories = [
  Category(
    title: 'Italian',
    color: Colors.purple,
  ),
  Category(
    title: 'Quick & Easy',
    color: Colors.red,
  ),
  Category(
    title: 'Hamburgers',
    color: Colors.orange,
  ),
  Category(
    title: 'German',
    color: Colors.amber,
  ),
  Category(
    title: 'Light & Lovely',
    color: Colors.blue,
  ),
  Category(
    title: 'Exotic',
    color: Colors.green,
  ),
  Category(
    title: 'Breakfast',
    color: Colors.lightBlue,
  ),
  Category(
    title: 'Asian',
    color: Colors.lightGreen,
  ),
  Category(
    title: 'French',
    color: Colors.pink,
  ),
  Category(
    title: 'Summer',
    color: Colors.teal,
  ),
];

final dummyMeals = [
  Meal(
    id: 'm1',
    categories: [
      availableCategories[0],
      availableCategories[1],
    ],
    title: 'Spaghetti with Tomato Sauce',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
    recipeUrl:
        "https://www.allrecipes.com/recipes/505/main-dish/pasta/spaghetti/",
  ),
  Meal(
    id: 'm2',
    categories: [
      availableCategories[1],
    ],
    title: 'Toast Hawaii',
    affordability: Affordability.affordable,
    complexity: Complexity.easy,
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
    duration: 10,
    ingredients: [
      Ingredient(
          title: "White Bread", measurement: Measurement.slice, quantity: 1),
      Ingredient(title: "Ham", measurement: Measurement.slice, quantity: 1),
      Ingredient(
          title: "Pineapple", measurement: Measurement.slice, quantity: 1),
      Ingredient(title: "Cheese", measurement: Measurement.slice, quantity: 2),
      Ingredient(
          title: "Butter", measurement: Measurement.tablespoon, quantity: 1),
    ],
    instructions:
        "Butter one side of the white bread \nLayer ham the pineapple and cheese on the white bread \nBake the toast for round about 10 minutes in the oven at 200°C",
    isGlutenFree: false,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm3',
    categories: [
      availableCategories[1],
      availableCategories[2],
    ],
    title: 'Classic Hamburger',
    affordability: Affordability.pricey,
    complexity: Complexity.easy,
    imageUrl:
        'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
    duration: 45,
    ingredients: [
      Ingredient(
          title: "Cattle Hack", measurement: Measurement.gram, quantity: 300),
      Ingredient(title: "Tomato", measurement: Measurement.medium, quantity: 1),
      Ingredient(
          title: "Cucumber", measurement: Measurement.medium, quantity: 1),
      Ingredient(title: "Onion", measurement: Measurement.medium, quantity: 1),
      Ingredient(
          title: "Ketchup", measurement: Measurement.teaspoon, quantity: 1),
      Ingredient(title: "Buns", measurement: Measurement.teaspoon, quantity: 2),
    ],
    instructions:
        "Form 2 patties \nFry the patties for c. 4 minutes on each side \nQuickly fry the buns for c. 1 minute on each side \nBruch buns with ketchup \nServe burger with tomato cucumber and onion",
    isGlutenFree: false,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm4',
    categories: [
      availableCategories[3],
    ],
    title: 'Wiener Schnitzel',
    affordability: Affordability.luxurious,
    complexity: Complexity.challenging,
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/03/31/19/29/schnitzel-3279045_1280.jpg',
    duration: 60,
    ingredients: [
      Ingredient(
          title: "Veal Cutlets", measurement: Measurement.other, quantity: 8),
      Ingredient(title: "Eggs", measurement: Measurement.medium, quantity: 4),
      Ingredient(
          title: "Bread Crumbs", measurement: Measurement.gram, quantity: 200),
      Ingredient(title: "Flour", measurement: Measurement.gram, quantity: 100),
      Ingredient(
          title: "Butter", measurement: Measurement.milliliter, quantity: 300),
      Ingredient(
          title: "Vegetable Oil", measurement: Measurement.gram, quantity: 100),
      Ingredient(title: "Salt", measurement: Measurement.dash, quantity: 1),
      Ingredient(title: "Lemon", measurement: Measurement.medium, quantity: 1),
    ],
    instructions:
        "Tenderize the veal to about 2–4mm and salt on both sides. \nOn a flat plate stir the eggs briefly with a fork. \nLightly coat the cutlets in flour then dip into the egg and finally coat in breadcrumbs. \nHeat the butter and oil in a large pan (allow the fat to get very hot) and fry the schnitzels until golden brown on both sides. \nMake sure to toss the pan regularly so that the schnitzels are surrounded by oil and the crumbing becomes ‘fluffy’. \nRemove and drain on kitchen paper. Fry the parsley in the remaining oil and drain. \nPlace the schnitzels on awarmed plate and serve garnishedwith parsley and slices of lemon.",
    isGlutenFree: false,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm5',
    categories: [
      availableCategories[1],
      availableCategories[4],
      availableCategories[9],
    ],
    title: 'Salad with Smoked Salmon',
    affordability: Affordability.luxurious,
    complexity: Complexity.easy,
    imageUrl:
        'https://cdn.pixabay.com/photo/2016/10/25/13/29/smoked-salmon-salad-1768890_1280.jpg',
    duration: 15,
    ingredients: [
      Ingredient(
          title: "Arugula", measurement: Measurement.serving, quantity: 1),
      Ingredient(
          title: "Lamb's Lettuce",
          measurement: Measurement.serving,
          quantity: 1),
      Ingredient(
          title: "Parsley", measurement: Measurement.serving, quantity: 1),
      Ingredient(
          title: "Fennel", measurement: Measurement.teaspoon, quantity: 1),
      Ingredient(
          title: "Smoked Salmon", measurement: Measurement.gram, quantity: 200),
      Ingredient(
          title: "Mustard", measurement: Measurement.serving, quantity: 1),
      Ingredient(
          title: "Balsamic Vinegar",
          measurement: Measurement.teaspoon,
          quantity: 1),
      Ingredient(
          title: "Olive Oil", measurement: Measurement.teaspoon, quantity: 1),
      Ingredient(
          title: "Salt and Pepper", measurement: Measurement.dash, quantity: 1),
    ],
    instructions:
        "Wash and cut salad and herbs \nDice the salmon \nProcess mustard, vinegar and olive oil into a dessing \nPrepare the salad \nAdd salmon cubes and dressing",
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm6',
    categories: [
      availableCategories[5],
      availableCategories[9],
    ],
    title: 'Delicious Orange Mousse',
    affordability: Affordability.affordable,
    complexity: Complexity.hard,
    imageUrl:
        'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_1280.jpg',
    duration: 240,
    ingredients: [
      Ingredient(
          title: "Sheets of Gelatine",
          measurement: Measurement.other,
          quantity: 4),
      Ingredient(
          title: "Orange Juice",
          measurement: Measurement.milliliter,
          quantity: 150),
      Ingredient(title: "Sugar", measurement: Measurement.gram, quantity: 80),
      Ingredient(
          title: "Yoghurt", measurement: Measurement.gram, quantity: 300),
      Ingredient(title: "Cream", measurement: Measurement.gram, quantity: 200),
    ],
    instructions:
        "Dissolve gelatine in pot \nAdd orange juice and sugar \nTake pot off the stove \nAdd 2 tablespoons of yoghurt \nStir gelatin under remaining yoghurt \nCool everything down in the refrigerator \nWhip the cream and lift it under die orange mass \nCool down again for at least 4 hours \nServe with orange peel",
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm7',
    categories: [
      availableCategories[6],
    ],
    title: 'Pancakes',
    affordability: Affordability.affordable,
    complexity: Complexity.easy,
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/07/10/21/23/pancake-3529653_1280.jpg',
    duration: 20,
    ingredients: [
      Ingredient(
          title: "AP Flour", measurement: Measurement.cup, quantity: 1.5),
      Ingredient(
          title: "Salt", measurement: Measurement.teaspoon, quantity: 3.5),
      Ingredient(
          title: "White Sugar",
          measurement: Measurement.tablespoon,
          quantity: 1),
      Ingredient(title: "Milk", measurement: Measurement.cup, quantity: 1.25),
      Ingredient(title: "Egg", measurement: Measurement.medium, quantity: 1),
      Ingredient(
          title: "Butter (melted)",
          measurement: Measurement.tablespoon,
          quantity: 3),
    ],
    instructions:
        "In a large bowl sift together the flour baking powder salt and sugar. \nMake a well in the center and pour in the milk egg and melted butter; mix until smooth. \nHeat a lightly oiled griddle or frying pan over medium high heat. \nPour or scoop the batter onto the griddle using approximately 1/4 cup for each pancake. Brown on both sides and serve hot.",
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm8',
    categories: [
      availableCategories[7],
    ],
    title: 'Creamy Indian Chicken Curry',
    affordability: Affordability.pricey,
    complexity: Complexity.challenging,
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/06/18/16/05/indian-food-3482749_1280.jpg',
    duration: 35,
    ingredients: [
      Ingredient(
          title: "Chicken Breasts",
          measurement: Measurement.piece,
          quantity: 4),
      Ingredient(title: "Onion", measurement: Measurement.large, quantity: 1),
      Ingredient(title: "Garlic", measurement: Measurement.clove, quantity: 2),
      Ingredient(title: "Ginger", measurement: Measurement.piece, quantity: 1),
      Ingredient(
          title: "Almonds", measurement: Measurement.tablespoon, quantity: 4),
      Ingredient(
          title: "Coconut Milk",
          measurement: Measurement.milliliter,
          quantity: 500),
    ],
    instructions:
        "Slice and fry the chicken breast\nProcess onion garlic and ginger into paste and sauté everything \nAdd spices and stir fry \nAdd chicken breast + 250ml of water and cook everything for 10 minutes \nAdd coconut milk \nServe with rice",
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm9',
    categories: [
      availableCategories[8],
    ],
    title: 'Chocolate Souffle',
    affordability: Affordability.affordable,
    complexity: Complexity.hard,
    imageUrl:
        'https://cdn.pixabay.com/photo/2014/08/07/21/07/souffle-412785_1280.jpg',
    duration: 45,
    ingredients: [
      Ingredient(
          title: "Butter (Melted)",
          measurement: Measurement.teaspoon,
          quantity: 1),
      Ingredient(
          title: "White Sugar",
          measurement: Measurement.tablespoon,
          quantity: 2),
      Ingredient(
          title: "70% Dark Chocolate",
          measurement: Measurement.ounce,
          quantity: 2),
      Ingredient(
          title: "Butter", measurement: Measurement.tablespoon, quantity: 1),
      Ingredient(
          title: "AP Flour", measurement: Measurement.tablespoon, quantity: 1),
      Ingredient(
          title: "Cold Milk",
          measurement: Measurement.tablespoon,
          quantity: 4.33),
      Ingredient(title: "Salt", measurement: Measurement.pinch, quantity: 1),
      Ingredient(
          title: "Cayenne Pepper", measurement: Measurement.pinch, quantity: 1),
      Ingredient(
          title: "Egg Yolk", measurement: Measurement.large, quantity: 1),
      Ingredient(
          title: "Egg White", measurement: Measurement.large, quantity: 2),
      Ingredient(
          title: "Cream of Tartar",
          measurement: Measurement.pinch,
          quantity: 1),
      Ingredient(
          title: "White Sugar",
          measurement: Measurement.tablespoon,
          quantity: 1),
    ],
    instructions:
        "Preheat oven to 190°C. Line a rimmed baking sheet with parchment paper. \nBrush bottom and sides of 2 ramekins lightly with 1 teaspoon melted butter; cover bottom and sides right up to the rim. \nAdd 1 tablespoon white sugar to ramekins. Rotate ramekins until sugar coats all surfaces. \nPlace chocolate pieces in a metal mixing bowl. \nPlace bowl over a pan of about 3 cups hot water over low heat. \nMelt 1 tablespoon butter in a skillet over medium heat. Sprinkle in flour. Whisk until flour is incorporated into butter and mixture thickens. \nWhisk in cold milk until mixture becomes smooth and thickens. Transfer mixture to bowl with melted chocolate. \nAdd salt and cayenne pepper. Mix together thoroughly. Add egg yolk and mix to combine. \nLeave bowl above the hot (not simmering) water to keep chocolate warm while you whip the egg whites. \nPlace 2 egg whites in a mixing bowl; add cream of tartar. Whisk until mixture begins to thicken and a drizzle from the whisk stays on the surface about 1 second before disappearing into the mix. \nAdd 1/3 of sugar and whisk in. Whisk in a bit more sugar about 15 seconds. \nwhisk in the rest of the sugar. Continue whisking until mixture is about as thick as shaving cream and holds soft peaks 3 to 5 minutes. \nTransfer a little less than half of egg whites to chocolate. \nMix until egg whites are thoroughly incorporated into the chocolate. \nAdd the rest of the egg whites; gently fold into the chocolate with a spatula lifting from the bottom and folding over. \nStop mixing after the egg white disappears. Divide mixture between 2 prepared ramekins. Place ramekins on prepared baking sheet. \nBake in preheated oven until scuffles are puffed and have risen above the top of the rims 12 to 15 minutes.",
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm10',
    categories: [
      availableCategories[1],
      availableCategories[4],
      availableCategories[9],
    ],
    title: 'Asparagus Salad with Cherry Tomatoes',
    affordability: Affordability.luxurious,
    complexity: Complexity.easy,
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/04/09/18/26/asparagus-3304997_1280.jpg',
    duration: 30,
    ingredients: [
      Ingredient(
          title: "White and Green Asparagus",
          measurement: Measurement.bunch,
          quantity: 1),
      Ingredient(
          title: "Pine Nutes", measurement: Measurement.gram, quantity: 30),
      Ingredient(
          title: "Cherry Tomatoes",
          measurement: Measurement.gram,
          quantity: 300),
      Ingredient(title: "Salad", measurement: Measurement.serving, quantity: 1),
      Ingredient(
          title: "Salt, Pepper, and Olive Oil",
          measurement: Measurement.serving,
          quantity: 1),
    ],
    instructions:
        "Wash peel and cut the asparagus \nCook in salted water \nSalt and pepper the asparagus \nRoast the pine nuts \nHalve the tomatoes \nMix with asparagus salad and dressing \nServe with Baguette",
    isGlutenFree: true,
    isVegan: true,
    isVegetarian: true,
    isLactoseFree: true,
  ),
];

var dummyScheduledMeals = [
  ScheduledMeal(day: DateTime.now(), meal: dummyMeals[0]),
  ScheduledMeal(day: DateTime.now(), meal: dummyMeals[2]),
  ScheduledMeal(day: DateTime.now(), meal: dummyMeals[3]),
  ScheduledMeal(day: DateTime.now(), meal: dummyMeals[4]),
  ScheduledMeal(
      day: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 1,
      ),
      meal: dummyMeals[5]),
];

var dummyShoppingList = [
  Ingredient(title: "Salt", measurement: Measurement.teaspoon, quantity: 1),
  Ingredient(title: "Pepper", measurement: Measurement.teaspoon, quantity: 1),
  Ingredient(title: "Sugar", measurement: Measurement.teaspoon, quantity: 1),
  Ingredient(title: "Paprika", measurement: Measurement.teaspoon, quantity: 1),
];
