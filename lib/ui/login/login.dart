import 'package:flutter/material.dart';
import 'package:owner2/viewmodel/createaccount.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../widgets/ibackground4.dart';
import '../widgets/ibox.dart';
import '../widgets/ibutton.dart';
import '../widgets/iinputField2.dart';
import '../widgets/iinputField2Password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  RestDataService restdataServices = serviceLocator<RestDataService>();

  bool _isLoading = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _pressLoginButton() {
    String result;
    setState(() {
      _isLoading = true;
    });

    print(
        "Login: ${editControllerName.text}, password: ${editControllerPassword.text}");
    Future<String> users = restdataServices
        .login(editControllerName.text, editControllerPassword.text)
        .then((value) {
      result = value;
      //  _showSnackBar(result);
      if (result != "failed") {
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .tokenset(result);
        print(result);
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .usernameset(editControllerName.text);
        String username =
            Provider.of<CreateAccountViewModel>(context, listen: false)
                .logonusername;
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .accounts(username);
        Future.delayed(const Duration(seconds: 6), () {
          Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
        });
      } else {
        String text = "username/password is incorrect";
        _showSnackBar(text);
        setState(() {
          _isLoading = false;
        });
      }
      return result;
    });
    print(users);
    print("User pressed \"LOGIN\" button");

    // Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  _pressDontHaveAccountButton() {
    print("User press \"Don't have account\" button");
    Navigator.pushNamed(context, "/createaccount");
  }

  _pressForgotPasswordButton() {
    print("User press \"Forgot password\" button");
    Navigator.pushNamed(context, "/forgot");
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  dynamic windowWidth;
  dynamic windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var body = Stack(
      children: <Widget>[
        IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
        Center(
            child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, windowHeight * 0.1),
          width: windowWidth > 800 ? 400 : windowWidth,
          child: _body(),
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    _pressDontHaveAccountButton();
                  }, // needed
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 20),
                    child: Text(
                        strings.get(11) ??
                            '', // ""Don't have an account? Create",",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: theme.text16boldWhite),
                  )),
              InkWell(
                  onTap: () {
                    _pressForgotPasswordButton();
                  }, // needed
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(strings.get(12) ?? '', // "Forgot password",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: theme.text16boldWhite),
                  ))
            ],
          ),
        ),
      ],
    );

    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0x00000000),
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Text(
                        "loading.. please wait...",
                        style: TextStyle(color: Colors.blue[300]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      body: Container(child: _isLoading ? bodyProgress : body),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 20),
          alignment: Alignment.centerLeft,
          child: Text(strings.get(13) ?? '', // "Let's start with LogIn!"
              style: theme.text20boldWhite),
        ),
        SizedBox(
          height: 20,
        ),
        IBox(
            color: theme.colorBackgroundDialog!,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                        hint: strings.get(14) ?? '', // "Login"
                        icon: Icons.alternate_email,
                        colorDefaultText: theme.colorPrimary,
                        colorBackground: theme.colorBackgroundDialog!,
                        controller: editControllerName,
                        type: TextInputType.emailAddress)),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2Password(
                      hint: strings.get(15) ?? '', // "Password"
                      icon: Icons.vpn_key,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog!,
                      controller: editControllerPassword,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(
                    pressButton: _pressLoginButton,
                    text: strings.get(16) ?? '', // LOGIN
                    color: theme.colorPrimary,
                    textStyle: theme.text16boldWhite!,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
      ],
    );
  }
}
