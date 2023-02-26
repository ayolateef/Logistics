class Reviews {
  final String? image;
  final String? name;
  final String? text;
  final String? date;
  final double? star;
  final String? id;
  Reviews({this.image, this.text, this.star, this.id, this.name, this.date});
}

var reviews = [
  Reviews(
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599680805814user1.jpg",
    name: "Jay Rayner",
    text:
        "Fred Foster always dreamed of having a restaurant. He’d supplied fruit and veg to some of the grandest places in London: to the Dorchester and Le Gavroche, and to the great Nico Ladenis in his pomp.",
    date: "2020-08-11 13:15",
    id: "1",
    star: 4.2,
  ),
  Reviews(
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599681202218user.jpg",
    name: "Alexandra Fraser",
    text:
        "A drink for all seasons: A Chelsea grotto that’s the epitome of the tactically-placed wine bar.",
    date: "2020-08-13 14:15",
    id: "2",
    star: 4.6,
  ),
  Reviews(
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599681305770user2.jpg",
    name: "Adrian Kane",
    text:
        "Chicago has a strong pizza identity. We claim two styles as “ours″ (deep dish and tavern) and will ruin a perfectly nice evening debating the best of each. ",
    date: "2020-08-15 18:45",
    id: "3",
    star: 4.0,
  ),
  Reviews(
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599681492828user4.jpg",
    name: "Maria Smith",
    text:
        "On paper, Gotham might not seem like a likely candidate for having some of the city’s best bagels. It’s originally from Madison, Wisconsin (not exactly known for its bagel prowess), and runs its carryout operation out of an Italian restaurant in Old Town. ",
    date: "2020-08-20 09:10",
    id: "4",
    star: 5.0,
  ),
];
