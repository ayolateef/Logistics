class Pickorders {
  int? _id;
  String? _name;
  String? _address;
  String? _phone;
  String? _mobilephone;
  String? _pcategory;
  String? _packages;
  String? _description;
  String? _youurlocation;
  String? _senderlocation;
  double? _distance;
  String? _amount;
  String? _comments;
  String? _payment;
  String? _date;
  int? _statno;
  String? _driverid;

  Pickorders(
      this._id,
      this._name,
      this._address,
      this._phone,
      this._mobilephone,
      this._pcategory,
      this._packages,
      this._description,
      this._youurlocation,
      this._senderlocation,
      this._distance,
      this._amount,
      this._comments,
      this._payment,
      this._date,
      this._statno,
      this._driverid);

  Pickorders.map(dynamic obj) {
    _id = obj['id'];
    _name = obj['name'];
    _address = obj['address'];
    _phone = obj['phone'];
    _mobilephone = obj['mobilephone'];
    _pcategory = obj['pcategory'];
    _packages = obj['packages'];
    _description = obj['desc'];
    _youurlocation = obj['youurlocation'];
    _senderlocation = obj['senderlocation'];
    _distance = obj['distance'];
    _amount = obj['amount'];
    _comments = obj['comments'];
    _payment = obj['payment'];
    _date = obj['date'];
    _statno = obj['statno'];
    _driverid = obj['driverid'];
  }
  int? get id => _id;
  String? get name => _name;
  String? get address => _address;
  String? get phone => _phone;
  String? get mobilephone => _mobilephone;
  String? get pcategory => _pcategory;
  String? get packages => _packages;
  String? get description => _description;
  String? get youurlocation => _youurlocation;
  String? get senderlocation => _senderlocation;
  double? get distance => _distance;
  String? get amount => _amount;
  String? get comments => _comments;
  String? get payment => _payment;
  String? get date => _date;
  int? get statno => _statno;
  String? get driverid => _driverid;

  void setphone(String phone) {
    _phone = phone;
  }

  void setprice(String price) {
    _amount = price;
  }

  void setcomments(String comments) {
    _comments = comments;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map["name"] = _name;
    map["address"] = _address;
    map["phone"] = _phone;
    map["mobilephone"] = _mobilephone;
    map["pcategory"] = _pcategory;
    map["packages"] = _packages;
    map["description"] = _description;
    map["youurlocation"] = _youurlocation;
    map["senderlocation"] = _senderlocation;
    map["distance"] = _distance;
    map["amount"] = _amount;
    map["comments"] = _comments;
    map["payment"] = _payment;
    map["date"] = _date;
    map["statno"] = _statno;
    map["driverid"] = _driverid;
    return map;
  }

  factory Pickorders.fromJson(Map<String, dynamic> data) {
    return Pickorders(
      data["id"],
      data["name"],
      data["address"],
      data["phone"],
      data["mobilephone"],
      data["pcategory"],
      data["packages"],
      data["description"],
      data["youurlocation"],
      data["senderlocation"],
      data["distance"],
      data["amount"],
      data["comments"],
      data["payment"],
      data["date"],
      data["statno"],
      data["driverid"],
    );
  }
}
