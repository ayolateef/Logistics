import 'package:delivery/servicelocator.dart';
import 'package:delivery/services/notification_services.dart';
import 'package:delivery/ui/login/createaccount.dart';
import 'package:delivery/ui/login/forgot.dart';
import 'package:delivery/ui/login/login.dart';
import 'package:delivery/ui/main/mainscreen.dart';
import 'package:delivery/ui/start/splash.dart';
import 'package:delivery/viewmodel/createaccount.dart';
import 'package:delivery/viewmodel/orderlistdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
//Account account = Account();
Pref pref = Pref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  Firebase.initializeApp();
  theme.init();
  SharedPreferences pref = await SharedPreferences.getInstance();
  int? langu = pref.getInt('langu');
  if (langu != null) {
    strings.setLang(langu);
  } else {
    strings.setLang(Lang.english); // set default language - English
  }
  setupServiceLocator();
  runApp(AppDelivery());
}

class AppDelivery extends StatelessWidget {
  const AppDelivery({Key? key}) : super(key: key);

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
        title: strings.get(10), // "Food Delivery Flutter App UI Kit",
        debugShowCheckedModeBanner: false,
        theme: _theme,
        initialRoute: '/splash',
        //initialRoute: '/main',
        routes: {
          '/splash': (BuildContext context) => SplashScreen(),
          '/login': (BuildContext context) => const LoginScreen(),
          '/forgot': (BuildContext context) => const ForgotScreen(),
          '/createaccount': (BuildContext context) =>
              const CreateAccountScreen(),
          '/main': (BuildContext context) => MainScreen(),
        },
      ),
    );
  }
}

dprint(String str) {
  //
  // comment this line for release app
  //
  print(str);
}
