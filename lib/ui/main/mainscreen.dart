import 'package:flutter/material.dart';
import 'package:owner2/ui/main/restaurants.dart';
import 'package:owner2/ui/main/statistics.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../model/stats.dart';
import '../../model/statsprice.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../menu/help.dart';
import '../menu/language.dart';
import '../menu/menu.dart';
import 'account.dart';
import 'addDishes.dart';
import 'addRestaurants.dart';
import 'chatdetailpage.dart';
import 'chatpage.dart';
import 'dishes.dart';
import 'dishesAll.dart';
import 'driver.dart';
import 'header.dart';
import 'map.dart';
import 'map2.dart';
import 'notification.dart';
import 'orderdetails.dart';
import 'orders.dart';

dynamic mainMap;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() {
    mainMap = MapScreen();
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  // CreateAccountServices _createService =
  //     serviceLocator<CreateAccountServices>();
  Account? account;
  @override
  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    _updateStats();

    //print(account.notifyCount);

    super.didChangeDependencies();
  }

  _updateStats() async {
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    Stats statsValue = await _restdataService.getStats(token);
    Statsprice statsprice = await _restdataService.getStatsPrice(token);
    Provider.of<CreateAccountViewModel>(context, listen: false)
        .setstats(statsValue);
    Provider.of<CreateAccountViewModel>(context, listen: false)
        .setstatsprice(statsprice);
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
  String chatUser = "";

  @override
  void initState() {
    _initDistance();
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    mainMap.callback = routes;
    account?.setRedraw(_redraw);
    chatUser = Provider.of<CreateAccountViewModel>(context, listen: false)
        .chatusername!;
    super.initState();
  }

  _initDistance() async {
    //   await ordersSetDistance();
    setState(() {});
  }

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

    var headerText = strings.get(21); //
    switch (_currentPage) {
      case "addDishes":
        headerText = strings.get(136); // "Add Dishes",
        break;
      case "editDishes":
        headerText = strings.get(137); // "Edit Dishes",
        break;
      case "editRestaurant":
        headerText = strings.get(131); // "Edit Restaurant",
        break;
      case "addRestaurant":
        headerText = strings.get(106); // "Add new Restaurant",
        break;
      case "statistics":
        headerText = strings.get(79); // "Statistics",
        break;
      case "orderDetails":
        headerText = strings.get(56); // "Order Details",
        break;
      case "map":
        headerText = strings.get(89); // "Map",
        break;
      case "mapRestaurant":
        headerText = strings.get(89); // "Map",
        break;
      case "language":
        headerText = strings.get(28); // "Languages",
        break;
      case "account":
        headerText = strings.get(27); // "Account",
        break;
      case "help":
        headerText = strings.get(38); // "Help & support",
        break;
      case "notification":
        headerText = strings.get(25); // "Notifications",
        break;
      case "orders":
        headerText = strings.get(24); // "Orders",
        break;
      case "drivers":
        headerText = strings.get(101); // "Change Driver",
        break;
      case "restaurants":
        headerText = strings.get(105); // "My Restaurants",
        break;
      case "dishes":
        headerText = strings.get(134); // "My Dishes",
        break;
      case "dishesAll":
        headerText = strings.get(134); // "My Dishes",
        break;
      case "chatpage":
        headerText = strings.get(154); // "Chat Page",
        break;
      default:
        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(context, callback: routes),
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          if (_currentPage.isEmpty) OrdersScreen(callback: routes),
          if (_currentPage == "dishesAll")
            DishesAllScreen(callback: routes2, params: _params),
          if (_currentPage == "addDishes" || _currentPage == "editDishes")
            AddDishesScreen(callback: routes2, params: _params),
          if (_currentPage == "dishes")
            DishesScreen(callback: routes2, params: _params),
          if (_currentPage == "addRestaurant" ||
              _currentPage == "editRestaurant")
            AddRestaurantScreen(callback: routes2, params: _params),
          if (_currentPage == "mapRestaurant")
            MapInfoScreen(callback: routes2, params: _params),
          if (_currentPage == "restaurants")
            RestaurantsScreen(callback: routes2),
          if (_currentPage == "drivers") DriverChangeScreen(callback: routes),
          if (_currentPage == "statistics") StatisticsScreen(callback: routes),
          if (_currentPage == "orderDetails")
            OrderDetailsScreen(callback: routes),
          if (_currentPage == "map") mainMap,
          if (_currentPage == "language") LanguageScreen(),
          if (_currentPage == "account") AccountScreen(callback: routes),
          if (_currentPage == "help") const HelpScreen(),
          if (_currentPage == "notification")
            NotificationScreen(callback: routes),
          if (_currentPage == "orders") OrdersScreen(callback: routes),
          if (_currentPage == "chatpage") ChatPage(callback: routes),
          if (_currentPage == "chatdetail")
            ChatDetailPage(callback: routes, username: chatUser),
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Header(
                  title: headerText, onMenuClick: _openMenu, callback: routes)),
        ],
      ),
    );
  }

  Map<String, dynamic> _params = {};

  routes2(String route, Map<String, dynamic> params) {
    _params = params;
    if (route != "redraw") _currentPage = route;
    setState(() {});
  }

  routes(String route) {
    _params = {};
    if (route != "redraw") _currentPage = route;
    setState(() {});
  }
}
