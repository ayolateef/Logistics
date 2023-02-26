import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../model/Geocodinglocation.dart';
import '../model/order.dart';
import '../model/orderdetails.dart';
import '../model/pickorders.dart';
import '../servicelocator.dart';
import '../services/RestData/RestDataServices.dart';

class OrderListDataViewModel extends ChangeNotifier {
  // static CreateAccountProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<CreateAccountProvider>(context, listen: listen);

  // String _prevSearchTerm = "";

  RestDataService _restdataService = serviceLocator<RestDataService>();
  List<Order> _orders = [];
  String gapikey = "AIzaSyA_O-vvaa6KAqb6GYHzh4A7BLFr-FHE6l8";

  Future<List<Order>> orders(String token, String email) async {
    List<Pickorders>? pickup = await _restdataService.getOrdersAll(token);
    for (int i = 0; i < pickup.length; i++) {
      print(pickup[i].payment);
      print("count - ${i}");
      if (pickup[i].payment == "Paid" ||
          pickup[i].payment == "Pay on Delivery") {
        final query = pickup[i].senderlocation;
        var addresses =
            await Geocoder.google(gapikey).findAddressesFromQuery(query);
        final query2 = pickup[i].youurlocation;
        var addresses2 =
            await Geocoder.google(gapikey).findAddressesFromQuery(query2);
        String? str = pickup[i].amount;
        String amtprice = str?.replaceAll("N", "") ?? '';
        double amt = double.parse(amtprice);
        // print(addresses.first.coordinates.latitude);
        // print(addresses.first.coordinates.longitude);
        // print(addresses2.first.coordinates.latitude);
        // print(addresses2.first.coordinates.latitude);
        Order order = Order(
          i.toString(),
          pickup[i].id ?? 0,
          pickup[i].date ?? '',
          "\N",
          amt,
          pickup[i].payment ?? '',
          pickup[i].distance?.toInt() ?? 0,
          pickup[i].senderlocation ?? '',
          pickup[i].youurlocation ?? '',
          pickup[i].statno ?? 0,
          addresses.first.coordinates.latitude,
          addresses.first.coordinates.longitude,
          addresses2.first.coordinates.latitude,
          addresses2.first.coordinates.longitude,
          pickup[i].phone ?? '',
          pickup[i].name ?? '',
          amt,
          2.3,
          amt,
          [
            OrderDetails(
                id: i.toString(),
                date: pickup[i].date,
                foodName: pickup[i].packages,
                count: 1,
                foodPrice: amt,
                extras: "",
                extrasCount: 0,
                extrasPrice: 0.0,
                image: "assets/selectimage.png"),
          ],
          pickup[i].driverid ?? '',
        );

        _orders.add(order);
      }
    }

    return _orders;
  }

  Future<List<Order>> orders2(String token, String email) async {
    List<Pickorders> pickup = await _restdataService.getOrdersAll(token);
    for (int i = 0; i < pickup.length; i++) {
      print(pickup[i].payment);
      print("count - ${i}");
      if (pickup[i].payment == "Paid" ||
          pickup[i].payment == "Pay on Delivery") {
        final query = pickup[i].senderlocation;
        String url1 =
            "https://maps.googleapis.com/maps/api/geocode/json?address=${query?.replaceAll(' ', '+')}&key=$gapikey";
        // var addresses =
        //     await Geocoder.google(gapikey).findAddressesFromQuery(query);

        var dio = Dio();
        dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
        // dio.options.contentType =
        //     ContentType("application", "x-www-form-urlencoded");
        dio.options.headers["authorization"] = token;
        final response = await dio.get(url1);
        print(response.data.toString());
        Map<String, dynamic> res = jsonDecode(response.toString());
        final int? statusCode = response.statusCode;

        Geocodedata geocodedata = Geocodedata.fromJson(res);

        final query2 = pickup[i].youurlocation;
        String url2 =
            "https://maps.googleapis.com/maps/api/geocode/json?address=${query?.replaceAll(' ', '+')}&key=$gapikey";

        var dio2 = Dio();
        dio2.options.headers['content-Type'] =
            'application/json; charset=UTF-8';
        // dio.options.contentType =
        //     ContentType("application", "x-www-form-urlencoded");
        dio2.options.headers["authorization"] = token;
        final response2 = await dio.get(url2);
        Map<String, dynamic> res2 = jsonDecode(response2.toString());
        print(res);
        print(res2);
        final int? statusCode2 = response.statusCode;

        Geocodedata geocodedata2 = Geocodedata.fromJson(res2);
        // var addresses2 =
        //     await Geocoder.google(gapikey).findAddressesFromQuery(query2);
        String? str = pickup[i].amount;
        String? amtprice = str?.replaceAll("N", "");
        double amt = double.parse(amtprice!);
        // print(addresses.first.coordinates.latitude);
        // print(addresses.first.coordinates.longitude);
        // print(addresses2.first.coordinates.latitude);
        // print(addresses2.first.coordinates.latitude);
        Order order = Order(
          i.toString(),
          pickup[i].id ?? 0,
          pickup[i].date ?? '',
          "\N",
          amt,
          pickup[i].payment ?? '',
          pickup[i].distance?.toInt() ?? 0,
          pickup[i].senderlocation ?? '',
          pickup[i].youurlocation ?? '',
          pickup[i].statno ?? 0,
          geocodedata.results![0].geometry!.location!.lat ?? 0,
          geocodedata.results![0].geometry!.location!.lng ?? 0,
          geocodedata2.results![0].geometry!.location!.lat ?? 0,
          geocodedata2.results![0].geometry!.location!.lng ?? 0,
          pickup[i].phone ?? '',
          pickup[i].name ?? '',
          amt,
          2.3,
          amt,
          [
            OrderDetails(
                id: i.toString(),
                date: pickup[i].date,
                foodName: pickup[i].packages,
                count: 1,
                foodPrice: amt,
                extras: "",
                extrasCount: 0,
                extrasPrice: 0.0,
                image: "assets/selectimage.png"),
          ],
          pickup[i].driverid ?? '',
        );

        _orders.add(order);
      }
    }

    return _orders;
  }

  Map<String, dynamic> toMap(String email) {
    var map = <String, dynamic>{};
    print("map for ddd");
    // print(username);

    map["email"] = email;

    return map;
  }
}
