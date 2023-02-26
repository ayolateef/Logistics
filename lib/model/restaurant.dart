class Restaurant {
  String? id;
  String? name;
  String? address;
  String? published;
  double? lat;
  double? lng;
  String? image;
  String? phone;
  String? desc;
  String? mobilePhone;
  Restaurant(
      {this.id,
      this.name,
      this.address,
      this.published,
      this.lat,
      this.lng,
      this.image,
      this.phone,
      this.mobilePhone,
      this.desc});
}

var restaurants = [
  Restaurant(
    id: "1",
    name: "Can Alegria Paris",
    address: "73 Rue Jean-Baptiste Pigalle, 75009 Paris",
    lat: 48.881916,
    lng: 2.336729,
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599664647508top1.jpg",
    phone: "+3 4434 3434 3434",
    mobilePhone: "+3 234 3434 3434",
    desc:
        "Our newly refurbished and extended restaurant has been designed with a warm and contemporary feel, carefully designed to enable space yet intimacy.  Again like our lounge bar offering panoramic view of Stanley harbour.",
  ),
  Restaurant(
    id: "2",
    name: "Le Basilic",
    address: "33 Rue Lepic, 75018 Paris",
    lat: 48.886648,
    lng: 2.334182,
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599664705800top2.jpg",
    phone: "+3 4434 3434 3434",
    mobilePhone: "+3 234 3434 3434",
    desc:
        "Our newly refurbished and extended restaurant has been designed with a warm and contemporary feel, carefully designed to enable space yet intimacy.  Again like our lounge bar offering panoramic view of Stanley harbour.",
  ),
  Restaurant(
    id: "3",
    name: "Le Cinq",
    address: "31 Avenue George V",
    lat: 48.869884,
    lng: 2.300196,
    image:
        "https://www.valeraletun.ru/adminbsb/public/images/1599664813213top4.jpg",
    phone: "+3 4434 3434 3434",
    mobilePhone: "+3 234 3434 3434",
    desc:
        "Our newly refurbished and extended restaurant has been designed with a warm and contemporary feel, carefully designed to enable space yet intimacy.  Again like our lounge bar offering panoramic view of Stanley harbour.",
  ),
];
