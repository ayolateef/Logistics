import 'package:flutter/material.dart';
import 'package:owner2/servicelocator.dart';
import 'package:owner2/ui/login/createaccount.dart';
import 'package:owner2/ui/login/forgot.dart';
import 'package:owner2/ui/login/login.dart';
import 'package:owner2/ui/main/mainscreen.dart';
import 'package:owner2/ui/main/orders.dart';
import 'package:owner2/ui/start/splash.dart';
import 'package:owner2/viewmodel/createaccount.dart';
import 'package:owner2/viewmodel/orderlistdata.dart';
import 'package:provider/provider.dart';

import 'config/lang.dart';
import 'config/theme.dart';
import 'model/pref.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
//
// Language data
//
Lang strings = Lang();
//
// Account
//
// Account account = Account();
Pref pref = Pref();

void main() {
  theme.init();
  setupServiceLocator();
  strings.setLang(Lang.english); // set default language - English
  runApp(const AppFoodDelivery());
}

class AppFoodDelivery extends StatelessWidget {
  const AppFoodDelivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
    );

    if (theme.darkMode) {
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor: Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateAccountViewModel()),
        ChangeNotifierProvider(create: (_) => OrderListDataViewModel()),
        //      ChangeNotifierProvider(create: (_) => AccountViewModel()),
      ],
      child: MaterialApp(
        title: strings.get(10) ?? '', // "Food Delivery Flutter App UI Kit",
        debugShowCheckedModeBanner: false,
        theme: _theme,
        initialRoute: '/splash',
        //initialRoute: '/login',
        routes: {
          '/splash': (BuildContext context) => const SplashScreen(),
          '/login': (BuildContext context) => LoginScreen(),
          '/forgot': (BuildContext context) => ForgotScreen(),
          '/createaccount': (BuildContext context) => CreateAccountScreen(),
          '/main': (BuildContext context) => const MainScreen(),
          '/orders': (BuildContext context) => const OrdersScreen(),
        },
      ),
    );

    // return MaterialApp(
    //   title: strings.get(10), // "Food Delivery Flutter App UI Kit",
    //   debugShowCheckedModeBanner: false,
    //   theme: _theme,
    //   initialRoute: '/splash',
    //   //initialRoute: '/main',
    //   routes: {
    //     '/splash': (BuildContext context) => SplashScreen(),
    //     '/login': (BuildContext context) => LoginScreen(),
    //     '/forgot': (BuildContext context) => ForgotScreen(),
    //     '/createaccount': (BuildContext context) => CreateAccountScreen(),
    //     '/main': (BuildContext context) => MainScreen(),
    //   },
    // );
  }
}

dprint(String str) {
  //
  // comment this line for release app
  //
  print(str);
}
