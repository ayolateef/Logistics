import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:courierx_owner/services/account/createaccount.dart';
import 'package:provider/provider.dart';
//import 'package:fooddelivery/model/pickuporder.dart';

import 'package:dio/dio.dart';

import '../model/ChatMessage.dart';
import '../model/account.dart';
import '../model/chatusers.dart';
import '../model/driver.dart';
import '../model/notifications.dart';
import '../model/pickorders.dart';
import '../model/stats.dart';
import '../model/statsprice.dart';

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.parse(url)).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getlogin(String url) {
    return http.get(Uri.parse(url)).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }

      return _decoder.convert(res);
    });
  }

  Future<List<Pickorders>> getorders(String url, String token,
      {Map? body}) async {
    final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    // return http.post(url,headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg).then((http.Response response) {
    // final String res = response.body;
    // final int statusCode = response.statusCode;
    List<Pickorders> values = <Pickorders>[];
    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        //  Map<String,dynamic> map = pickup[i];

        values.add(Pickorders.fromJson(res[i]));
        // debugPrint('Id-------${map['id']}');

      }
    }
    //  values = _decoder.convert(res);
    print(values);
    return values;
    // });
  }

  Future<List<Pickorders>> getordersalll(
    String url,
    String token,
  ) async {
    // final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.get(url);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    // return http.post(url,headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg).then((http.Response response) {
    // final String res = response.body;
    // final int statusCode = response.statusCode;
    List<Pickorders> values = <Pickorders>[];
    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        //  Map<String,dynamic> map = pickup[i];

        values.add(Pickorders.fromJson(res[i]));
        // debugPrint('Id-------${map['id']}');

      }
    }
    //  values = _decoder.convert(res);
    print(values);
    return values;
    // });
  }

  Future<List<Notifications>> getNotifyOne(String url, String token,
      {Map? body}) async {
    final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    // return http.post(url,headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg).then((http.Response response) {
    // final String res = response.body;
    // final int statusCode = response.statusCode;
    List<Notifications> values = <Notifications>[];

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        Notifications notify = Notifications.fromJson(res[i]);
        //  Map<String,dynamic> map = pickup[i];
        if (notify.status == "Active") {
          values.add(notify);
        }
        // debugPrint('Id-------${map['id']}');

      }
    }
    //  values = _decoder.convert(res);
    print(values);
    return values;
    // });
  }

  Future<List<Driver>> getDrivers(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.get(url);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    // return http.post(url,headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg).then((http.Response response) {
    // final String res = response.body;
    // final int statusCode = response.statusCode;
    List<Driver> values = <Driver>[];

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        Driver notify = Driver.fromJson(res[i]);
        //  Map<String,dynamic> map = pickup[i];

        values.add(notify);

        // debugPrint('Id-------${map['id']}');

      }
    }
    //  values = _decoder.convert(res);
    print(values);
    return values;
    // });
  }

  Future<Notifications> deletenotifyone(String url, String token,
      {Map? body}) async {
    final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    var res = response.data;
    final int? statusCode = response.statusCode;

    //   List<Notifications> values = new List<Notifications>();

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }

    Notifications notify = Notifications.fromJson(res);
    //  Map<String,dynamic> map = pickup[i];

    print(notify);
    return notify;
    // });
  }

  Future<Account> getLoggedInNet(String url, {Map? body}) {
    final msg = jsonEncode(body);
    //  print(body.values);
    return http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: msg)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      print("got her dawg");
      print(res);
      Map valueMap = _decoder.convert(res);
      Account account = Account.map(valueMap);
      return account;
    });
  }

  Future<dynamic> getloginpost(String url, {Map? body}) {
    final msg = jsonEncode(body);
    return http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: msg)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      Map<String, String> headers = response.headers;
      String? authorization = headers['authorization'];
      String json = response.body;
      print("authorixation");
      print(authorization);
      print(headers);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        //   throw new Exception("Error while fetching data");
        return "failed";
      }
      if (statusCode == 200) {
        return authorization;
      }

      return authorization;
    });
  }

  Future<dynamic> getcreateaccount(String url, {Map? body}) {
    final msg = jsonEncode(body);
    return http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: msg)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      print(res.toString());
      //   return _decoder.convert(res);

      Map valueMap = _decoder.convert(res);
      Account pick = Account.map(valueMap);
      return valueMap;
    });
  }

  Future<Pickorders> addpickuporder(String url, String token,
      {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    // return dio
    // Dio dio = new Dio();
//     dio.options.headers['content-Type'] = 'application/json';
//     dio.options.headers["authorization"] = "token ${token}";
// //response = await dio.post(url, data: data);
    //     .post(url,
    //         headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg)
    //     .then((http.Response response) {
    //   final String res = response.body;
    //   final int statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    //  String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Pickorders pick = Pickorders.map(res);
    return pick;
    // });
  }

  Future<String> changepassword(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    String res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    //Pickorders pick = Pickorders.map(res);
    return res;
    // });
  }

  Future<dynamic> post(String url, {Map? headers, body, encoding}) {
    return http
        .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> createAccount(String url, {Map? headers, body, encoding}) {
    return http
        .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<String> createNewAccount(String url, {Map? body}) async {
    final msg = jsonEncode(body);
    return http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: msg)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      final String res = response.body;
      final String result = res;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      if (result == "username already exist") {
        return "username exist already";
      }
      if (result == "email already exist") {
        return "email exist already";
      }
      if (result == "user created successfully") {
        return "success";
      }
      return "success";
    });
  }

  Future<String> phoneReg(String url, {Map? body}) async {
    final msg = jsonEncode(body);
    return http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: msg)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      final String res = response.body;
      final String result = res;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }

      return result;
    });
  }

  Future<Account> editprofile(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Account pick = Account.map(res);
    return pick;
    // });
  }

  Future<Statsprice> statsPriceNet(String url, String token) async {
    //   final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Statsprice pick = Statsprice.map(res);
    return pick;
    // });
  }

  Future<Stats> statsNet(String url, String token) async {
    //   final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Stats pick = Stats.map(res);
    return pick;
    // });
  }

  Future<Account> editprofile2(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Account pick = Account.map(res);
    return pick;
    // });
  }

  Future<String> addStat(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    String res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());

    return res;
    // });
  }

  Future<String> addDriver(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    String res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());

    return res;
    // });
  }

  Future<List<ChatMessage>> getMessagesDTO(String url, String token,
      {Map? body}) async {
    final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.get(url);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    // return http.post(url,headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg).then((http.Response response) {
    // final String res = response.body;
    // final int statusCode = response.statusCode;
    List<ChatMessage> values = <ChatMessage>[];

    if (statusCode! < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        ChatMessage notify = ChatMessage.fromJson(res[i]);
        values.add(notify);
      }
    }
    //  values = _decoder.convert(res);
    print(values);
    return values;
    // });
  }

  Future<List<ChatUsers>> getChatUsers(String url, String token,
      {Map? body}) async {
    final msg = jsonEncode(body);
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.get(url);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    // return http.post(url,headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: msg).then((http.Response response) {
    // final String res = response.body;
    // final int statusCode = response.statusCode;
    List<ChatUsers> values = <ChatUsers>[];

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        ChatUsers notify = ChatUsers.fromJson(res[i]);
        values.add(notify);
      }
    }
    //  values = _decoder.convert(res);
    print(values);
    return values;
    // });
  }
}
