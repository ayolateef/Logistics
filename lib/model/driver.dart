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

  void setPhone(String phone) {
    _phone = phone;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
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
