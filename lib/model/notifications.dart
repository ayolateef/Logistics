class Notifications {
  int? _id;
  String? _date;
  String? _title;
  String? _text;
  String? _image;
  String? _status;

  Notifications(
      this._id, this._title, this._text, this._date, this._image, this._status);

  Notifications.map(dynamic obj) {
    _id = obj['id'];
    _title = obj['title'];
    _text = obj['text']; //
    _date = obj['date'];
    _image = obj['image'];
    _status = obj['status'];
  }
  int? get id => _id;
  String? get title => _title;
  String? get text => _text;
  String? get date => _date;
  String? get image => _image;
  String? get status => _status;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map["title"] = _title;
    map["text"] = _text;
    map["date"] = _date;
    map["image"] = _image;
    map["status"] = _status;

    return map;
  }

  factory Notifications.fromJson(Map<String, dynamic> data) {
    return Notifications(
      data["id"],
      data["title"],
      data["text"],
      data["date"],
      data["image"],
      data["status"],
    );
  }
}
