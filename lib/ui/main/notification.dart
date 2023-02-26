import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../model/account.dart';
import '../../model/notifications.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../widgets/ICard29FileCaching.dart';
import 'header.dart';

class NotificationScreen extends StatefulWidget {
  final Function(String)? callback;
  NotificationScreen({Key? key, this.callback}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  final RestDataService _restDataService = serviceLocator<RestDataService>();
  //
  _dismissItem(String id) async {
    print("Dismiss item: $id");
    int idint = int.parse(id);

    Notifications? _delete;
    print(_this);
    for (int i = 0; i < _this.length; i++) {
      if (_this[i].id == idint) {
        _delete = _this[i];
        print(_delete.id);
      }
    }

    if (_delete != null) {
      String token =
          Provider.of<CreateAccountViewModel>(context, listen: false).token;

      _delete = await _restDataService.deleteprofile(token, body: toMap2(id));
    }
    setState(() {});
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  List<Notifications> _this = [];

  _notify() async {
    Account? account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    _this =
        await _restDataService.getnotify(token, body: toMap(account?.email ?? ''));
    setState(() {});
  }
  //   Notifications(id: "6", date: "2020-08-09 12:22", title: "New Order", text: "You have an order assigned for you",
  //       image: "assets/selectimage.png"),
  //   Notifications(id: "5", date: "2020-08-09 14:24", title: "New Order", text: "You have an order assigned for you",
  //       image: "assets/selectimage.png"),
  //   Notifications(id: "4", date: "2020-08-09 16:01", title: "New Order", text: "You have an order assigned for you",
  //       image: "assets/selectimage.png"),
  //   Notifications(id: "3", date: "2020-08-09 12:22", title: "New Order", text: "You have an order assigned for you",
  //       image: "assets/selectimage.png"),
  //   Notifications(id: "2", date: "2020-08-09 12:22", title: "New Order", text: "You have an order assigned for you",
  //       image: "assets/selectimage.png"),
  //   Notifications(id: "1", date: "2020-08-09 17:04", title: "Order Completed!", text: "Congratulation! You payouts has been approved!",
  //       image: "assets/selectimage.png"),
  // ];

  @override
  void initState() {
    _notify();
    super.initState();
  }

  @override
  void dispose() {
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
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
              child: _body(),
            ),
            Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Header(
                  title: strings.get(35),
                  noMenu: true,
                ) // "Notificaciones",
                ),
          ],
        ));
  }

  _body() {
    var size = 0;
    if (_this == null) return Container();
    for (var _ in _this) size++;
    if (size == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: windowHeight / 3,
                  width: windowWidth / 2,
                  child: Container(
                    child: Image.asset(
                      "assets/nonotify.png",
                      fit: BoxFit.contain,
                    ),
                  ))),
          const SizedBox(
            height: 20,
          ),
          Text(strings.get(44), // "Not Have Notifications",
              overflow: TextOverflow.clip,
              style: theme.text16bold),
          const SizedBox(
            height: 50,
          ),
        ],
      ));
    }
    return ListView(
      children: _body2(),
    );
  }

  _body2() {
    var list = <Widget>[];

    list.add(Container(
      color: theme.colorBackgroundDialog,
      child: ListTile(
        leading: UnconstrainedBox(
            child: Container(
                height: 35,
                width: 35,
                child: Image.asset(
                  "assets/notifyicon.png",
                  fit: BoxFit.contain,
                ))),
        title: Text(
          strings.get(45),
          style: theme.text20bold,
        ), // "Notifications",
        subtitle: Text(
          strings.get(46),
          style: theme.text14,
        ), // "Swipe left the notification to delete it",
      ),
    ));

    list.add(SizedBox(
      height: 20,
    ));

    for (var _data in _this) {
      list.add(ICard29FileCaching(
          id: _data.id.toString(),
          color: theme.colorGrey.withOpacity(0.1),
          title: _data.title!,
          titleStyle: theme.text14bold!,
          userAvatar: _data.image!,
          colorProgressBar: theme.colorPrimary,
          text: _data.text!,
          textStyle: theme.text14!,
          balloonColor: theme.colorPrimary,
          date: _data.date!,
          dateStyle: theme.text12grey!,
          callback: _dismissItem));
    }
    return list;
  }

  Map<String, dynamic> toMap(String email) {
    var map = <String, dynamic>{};
    print("map for ddd");
    // print(username);

    map["email"] = email;

    return map;
  }

  Map<String, dynamic> toMap2(String id) {
    var map = <String, dynamic>{};
    print("map for id");
    // print(username);

    map["id"] = id;

    return map;
  }
}
