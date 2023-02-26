import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../model/driver.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../widgets/ibackground4.dart';
import '../widgets/iline.dart';
import '../widgets/ilist5.dart';

class Menu extends StatelessWidget {
  @required
  final BuildContext? context;
  final Function(String)? callback;
  Menu({Key? key, this.context, this.callback}) : super(key: key);

  //////////////////////////////////////////////////////////////////
  //
  //
  //
  Account? account;
  final RestDataService _restDataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();

  _onMenuClickItem(int id) {
    print("User click menu item: $id");
    switch (id) {
      case 1:
        callback!("orders");
        break;
      case 2:
        callback!("notification");
        break;
      // case 3:
      //   callback("statistics");
      //   break;
      case 7:
        callback!("help");
        break;
      case 8:
        callback!("account");
        break;
      case 9:
        callback!("language");
        break;
      case 10: // dark & light mode
        theme.changeDarkMode();
        callback!("redraw");
        break;
      case 11: // sign out
        account?.logOut();
        Navigator.pushNamedAndRemoveUntil(context!, "/login", (r) => false);
        break;
    }
  }

  _changeOnlineOffline(bool value) {
    print("Online/Offline button change value: $value");
    account =
        Provider.of<CreateAccountViewModel>(context!, listen: false).account;
    // print(account.notifyCount);
    String token =
        Provider.of<CreateAccountViewModel>(context!, listen: false).token;
    _restDataService.driverstat(token, account?.email ?? '');
  }

  _changeNotify(bool value) {
    print("Notification button change value: $value");
  }
  //
  //
  //
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    Driver? drivers =
        Provider.of<CreateAccountViewModel>(context, listen: false).drivers;
    bool? online = drivers == null ? false : drivers.online;
    return Drawer(
        child: Container(
      color: theme.colorBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (!account?.isAuth())
            Container(
              height: 100 + MediaQuery.of(context).padding.top,
              child: IBackground4(colorsGradient: theme.colorsGradient),
            ),
          if (account?.isAuth())
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
          if (account?.isAuth())
            Container(
                height: 100,
                child: Row(
                  children: <Widget>[
                    UnconstrainedBox(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: _avatar(),
                      margin: const EdgeInsets.only(
                          left: 10, top: 10, bottom: 10, right: 10),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            account?.userName ?? '',
                            style: theme.text18boldPrimary,
                          ),
                          Text(
                            account?.email ?? '',
                            style: theme.text16,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          if (account?.isAuth()) const ILine(),

          IList5(
            icon: UnconstrainedBox(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      "assets/online.png",
                      fit: BoxFit.contain,
                      color: theme.colorPrimary,
                    ))),
            text: strings.get(62), // "Online/Offline"
            textStyle: theme.text16bold!,
            activeColor: theme.colorPrimary,
            inactiveTrackColor: theme.colorGrey,
            press: _changeOnlineOffline,
            initState: online!,
          ),

          _item(1, strings.get(24), "assets/home.png"), // 'Orders'
          _item(2, strings.get(25), "assets/notifyicon.png"), // Notifications
          // _item(3, strings.get(79), "assets/statistics.png"), // Statistics
          const ILine(),
          _item(7, strings.get(26), "assets/help.png"), // Help & Support
          _item(8, strings.get(27), "assets/account.png"), // "Account",
          _item(9, strings.get(28), "assets/language.png"), // Languages

          IList5(
            icon: UnconstrainedBox(
                child: Container(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      "assets/notifyicon.png",
                      fit: BoxFit.contain,
                      color: theme.colorPrimary,
                    ))),
            text: strings.get(25), // Notifications
            textStyle: theme.text16bold!,
            activeColor: theme.colorPrimary,
            inactiveTrackColor: theme.colorGrey,
            press: _changeNotify,
          ),

          const ILine(),
          _darkMode(),
          if (account?.isAuth()) const ILine(),
          if (account?.isAuth())
            _item(11, strings.get(29), "assets/signout.png"), // "Sign Out",
        ],
      ),
    ));
  }

  _avatarGet(String avatar) {
    if (avatar == '') {
      return const Image(image: AssetImage("assets/selectimage.png")).image;
    } else {
      return NetworkImage(avatar);
    }
  }

  _avatar() {
    if (!account?.isAuth()) {
      return Container();
    } else {
      return SizedBox(
        width: 55,
        height: 55,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(55),
          child: Container(
            child: CircleAvatar(
              backgroundImage: _avatarGet(account?.userAvatar ?? ''),
              radius: 35,
            ),
            // CachedNetworkImage(
            //   placeholder: (context, url) => CircularProgressIndicator(
            //     backgroundColor: theme.colorPrimary,
            //   ),
            //   imageUrl: account.userAvatar,
            //   imageBuilder: (context, imageProvider) => Container(
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: imageProvider,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            //   errorWidget: (context, url, error) => new Icon(Icons.error),
            // ),
          ),
        ),
      );
    }
  }

  _darkMode() {
    if (theme.darkMode) return _item(10, "Light colors", "assets/brands.png");
    return _item(10, "Dark colors", "assets/brands.png");
  }

  _item(int id, String name, String imageAsset) {
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text(
            name,
            style: theme.text16bold,
          ),
          leading: UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    color: theme.colorPrimary,
                  ))),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  Navigator.pop(context!);
                  _onMenuClickItem(id);
                }, // needed
              )),
        )
      ],
    );
  }
}
