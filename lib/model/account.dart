import 'package:owner2/model/pref.dart';

import '../main.dart';

class Account {
  String? _userName;
  String? _email;
  String? _phone;
  String? _userAvatar;
  //String token;

  int? _notifyCount = 6;
  String? _currentOrder;
  String? _openOrderOnMap;
  String _backRoute = "";
  String? _backRouteMap;

  bool _initUser = true;
  Account(
      this._userName,
      this._email,
      this._phone,
      this._userAvatar,
      this._currentOrder,
      this._openOrderOnMap,
      this._backRoute,
      this._backRouteMap,
      this._notifyCount);

  Account.map(dynamic obj) {
    _userName = obj['username'];
    _email = obj['email'];
    _phone = obj['phone']; //
    _userAvatar = obj['useravatar'];
    _currentOrder = obj['currentOrder'];
    _openOrderOnMap = obj['openOrderOnMap'];
    _backRoute = obj['backRoute'];
    _notifyCount = obj['notifyCount'];
    _backRouteMap = obj['backRouteMap'];
  }

  String? get userName => _userName;
  String? get email => _email;
  String? get phone => _phone;
  String? get userAvatar => _userAvatar;
  String? get currentOrder => _currentOrder;
  String? get openOrderOnMap => _openOrderOnMap;
  String get backRoute => _backRoute;
  int? get notifyCount => _notifyCount;
  String? get backRouteMap => _backRouteMap;

  void setPhone(String phone) {
    _phone = phone;
  }

  void setAvatar(String image) {
    _userAvatar = image;
  }

  void currentOrderSet(String order) {
    _currentOrder = order;
  }

  void backRouteset(String order) {
    _backRoute = order;
  }

  void openOrderOnMapset(String order) {
    _openOrderOnMap = order;
    print("account map id - $_openOrderOnMap");
  }

  void backRouteMapset(String order) {
    _backRouteMap = order;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["userName"] = _userName;
    map["email"] = _email;
    map["phone"] = _phone;
    map["userAvatar"] = _userAvatar;
    map["currentOrder"] = _currentOrder;
    map["openOrderOnMap"] = _openOrderOnMap;
    map["backRoute"] = _backRoute;
    map["notifyCount"] = _notifyCount;
    map["backRouteMap"] = _backRouteMap;
    return map;
  }

  factory Account.fromJson(Map<String, dynamic> data) {
    return Account(
      data["userName"],
      data["email"],
      data["phone"],
      data["userAvatar"],
      data["currentOrder"],
      data["openOrderOnMap"],
      data["backRoute"],
      data["notifyCount"],
      data["backRouteMap"],
    );
  }

  okUserEnter(String name, String password, String avatar, String _email,
      String _token) {
    _initUser = true;
    _userName = name;
    _userAvatar = avatar;
    _email = _email;
    // token = _token;
    pref.set(Pref.userEmail, _email);
    pref.set(Pref.userPassword, password);
    pref.set(Pref.userAvatar, avatar);
    dprint("User Auth! Save email=$email pass=$password");
  }

  logOut() {
//    _initUser = false;
//    pref.clearUser();
//    userName = "";
//    userAvatar = "";
//    email = "";
//    token = "";
  }

  isAuth() {
    return _initUser;
  }

  Function? _redrawMainWindow;

  setRedraw(Function callback) {
    _redrawMainWindow = callback;
  }

  redraw() {
    _redrawMainWindow!();
  }
}
