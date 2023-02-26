class Driver {
  int? _id;
  bool? _online;
  String? _name;
  String? _phone;
  String? _image;

  Driver(this._id, this._online, this._name, this._phone, this._image);

  int? get id => _id;
  bool? get online => _online;
  String? get name => _name;
  String? get phone => _phone;
  String? get image => _image;

  Driver.map(dynamic obj) {
    _id = obj['id'];
    _online = obj['online'];
    _phone = obj['phone']; //
    _name = obj['name'];
    _image = obj['image'];
  }

  void setphone(String phone) {
    _phone = phone;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["online"] = _online;
    map["phone"] = _phone;
    map["name"] = _name;
    map["image"] = _image;

    return map;
  }

  factory Driver.fromJson(Map<String, dynamic> data) {
    return Driver(
      data["id"],
      data["online"],
      data["name"],
      data["phone"],
      data["image"],
    );
  }
}

// var drivers = [
//   Driver(
//       id: "1",
//       online: true,
//       name: "Arnella Kane",
//       phone: "+3 2344 2343 4434",
//       image:
//           "https://www.valeraletun.ru/adminbsb/public/images/1599681305770user2.jpg"),
//   Driver(
//       id: "2",
//       online: false,
//       name: "Maria",
//       phone: "+3 2344 2343 4434",
//       image: "https://www.valeraletun.ru/codecanyon/fooddel2/user2.jpg"),
//   Driver(
//       id: "3",
//       online: true,
//       name: "Darth Vader",
//       phone: "+3 2344 2343 4434",
//       image:
//           "https://www.valeraletun.ru/adminbsb/public/images/1599681492828user4.jpg"),
//   Driver(
//       id: "4",
//       online: false,
//       name: "Bibee",
//       phone: "+3 2344 2343 4434",
//       image:
//           "https://www.valeraletun.ru/adminbsb/public/images/1599681305770user2.jpg"),
//   Driver(
//       id: "5",
//       online: true,
//       name: "Daniella",
//       phone: "+3 2344 2343 4434",
//       image: "https://www.valeraletun.ru/codecanyon/fooddel2/user2.jpg"),
//   Driver(
//       id: "6",
//       online: true,
//       name: "Tania",
//       phone: "+3 2344 2343 4434",
//       image:
//           "https://www.valeraletun.ru/adminbsb/public/images/1599681492828user4.jpg"),
// ];
