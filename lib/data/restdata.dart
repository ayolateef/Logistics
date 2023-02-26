import 'dart:async';

import '../model/ChatMessage.dart';
import '../model/account.dart';
import '../model/chatusers.dart';
import '../model/driver.dart';
import '../model/notifications.dart';
import '../model/pickorders.dart';
import '../model/stats.dart';
import '../model/statsprice.dart';
import '../services/RestData/RestDataServices.dart';
import '../utils/network_util.dart';

class RestDataImpl implements RestDataService {
  final NetworkUtil _netUtil = NetworkUtil();
  static const BASE_URL = "https://courierx-backend-staging.lampnets.com";
  static const LOGIN_URL = "$BASE_URL/login";
  static const createnewaccturl = "$BASE_URL/profiles/addnewaccount";
  static const getcreateaccount = "$BASE_URL/profiles/email";
  static const createphoneno = "$BASE_URL/profiles/phonecode";
  static const loginurl = "$BASE_URL/login";
  static const loggedinusers = "$BASE_URL/profiles/loggedadmin";
  static const addpickup = "$BASE_URL/pickuporders/addone";
  static const changepasskey = BASE_URL + "/profiles/changepasskey";
  static const changephone = BASE_URL + "/profiles/setphonecode";
  static const editprofileurl = BASE_URL + "/profiles/editprofileadmin";
  static const addprice = BASE_URL + "/pickuporders/addPrice";
  static const getordersurl = BASE_URL + "/pickuporders/email";
  static const getallordersurl = BASE_URL + "/pickuporders";
  static const getnotifyurl = BASE_URL + "/notification";
  static const getonenotifyurl = BASE_URL + "/notification/email";
  static const addnotifysurl = BASE_URL + "/notification/addone";
  static const deletnotifyurl = BASE_URL + "/notification/delete";
  static const addstatnos = BASE_URL + "/pickuporders/addstatno";
  static const adddriverurl = BASE_URL + "/pickuporders/adddriver";
  static const driversurl = BASE_URL + "/drivers";
  static const statsneturl = BASE_URL + "/pickuporders/statistics";
  static const statspriceurl = BASE_URL + "/pickuporders/statisticsprice";
  static const changephoto = BASE_URL + "/profiles/changeavataradmin";
  static const chatusers = BASE_URL + "/profiles/allusersonchat";
//  static final _API_KEY = "somerandomkey";

  @override
  Future<String> login(String username, String password) {
    return _netUtil
        .getloginpost(loginurl, body: toMap(username, password))
        .then((dynamic res) {
      print(res.toString());
      if (res == null) throw Exception("error_msg");
      return res;
    });
  }

  @override
  Future<Account> accountGet(String username, String password) {
    return _netUtil.getlogin(loggedinusers).then((dynamic res) {
      print(res.toString());
      if (res["error"]) throw Exception(res["error_msg"]);
      return Account.map(res);
    });
  }

  Future editProfile(String token, {Map? body}) {
    return _netUtil.editprofile(editprofileurl, token, body: body!);
  }

  @override
  Future<Account> editPhoto(
      String token, String email, String path, String name) {
    return _netUtil.editprofile2(changephoto, token,
        body: toMap7(email, path, name));
  }

  @override
  Future<Notifications> deleteprofile(String token, {Map? body}) {
    return _netUtil.deletenotifyone(deletnotifyurl, token, body: body!);
  }

  @override
  Future<Account> getloggedin(String username) async {
    // await Future<Account>.delayed(const Duration(seconds: 8));
    return _netUtil.getLoggedInNet(
      loggedinusers,
      body: toMap2(username),
    );
    //     .then((dynamic res) {
    //   print(res.toString());
    //   //  if (res["error"]) throw new Exception(res["error_msg"]);
    //   return new Account.map(res);
    // });
  }

  @override
  Future<Account> createAccountGet({Map? body}) {
    return _netUtil
        .getcreateaccount(getcreateaccount, body: body!)
        .then((dynamic res) {
      print(res.toString());
      // if (res["error"]) throw new Exception(res["error_msg"]);
      return Account(
          res['username'],
          res['email'],
          res['phone'],
          res['userAvatar'],
          res['userAvatarInternet'],
          res['gender'],
          res['dateOfBirth'],
          res['inBasket'],
          res['notifyCount']);
    });
  }

  @override
  Future<String> createNewAccount({Map? body}) async {
    return _netUtil
        .createNewAccount(createnewaccturl, body: body!)
        .then((dynamic res) {
      print(res.toString());
      String result = res;

      return result;
    });
  }

  @override
  Future<List<ChatMessage>> getMessage(String token, String url,
      {Map? body}) async {
    return _netUtil.getMessagesDTO(url, token, body: body!);
  }

  Future<List<ChatUsers>> getChatsUsers(String token, {Map? body}) async {
    return _netUtil.getChatUsers(chatusers, token, body: body!);
  }

  @override
  Future<String> addStatNo(String token, int id) async {
    return _netUtil
        .addStat(addstatnos, token, body: toMap4(id))
        .then((dynamic res) {
      print(res.toString());
      String result = res;

      return result;
    });
  }

  @override
  Future<String> adddriver(String token, int id, String driverid) async {
    return _netUtil
        .addDriver(adddriverurl, token, body: toMap5(id, driverid))
        .then((dynamic res) {
      print(res.toString());
      String result = res;

      return result;
    });
  }

  Future<Future> createPickUpOrders(String token, {Map? body}) async {
    return _netUtil.addpickuporder(addpickup, token, body: body!);
    // .then((dynamic res) {
    // print(res.toString());
    // //   String result = res;

    //   return result;
  }

  Future<Future> pickUpPrice(String token, {Map? body}) async {
    return _netUtil.addpickuporder(addprice, token, body: body!);
    // .then((dynamic res) {
    // print(res.toString());
    // //   String result = res;

    //   return result;
  }

  @override
  Future<List<Pickorders>> getOrders(String token, {Map? body}) async {
    return _netUtil.getorders(getordersurl, token, body: body!);
  }

  @override
  Future<List<Pickorders>> getOrdersAll(String token) async {
    return _netUtil.getordersalll(getallordersurl, token);
  }

  @override
  Future<List<Driver>> getAllDrivers(String token, {Map? body}) async {
    return _netUtil.getDrivers(driversurl, token, body: body!);
  }

  @override
  Future<List<Notifications>> getNotify(String token, {Map? body}) async {
    return _netUtil.getNotifyOne(getonenotifyurl, token, body: body!);
  }

  @override
  Future<Statsprice> getStatsPrice(String token) async {
    return _netUtil.statsPriceNet(statspriceurl, token);
  }

  @override
  Future<Stats> getStats(String token) async {
    return _netUtil.statsNet(statsneturl, token);
  }

  Future<String> changePassword(String token, {Map? body}) async {
    return _netUtil.changepassword(changepasskey, token, body: body!);
    // .then((dynamic res) {
    // print(res.toString());
    // //   String result = res;

    //   return result;
  }

  @override
  Future<String> createphone({Map? body}) async {
    return _netUtil.phoneReg(createphoneno, body: body!).then((dynamic res) {
      print(res.toString());
      String result = res;

      return result;
    });
  }

  Map<String, dynamic> toMap(String username, String password) {
    var map = <String, dynamic>{};

    map["username"] = username;
    map["password"] = password;

    return map;
  }

  Map<String, dynamic> toMap2(String username) {
    var map = <String, dynamic>{};
    print("map for ddd");
    print(username);
    map["username"] = username;

    return map;
  }

  Map<String, dynamic> toMap3(String name, String address, String phone,
      String mobilephone, String pcategory, String packages, String desc) {
    var map = <String, dynamic>{};
    //  print("map for ddd");
    //  print(username);
    map["name"] = name;
    map["address"] = address;
    map["phone"] = phone;
    map["mobilephone"] = mobilephone;
    map["pcategory"] = pcategory;
    map["packages"] = packages;
    map["desc"] = desc;

    return map;
  }

  Map<String, dynamic> toMap4(int id) {
    var map = <String, dynamic>{};

    map["id"] = id;

    return map;
  }

  Map<String, dynamic> toMap5(int id, String driverid) {
    var map = <String, dynamic>{};

    map["id"] = id;
    map["driverid"] = driverid;

    return map;
  }

  Map<String, dynamic> toMap7(String email, String path, String name) {
    var map = <String, dynamic>{};

    map["email"] = email;
    map["userAvatar"] = path;
    map["userAvatarInternet"] = name;
    return map;
  }

  Account getloggedaccount(String username) {
    Account? result;
//print(username);
//Account test = await tryrest.getloggedin(username);
    Future<Future> _accounts = getloggedin(username) as Future<Future>;
    _accounts.then((value) {
      result = value as Account;
      //  _showSnackBar(result);
      if (result != null) {
        //  print(value);
        print("logged account 1t");
        print(result?.email);
        //   print(result.);
      }
      // return result;
    });
    //  Account results = await _accounts;

    return result!;
  }

  @override
  Future<List<ChatUsers>> getChatsUSers(String token, {Map? body}) {
    // TODO: implement getChatsUSers
    throw UnimplementedError();
  }
}
