
/// The Dish model
class Dish {
  String name;
  String description;
  double price;

  Dish({required this.name, required this.description, required this.price});
}
/// The Dish section model
class DishSection{
  String title;
  List<Dish> dishes;
  DishSection({required this.title,required this.dishes});
}

