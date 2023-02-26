import 'package:delivery/ui/widgets/ibox.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../widgets/iappBar.dart';
import '../widgets/ibackground4.dart';
import '../widgets/ibutton.dart';
import '../widgets/iinputField2.dart';
import '../widgets/iinputField2Password.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _pressCreateAccountButton() {
    print("User pressed \"CREATE ACCOUNT\" button");
    print(
        "Login: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, "
        "password1: ${editControllerPassword1.text}, password2: ${editControllerPassword2.text}");
    _showSnackBar("Coming soon");
    // Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPassword1 = TextEditingController();
  final editControllerPassword2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPassword1.dispose();
    editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          IBackground4(
              width: windowWidth, colorsGradient: theme.colorsGradient),
          IAppBar(context: context, text: "", color: Colors.white),
          Center(
              child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: windowWidth,
            child: _body(),
          )),
        ],
      ),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 20),
          alignment: Alignment.centerLeft,
          child: Text(strings.get(20), // "Create an Account!"
              style: theme.text20boldWhite),
        ),
        const SizedBox(
          height: 20,
        ),
        IBox(
            color: theme.colorBackgroundDialog!,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                      hint: strings.get(21), // "Login"
                      icon: Icons.account_circle,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog!,
                      controller: editControllerName,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                      hint: strings.get(18), // "E-mail address",
                      icon: Icons.alternate_email,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog!,
                      controller: editControllerEmail,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2Password(
                      hint: strings.get(15), // "Password"
                      icon: Icons.vpn_key,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog!,
                      controller: editControllerPassword1,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2Password(
                      hint: strings.get(22), // "Confirm Password"
                      icon: Icons.vpn_key,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog!,
                      controller: editControllerPassword2,
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(
                    pressButton: _pressCreateAccountButton,
                    text: strings.get(23), // CREATE ACCOUNT
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
