import 'geolocator.dart';
import 'orderdetails.dart';

class Order {
  String _id;
  String _date;
  String _currency;
  double _summa;
  String _method; // cache on delivery
  int _distance; // in meters
  String _address1;
  String _address2;
  int _status; // 0 receiver, 1 preparing, 2 ready, 3 on the way, 4 delivered
  double _address1Latitude;
  double _address1Longitude;
  double _address2Latitude;
  double _address2Longitude;
  String _customerName;
  String _phone;
  double _fee;
  double _tax;
  double _total;
  List<OrderDetails> _orderDetails;
  String _driverid;
  int _pid;

  Order(
    this._id,
    this._pid,
    this._date,
    this._currency,
    this._summa,
    this._method,
    this._distance,
    this._address1,
    this._address2,
    this._status,
    this._address1Latitude,
    this._address1Longitude,
    this._address2Latitude,
    this._address2Longitude,
    this._phone,
    this._customerName,
    this._fee,
    this._tax,
    this._total,
    this._orderDetails,
    this._driverid,
  );

  String get id => _id;
  int get pid => _pid;
  String get date => _date;
  String get currency => _currency;
  double get summa => _summa;
  String get method => _method;
  int get distance => _distance;
  String get address1 => _address1;
  int get status => _status;
  String get address2 => _address2;
  double get address1Latitude => _address1Latitude;
  double get address1Longitude => _address1Longitude;
  double get address2Latitude => _address2Latitude;
  double get address2Longitude => _address2Longitude;
  String get customerName => _customerName;
  String get phone => _phone;
  double get fee => _fee;
  double get tax => _tax;
  double get total => _total;
  List<OrderDetails> get orderDetails => _orderDetails;
  String get driverId => _driverid;

  void setdistance(int d) {
    _distance = d;
  }

  void setdriversid(String d) {
    _driverid = d;
  }

  int setstatus(int d) {
    _status = d;
    return _status;
  }
}

// ordersSetDistance() async {
//   var location = Location();
//   for (var item in orders) {
//     double distance = await location.distanceBetween(item.address1Latitude,
//         item.address1Longitude, item.address2Latitude, item.address2Longitude);
//     item.setdistance(distance.toInt());
//   }
// }

// //
//   Order(
//     "212",
//     "2020-07-08 12:35",
//     "\$",
//     212.23,
//     "Cache on Delivery",
//     0,
//     "12-20 Rue Wauthier, 78100 Saint-Germain-en-Laye, France",
//     "Place Charles de Gaulle, 78100 Saint-Germain-en-Laye, France",
//     1,
//     48.895605,
//     2.087823,
//     48.897379,
//     2.094781,
//     "Antoinette Barnier",
//     "+33134510991",
//     2.35,
//     2.35,
//     23.55 - 4.7,
//     [
//       OrderDetails(
//           id: "118",
//           date: "2020-09-26 12:38:06",
//           foodName: "Layered Vegetable Pie",
//           count: 1,
//           foodPrice: 8.89,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/1601032910913000000425960400-IE.jpg"),
//       OrderDetails(
//           id: "119",
//           date: "2020-09-26 12:38:06",
//           foodName: "Original Mex Burrito",
//           count: 2,
//           foodPrice: 7.33,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/16010336516051-Hero_Epic-Beyond-Cali-Burrito.png"),
//     ],
//   ),
//   Order(
//     "213",
//     "2020-07-08 12:35",
//     "\$",
//     212.23,
//     "Cache on Delivery",
//     0,
//     "12-20 Rue Wauthier, 78100 Saint-Germain-en-Laye, France",
//     "Place Charles de Gaulle, 78100 Saint-Germain-en-Laye, France",
//     1,
//     48.895605,
//     2.087823,
//     48.897379,
//     2.094781,
//     "Antoinette Barnier",
//     "+33134510991",
//     2.35,
//     2.35,
//     23.55 - 4.7,
//     [
//       OrderDetails(
//           id: "118",
//           date: "2020-09-26 12:38:06",
//           foodName: "Layered Vegetable Pie",
//           count: 1,
//           foodPrice: 8.89,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/1601032910913000000425960400-IE.jpg"),
//       OrderDetails(
//           id: "119",
//           date: "2020-09-26 12:38:06",
//           foodName: "Original Mex Burrito",
//           count: 2,
//           foodPrice: 7.33,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/16010336516051-Hero_Epic-Beyond-Cali-Burrito.png"),
//     ],
//   ),
//   Order(
//     "214",
//     "2020-07-08 12:35",
//     "\$",
//     212.23,
//     "Cache on Delivery",
//     0,
//     "12-20 Rue Wauthier, 78100 Saint-Germain-en-Laye, France",
//     "Place Charles de Gaulle, 78100 Saint-Germain-en-Laye, France",
//     1,
//     48.895605,
//     2.087823,
//     48.897379,
//     2.094781,
//     "Antoinette Barnier",
//     "+33134510991",
//     2.35,
//     2.35,
//     23.55 - 4.7,
//     [
//       OrderDetails(
//           id: "118",
//           date: "2020-09-26 12:38:06",
//           foodName: "Layered Vegetable Pie",
//           count: 1,
//           foodPrice: 8.89,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/1601032910913000000425960400-IE.jpg"),
//       OrderDetails(
//           id: "119",
//           date: "2020-09-26 12:38:06",
//           foodName: "Original Mex Burrito",
//           count: 2,
//           foodPrice: 7.33,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/16010336516051-Hero_Epic-Beyond-Cali-Burrito.png"),
//     ],
//   ),
//   Order(
//     "215",
//     "2020-07-08 12:35",
//     "\$",
//     212.23,
//     "Cache on Delivery",
//     0,
//     "12-20 Rue Wauthier, 78100 Saint-Germain-en-Laye, France",
//     "Place Charles de Gaulle, 78100 Saint-Germain-en-Laye, France",
//     1,
//     48.895605,
//     2.087823,
//     48.897379,
//     2.094781,
//     "Antoinette Barnier",
//     "+33134510991",
//     2.35,
//     2.35,
//     23.55 - 4.7,
//     [
//       OrderDetails(
//           id: "118",
//           date: "2020-09-26 12:38:06",
//           foodName: "Layered Vegetable Pie",
//           count: 1,
//           foodPrice: 8.89,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/1601032910913000000425960400-IE.jpg"),
//       OrderDetails(
//           id: "119",
//           date: "2020-09-26 12:38:06",
//           foodName: "Original Mex Burrito",
//           count: 2,
//           foodPrice: 7.33,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/16010336516051-Hero_Epic-Beyond-Cali-Burrito.png"),
//     ],
//   ),
//   Order(
//     "216",
//     "2020-07-08 12:35",
//     "\$",
//     212.23,
//     "Cache on Delivery",
//     0,
//     "12-20 Rue Wauthier, 78100 Saint-Germain-en-Laye, France",
//     "Place Charles de Gaulle, 78100 Saint-Germain-en-Laye, France",
//     1,
//     48.895605,
//     2.087823,
//     48.897379,
//     2.094781,
//     "Antoinette Barnier",
//     "+33134510991",
//     2.35,
//     2.35,
//     23.55 - 4.7,
//     [
//       OrderDetails(
//           id: "118",
//           date: "2020-09-26 12:38:06",
//           foodName: "Layered Vegetable Pie",
//           count: 1,
//           foodPrice: 8.89,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/1601032910913000000425960400-IE.jpg"),
//       OrderDetails(
//           id: "119",
//           date: "2020-09-26 12:38:06",
//           foodName: "Original Mex Burrito",
//           count: 2,
//           foodPrice: 7.33,
//           extras: "",
//           extrasCount: 0,
//           extrasPrice: 0.0,
//           image:
//               "https://www.valeraletun.ru/adminbsb/public/images/16010336516051-Hero_Epic-Beyond-Cali-Burrito.png"),
//     ],
//   ),
// ];
