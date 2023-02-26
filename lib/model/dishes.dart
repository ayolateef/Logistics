class Dishes {
  String? id;
  String? name;
  int? star;
  String? image;
  String? desc;
  String? restaurant;
  String? restaurantId;
  String? restaurantPhone;
  String? restaurantPhoneMobile;
  double? price;
  double? discPrice;
  String? currency;
  String? ingredients;
  //List<Nutritions> nutritionsdata;
  //List<Extras> extras;
  //List<FoodsReviews> foodsreviews;
  bool? delivered;
  int? count;
  String? category;

  Dishes(
      {this.image,
      this.name,
      this.star,
      this.id,
      this.restaurant,
      this.price,
      this.currency,
      this.count,
      this.desc,
      this.ingredients,
      this.restaurantPhone,
      this.restaurantPhoneMobile,
      this.delivered = false,
      this.restaurantId,
      this.category,
      this.discPrice
      //this.foodsreviews, this.nutritionsdata, this.extras,
      });
}

var dishes = [
  Dishes(
      name: "AVOCADO VEGGIE BOWL",
      image:
          "https://www.valeraletun.ru/adminbsb/public/images/16010335599951-AvocadoVeggie-v2.png",
      id: "1",
      restaurantId: "1",
      desc:
          "Hand-sliced avocado, seasoned black beans, diced onions, fresh diced tomatoes, and fresh romaine and iceberg lettuce blend, served over cilantro lime rice.",
      price: 7.0,
      discPrice: 5.99,
      currency: "\S",
      ingredients:
          "Cilantro Lime Rice, Seasoned Black Beans, Diced Tomatoes, Onions, Romaine & Iceberg Lettuce Blend, Avocado",
      category: "1"),
  Dishes(
      name: "EPIC BEYOND ORIGINAL MEX BURRITO",
      image:
          "https://www.valeraletun.ru/adminbsb/public/images/16010336516051-Hero_Epic-Beyond-Cali-Burrito.png",
      id: "2",
      restaurantId: "1",
      desc:
          "(vegan): Loaded with Beyond meat®, slow-cooked beans made from scratch, cilantro lime rice, fresh guacamole, and handmade pico de gallo, all in a warm, oversized flour tortilla.",
      price: 8.0,
      discPrice: 6.99,
      currency: "\S",
      ingredients:
          "Seasoned Beyond Meat, Tortilla (Epic Burritos), Beans, Cilantro Lime Rice, Guacamole, Salsa, Salsa Seasoning",
      category: "2"),
  Dishes(
      name: "Family style pizza",
      image:
          "https://www.valeraletun.ru/adminbsb/public/images/1600759961871bread4.jpg",
      id: "3",
      restaurantId: "2",
      desc: "serves 4-5, available daily after 11:30am!",
      price: 13.0,
      discPrice: 11.99,
      currency: "\S",
      ingredients: "",
      category: "2"),
  Dishes(
      name: "Layered Vegetable Pie",
      image:
          "https://www.valeraletun.ru/adminbsb/public/images/16010333060581-Hero_Beyond-8-Layer-Burrito.png",
      id: "4",
      restaurantId: "2",
      desc:
          "(vegetarian): Seasoned Beyond Meat plant-based crumbles, beans, guacamole, diced tomatoes, lettuce, cheddar cheese, red sauce, and sour cream.",
      price: 4.0,
      discPrice: 2.99,
      currency: "\S",
      ingredients:
          "230g Sweet Potatoes, peeled  230g Carrots, peeled  1 x large Courgette  1 x pack 2 Red Pointed Peppers  125g Kale  240g bag Baby Spinach Leaves  2 x medium Eggs  200ml Lighter Crème Fraîche",
      category: "2"),
  Dishes(
      name: "Smoked Chicken Wings",
      image:
          "https://www.valeraletun.ru/adminbsb/public/images/1601034750952meat1.jpg",
      id: "5",
      restaurantId: "3",
      desc:
          "Hand Cut Tortilla Chips- With brisket, bacon, and pork. Topped with cheddar cheese, tomatoes, onions, jalapenos & fresh avocado. Then drizzled with sour cream and Jazzy Q (Our sweet and tangy BBQ)",
      price: 8.95,
      discPrice: 6.99,
      currency: "\S",
      ingredients:
          "Brined, rubbed, and smoked…then flashed fried upon order, served dry or with your choice of our house sauces",
      category: "3"),
];
