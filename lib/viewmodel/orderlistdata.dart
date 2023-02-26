import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:geocoder_location/geocoder.dart';

import '../model/order.dart';
import '../model/orderdetails.dart';
import '../model/pickorders.dart';
import '../servicelocator.dart';
import '../services/RestData/RestDataServices.dart';

class OrderListDataViewModel extends ChangeNotifier {
  // static CreateAccountProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<CreateAccountProvider>(context, listen: listen);

  // String _prevSearchTerm = "";

  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final List<Order> _orders = [];
  String gapIKey = "AIzaSyA_O-vvaa6KAqb6GYHzh4A7BLFr-FHE6l8";

  Future<List<Order>> orders(String token, String email) async {
    List<Pickorders> pickup = await _restdataService.getordersall(token);
    print(pickup);
    for (int i = 0; i < pickup.length; i++) {
      debugPrint("orderListData orders query: ${pickup[i].long2}");

      if (pickup[i].payment == "Paid" ||
          pickup[i].payment == "Pay on Delivery") {
        final query = pickup[i].senderlocation;
        var lat1 = pickup[i].lat1;
        var long1 = pickup[i].long1;
        var lat2 = pickup[i].lat2;
        var long2 = pickup[i].long2;
        debugPrint("orderlistdata orders query: ${pickup[i].long2}");
        // debugPrint("orderlistdata orders addresses: ${double.parse(addresses[0].coordinates.longitude.toString())}");

        final query2 = pickup[i].youurlocation;

        String? str = pickup[i].amount;
        String? amtPrice = str?.replaceAll("N", "");
        double amt = double.parse(amtPrice!);
        if (lat1 != null && long1 != null && lat2 != null && long2 != null) {
          Order order = Order(
            i.toString(),
            pickup[i].id!,
            pickup[i].date!,
            "\N",
            amt,
            pickup[i].payment!,
            pickup[i].distance?.toInt() ?? 0,
            pickup[i].senderlocation ?? '',
            pickup[i].youurlocation ?? '',
            pickup[i].statno!,
            double.parse(lat1),
            double.parse(long1),
            double.parse(lat2),
            double.parse(long2),
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
                  image: "assets/selectImage.png"),
            ],
            pickup[i]?.driverid ?? '',
          );
          _orders.add(order);
        }
      }
    }
    debugPrint("orderlistdata orders latitude: ${_orders.length}");

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
