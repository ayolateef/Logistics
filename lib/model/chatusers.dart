import 'package:flutter/cupertino.dart';

class ChatUsers {
  String? _name;
  String? _messageText;
  String? _imageURL;
  String? _time;
  bool? _status;

  ChatUsers(
      this._name, this._messageText, this._imageURL, this._time, this._status);

  ChatUsers.map(dynamic obj) {
    _name = obj['name'];
    _messageText = obj['messageText'];
    _imageURL = obj['imageURL']; //
    _time = obj['time'];
    _status = obj['status'];
  }

  String? get name => _name;
  String? get messageText => _messageText;
  String? get imageURL => _imageURL;
  String? get time => _time;
  bool? get status => _status;

  void setname(String name) {
    _name = name;
  }

  void setmessageText(String messageText) {
    _messageText = messageText;
  }

  void setimageURL(String imageURL) {
    _imageURL = imageURL;
  }

  void settime(String time) {
    _time = time;
  }

  void setstatus(bool status) {
    _status = status;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["messageText"] = _messageText;
    map["imageURL"] = _imageURL;
    map["time"] = _time;
    map["status"] = _status;
    return map;
  }

  factory ChatUsers.fromJson(Map<String, dynamic> data) {
    return ChatUsers(
      data["name"],
      data["messageText"],
      data["imageURL"],
      data["time"],
      data["status"],
    );
  }
}
