import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ////////////////////////////////////////////////////////////////
  //
  //
  //

  RestDataService restDataServices = serviceLocator<RestDataService>();
  String result = "";
  bool credCheck = false;
  // _startNextScreen() {
  //   Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
  // }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(text),
    ));
  }

  _loginScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? username = pref.getString('username');
    String? password = pref.getString('password');

    if (username != null && password != null) {
      Future<String> users =
          restDataServices.login(username, password).then((value) async {
        result = value;
        if (result != null && result != "failed" && result != "") {
          Provider.of<CreateAccountViewModel>(context, listen: false)
              .tokenSet(result);
          Provider.of<CreateAccountViewModel>(context, listen: false)
              .userNameSet(username);
          String usernaming =
              Provider.of<CreateAccountViewModel>(context, listen: false)
                  .logonusername;
          credCheck =
              await Provider.of<CreateAccountViewModel>(context, listen: false)
                  .accounts(usernaming);
          if (credCheck) {
            new Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
            });
          } else {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
            String text = "username/password is incorrect";
            _showSnackBar(text);
          }
        } else {
          String text = "username/password is incorrect";
          _showSnackBar(text);
        }
        return result;
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
  }

  //
  //
  ////////////////////////////////////////////////////////////////
  dynamic windowWidth;
  dynamic windowHeight;

  @override
  void initState() {
    pref.init();
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(milliseconds: 2);
    return Timer(duration, _loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: theme.colorBackground,
        ),
        // IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "SplashLogo",
                child: SizedBox(
                  width: windowWidth * 0.3,
                  child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              CircularProgressIndicator(
                backgroundColor: theme.colorCompanion4,
                strokeWidth: 1,
              )
            ],
          ),
        ),
      ],
    ));
  }
}
