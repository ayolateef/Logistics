import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../main.dart';
import '../../model/account.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../../viewmodel/orderlistdata.dart';
import '../widgets/ICard28FileCaching.dart';
import '../widgets/ibackbutton.dart';

class DriverChangeScreen extends StatefulWidget {
  final Function(String)? callback;
  DriverChangeScreen({Key? key, this.callback}) : super(key: key);

  @override
  _DriverChangeScreenState createState() => _DriverChangeScreenState();
}

class _DriverChangeScreenState extends State<DriverChangeScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  Account? account;
  var orders = [];
  var drivers = [];

  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();
  final OrderListDataViewModel _orderlistviewmodel =
      serviceLocator<OrderListDataViewModel>();

  @override
  void didChangeDependencies() async {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.notifyCount);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    orders = kIsWeb
        ? await _orderlistviewmodel.orders2(token, account?.email ?? '')
        : await _orderlistviewmodel.orders(token, account?.email ?? '');
    drivers = await _restdataService.getAllDrivers(token);
    setState(() {});
    super.didChangeDependencies();
  }

  _driverSelect(String id) async {
    print("Selected driver with id: $id");
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    orders = await _orderlistviewmodel.orders(token, account?.email ?? '');
    print(account?.currentOrder);
    for (var _data in orders) {
      if (account?.currentOrder == _data.id) {
        _data.setdriversid(id);

        String? id2 =
            Provider.of<CreateAccountViewModel>(context, listen: false).pids;
        print("object");
        print(id2);
        int ids = int.parse(id2!);
        _restdataService.adddriver(token, ids, id);
        //   _restdataService.addstatno(token, _data.pid);

        widget.callback!("orderDetails");
      }
    }
  }

  _onBackPressed() {
    widget.callback!("orderDetails");
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  @override
  void initState() {
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
    return WillPopScope(
        onWillPop: () async {
          _onBackPressed();
          return false;
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 50,
                left: windowWidth > 800 ? windowWidth * 0.24 : 10,
                right: windowWidth > 800 ? windowWidth * 0.24 : 10,
              ),
              width: windowWidth > 800 ? windowWidth * 0.6 : windowWidth,
              child: _body(),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, top: 40),
              alignment: Alignment.topLeft,
              child: IBackButton(
                  onBackClick: () {
                    _onBackPressed();
                  },
                  color: theme.colorPrimary,
                  iconColor: Colors.white),
            ),
          ],
        ));
  }

  _body() {
    return ListView(
      children: _body2(),
    );
  }

  _body2() {
    var list = <Widget>[];

    list.add(SizedBox(
      height: 20,
    ));
    for (var data in drivers) {
      print("driver id: ${data.id}");

      list.add(ICard28FileCaching(
          id: data.id.toString(),
          color: theme.colorGrey2,
          title: data.name,
          titleStyle: theme.text14bold!,
          userAvatar: data.image,
          text: data.phone,
          textStyle: theme.text14!,
          balloonColor: (data.online) ? Colors.green : Colors.red,
          balloonText: (data.online)
              ? strings.get(102) ?? ''
              : strings.get(103) ?? '', // "online", - offline
          balloonStyle: theme.text14boldWhite!,
          enable: data.online,
          callback: _driverSelect));
    }
    return list;
  }
}
