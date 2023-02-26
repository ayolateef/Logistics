import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class WhatsappLink extends StatefulWidget {
  const WhatsappLink({Key? key}) : super(key: key);

  @override
  State<WhatsappLink> createState() => _WhatsappLinkState();
}

class _WhatsappLinkState extends State<WhatsappLink> {
  // @override
  // void initState() {
  //   super.initState();
  //   getUserNameAndPassword();
  // }
  //
  // String getUserNameAndPassword(){
  //   var name  = account.userName;
  //   var email = account.userName;
  //   var message = "Hi, My Name is $name with email: $email";
  //   return message;
  // }

  String phone = "+2348186014986";
  String message = "Hi, Admin";
  _openWhatsapp() async {
    var whatsapp = phone; //+92xx enter like this
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=$message";
    var whatsappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.tryParse(message)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not Launch Whatsapp")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not Launch Whatsapp")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chat with one of our customer care representatives through our whatsapp line below:',
              style: theme.text16bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: _openWhatsapp,
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset("assets/whatsapp1.png")),
            )
          ],
        ),
      ),
    );
  }
}
