import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
//import 'package:delivery_owner/services/account/createaccount.dart';
import 'package:provider/provider.dart';

import '../model/account.dart';
import '../model/driver.dart';
import '../model/notifications.dart';
import '../model/pickorders.dart';

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.parse(url)).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getlogin(String url) {
    return http.get(Uri.parse(url)).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }

      return _decoder.convert(res);
    });
  }

  Future<List<Pickorders>> getOrders(String url, String token,
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
    if (statusCode! < 200 || statusCode > 400) {
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

  Future<List<Pickorders>> getOrdersAll(String url, String token) async {
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.get(url);
    List<dynamic> res = response.data;
    final int? statusCode = response.statusCode;

    List<Pickorders> values = <Pickorders>[];
    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        values.add(Pickorders.fromJson(res[i]));
      }
    }

    return values;
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

    List<Notifications> values = <Notifications>[];

    if (statusCode! < 200 || statusCode > 400) {
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
    return values;
    // });
  }

  Future<Notifications> deleteNotifyOne(String url, String token,
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

    //   List<Notifications> values = new List<Notifications>();

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }

    Notifications notify = Notifications.fromJson(res as dynamic);
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

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      print("got her dang");
      print(res);
      Map valueMap = _decoder.convert(res);
      Account account = Account.map(valueMap);
      return account;
    });
  }

  Future<dynamic> getLogInPost(String url, {Map? body}) {
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
      print("network_util: getloginpost: authorixation");
      print("network_util: getloginpost: $authorization");
      print("network_util: getloginpost: $headers");

      if (statusCode < 200 || statusCode > 400) {
        //    throw new Exception("Error while fetching data");
        return "failed";
      }
      if (statusCode == 200) {
        return authorization;
      }

      return authorization;
    });
  }

  Future<dynamic> getCreateAccount(String url, {Map? body}) {
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

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      print(res.toString());
      //   return _decoder.convert(res);

      Map valueMap = _decoder.convert(res);
      Account pick = Account.map(valueMap);
      return valueMap;
    });
  }

  Future<Pickorders> addPickUpOrder(String url, String token,
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

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    //  String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Pickorders pick = Pickorders.map(res);
    return pick;
    // });
  }

  Future<String> changePassword(String url, String token,
      {required Map body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    String res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400) {
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
        .post(Uri.parse(url),
            body: body, headers: headers as dynamic, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> createaccount(String url, {Map? headers, body, encoding}) {
    return http
        .post(Uri.parse(url),
            body: body, headers: headers as dynamic, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
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

      if (statusCode < 200 || statusCode > 400) {
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

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }

      return result;
    });
  }

  Future<Account> editProfile(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Account pick = Account.map(res);
    return pick;
    // });
  }

  Future<Driver> driversProfile(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    if (response == null) {
      print("network_util: driversprofile: null $response");
    }

    print("network_util: driversprofile: 1 ${response.data.toString()}");

    // Map res = response.data;
    var res = response.data;

    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    print("network_util: driversprofile: ${res.toString()}");
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Driver driver = Driver.map(res);
    return driver;
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

    if (statusCode! < 200 || statusCode > 400) {
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

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());

    return res;
    // });
  }

  Future<String> changeStat(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    String res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());

    return res;
    // });
  }

  Future<Account> editProfile2(String url, String token, {Map? body}) async {
    final msg = jsonEncode(body);

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.contentType =
    //     ContentType("application", "x-www-form-urlencoded");
    dio.options.headers["authorization"] = token;
    Response response = await dio.post(url, data: msg);
    Map res = response.data;
    final int? statusCode = response.statusCode;

    if (statusCode! < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    print(res.toString());
    // String valueMap = _decoder.convert(res.toString());
    //  Map mapdata = json.decode(valueMap);
    Account pick = Account.map(res);
    return pick;
    // });
  }
}
