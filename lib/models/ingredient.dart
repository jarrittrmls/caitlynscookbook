enum Measurement {
  small,
  medium,
  large,
  cup,
  pint,
  quart,
  gallon,
  ounce,
  tablespoon,
  teaspoon,
  gram,
  liter,
  milliliter,
  dash,
  pinch,
  slice,
  clove,
  piece,
  bunch,
  other,
  serving,
}

class Ingredient {
  const Ingredient({
    required this.title,
    required this.measurement,
    required this.quantity,
  });

  final String title;
  final Measurement measurement;
  final double quantity;
}
