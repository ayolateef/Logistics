import 'package:delivery/ui/main/whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../model/notifications.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../services/notification_services.dart';
import '../../viewmodel/createaccount.dart';
import '../menu/language.dart';
import '../menu/menu.dart';
import 'account.dart';
import 'header.dart';
import 'map.dart';
import 'notification.dart';
import 'orderdetails.dart';
import 'orders.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  Account? account;
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();
  List<Notifications> _this = [];
  String username = '';
  final NotificationService _notificationService = NotificationService();

  @override
  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print("didChangedependencies mainscreen${account?.notifyCount}");
    account?.setRedraw(_redraw);
    super.didChangeDependencies();
  }

  initNotify() async {
    Account? account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    _this = await _restdataService.getnotify(token!,
        body: toMap(account?.email ?? ''));
    print(" notificationScreen: init ${_this.length}");
    showNotification();

    setState(() {});
  }

  Map<String, dynamic> toMap(String email) {
    var map = <String, dynamic>{};
    print(" notificationScreen: map for ddd");
    // print(username);

    map["email"] = email;

    return map;
  }

  showNotification() async {
    print(" notificationScreen: none showNotification ${_this.length}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _this.length; i++) {
      username = prefs.getString('dateList' + i.toString()) ?? '';
      if (username != _this[i].date) {
        print(" notificationScreen: username showNotification $username");
        print(" notificationScreen: get showNotification ${_this[i].date}");
        await _notificationService.scheduleNotifications(
            _this[i].id!, _this[i].title ?? '', _this[i].text ?? '');
        prefs.setString('dateList' + i.toString(), _this[i].date ?? '');
      } else {
        await _notificationService.cancelNotifications(_this[i].id!);
        print(" notificationScreen: show showNotification ${_this[i].date}");
      }
    }
  }

  _openMenu() {
    print("Open menu");
    setState(() {
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  dynamic windowWidth;
  dynamic windowHeight;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _currentPage = "orders";
  Map<String, dynamic> _params = {};

  @override
  void initState() {
    //  _initDistance();
    initNotify();
    super.initState();
  }

  // _initDistance() async {
  //   await ordersSetDistance();
  //   setState(() {});
  // }

  _redraw() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var _headerText = strings.get(21); //
    switch (_currentPage) {
      case "statistics":
        _headerText = strings.get(79); // "Statistics",
        break;
      case "orderDetails":
        _headerText = strings.get(56); // "Order Details",
        break;
      case "map":
        _headerText = strings.get(89); // "Map",
        break;
      case "language":
        _headerText = strings.get(28); // "Languages",
        break;
      case "account":
        _headerText = strings.get(27); // "Account",
        break;
      case "help":
        _headerText = strings.get(38); // "Help & support",
        break;
      case "notification":
        _headerText = strings.get(25); // "Notifications",
        break;
      case "orders":
        _headerText = strings.get(24); // "Orders",
        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(
        context: context,
        callback: routes,
      ),
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          // if (_currentPage == "statistics") StatisticsScreen(callback: routes),
          if (_currentPage == "orderDetails")
            OrderDetailsScreen(callback: routes),
          if (_currentPage == "map")
            MapScreen(
              callback: routes,
              params: _params,
            ),
          if (_currentPage == "language") LanguageScreen(),
          if (_currentPage == "account") AccountScreen(callback: routes),
          if (_currentPage == "help") WhatsappLink(),
          if (_currentPage == "notification")
            NotificationScreen(callback: routes),
          if (_currentPage == "orders") OrdersScreen(callback: routes2),
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Header(
                  title: _headerText,
                  onMenuClick: _openMenu,
                  callback: routes)),
        ],
      ),
    );
  }

  routes(String route) {
    if (route != "redraw") _currentPage = route;
    setState(() {});
  }

  routes2(String route, Map<String, dynamic> params) {
    _params = params;
    if (route != "redraw") _currentPage = route;
    setState(() {});
  }
}
