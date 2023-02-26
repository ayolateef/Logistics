import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../main.dart';
import '../../model/account.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../../viewmodel/orderlistdata.dart';
import '../widgets/ICard22.dart';
import '../widgets/ICard23.dart';
import '../widgets/ICard24.dart';
import '../widgets/ibackbutton.dart';
import '../widgets/ibutton2.dart';
import '../widgets/iline.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Function(String)? callback;
  OrderDetailsScreen({Key? key, this.callback}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  Account? account;
  bool _isLoading = true;
  var drivers = [];
  var orders = [];
  final RestDataService _restDataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();
  final OrderListDataViewModel _orderListviewModel =
      serviceLocator<OrderListDataViewModel>();

  void didChangeDependencies() async {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
//    print(account.notifyCount);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    orders = kIsWeb
        ? await _orderListviewModel.orders2(token, account?.email ?? '')
        : await _orderListviewModel.orders(token, account?.email ?? '');
    drivers = await _restDataService.getAllDrivers(token);
    print("stop loading");

    await Future.delayed(const Duration(seconds: 10), () {
      _isLoading = false;
    });

    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  changeState() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(OrderDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  _ordersUpdate(String id) async {
    widget.callback!("orders");
    // account =
    //     Provider.of<CreateAccountViewModel>(context, listen: false).account;
    // //  print(account.notifyCount);
    // String token =
    //     Provider.of<CreateAccountViewModel>(context, listen: false).token;

    // var orders1 = await _orderlistviewmodel.orders(token, account.email);
    // new Future.delayed(const Duration(seconds: 6), () {
    //   print("update none");
    //   orders = orders1;

    // });
    // this.setState(() {
    //   // this.orders = orders1;
    // });
  }

  _onMapClick(String id) {
    print("User click On Map button with id: $id");
    account?.openOrderOnMapset(id);
    account?.backRouteMapset("orderDetails");
    widget.callback!("map");
  }

  _setDriver() {
    widget.callback!("drivers");
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  @override
  void initState() {
    // _ordersupdate();
    setState(() {});
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

    var body = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: windowWidth > 800 ? windowWidth * 0.24 : 10,
              right: windowWidth > 800 ? windowWidth * 0.24 : 10,
              top: MediaQuery.of(context).padding.top + 50),
          width: windowWidth > 800 ? windowWidth * 0.6 : windowWidth,
          child: _body(),
        ),
        Container(
          margin: EdgeInsets.only(left: 5, top: 40),
          alignment: Alignment.topLeft,
          child: IBackButton(
              onBackClick: () {
                widget.callback!(account?.backRoute ?? '');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => OrdersScreen()),
                // );
              },
              color: theme.colorPrimary,
              iconColor: Colors.white),
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
                    child: const Center(
                      child: Text(
                        "loading.. wait...",
                        style: TextStyle(color: Colors.white),
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
      body: Container(child: _isLoading ? bodyProgress : body),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: _body2(),
    );
  }

  _body2() {
    var list = <Widget>[];

    for (var data in orders) {
      //print(account.currentOrder);
      if (account?.currentOrder == data.id) {
        list.add(ICard22(
            color: theme.colorBackgroundDialog!,
            colorRoute: theme.colorPrimary,
            id: data.id,
            text: "${strings.get(44)} #${data.id}", // Order ID122
            textStyle: theme.text18boldPrimary!,
            text2: "${strings.get(45)}: ${data.date}", // Date: 2020-07-08 12:35
            text2Style: theme.text14!,
            text3: "${data.currency}${data.summa.toStringAsFixed(2)}",
            text3Style: theme.text18bold!,
            text4: data.method, // cache on delivery
            text4Style: theme.text14!,
            text5: "${strings.get(46)}:", // Distance
            text5Style: theme.text16!,
            text6:
                "${(data.distance / 1000).toStringAsFixed(3)} ${strings.get(49)}", // km
            text6Style: theme.text18boldPrimary!,
            text7: data.address1,
            text7Style: theme.text14!,
            text8: data.address2,
            text8Style: theme.text14!,
            button1Enable: false,
            button2Enable: true,
            button1Text: strings.get(47) ?? '', // On Map
            button1Style: theme.text14boldWhite!,
            //button2Text: (status == 0) ? strings.get(48) : strings.get(51),
            // Accept or Complete
            button2Style: theme.text14boldWhite!,
//              callbackButton1: _onAcceptClick,
            callbackButton2: _onMapClick));

        list.add(const SizedBox(
          height: 10,
        ));

        list.add(_status());

        list.add(const SizedBox(
          height: 10,
        ));

        list.add(ILine());

        list.add(ICard23(
          text: "${strings.get(52)}:", // Customer name
          textStyle: theme.text14!,
          text2: "${strings.get(53)}:", // "Customer phone",
          text2Style: theme.text14!,
          text3: "${data.customerName}",
          text3Style: theme.text16bold!,
          text4: data.phone,
          text4Style: theme.text16bold!,
        ));

        list.add(SizedBox(
          height: 10,
        ));

        list.add(Container(
          alignment: Alignment.center,
          child: IButton2(
              color: theme.colorPrimary,
              text: strings.get(54) ?? '', // "Call to Customer",
              textStyle: theme.text14boldWhite!,
              pressButton: _onCallToCustomer),
        ));

        list.add(SizedBox(
          height: 10,
        ));

        var dataDetails = <ICard24Data>[];
        for (var _details in data.orderDetails) {
          dataDetails.add(ICard24Data(data.currency, _details.image,
              _details.foodName, _details.count, _details.foodPrice));
        }

        list.add(ICard24(
          color: theme.colorBackgroundDialog!,
          text: "${strings.get(56)}:", // Order Details
          textStyle: theme.text18boldPrimary!,
          text2Style: theme.text16!,
          colorProgressBar: theme.colorPrimary,
          data: dataDetails,
          text3Style: theme.text16!,
          text3: "${strings.get(57)}:", // Subtotal
          text4:
              "${strings.get(58)}: ${data.currency}${data.fee}", // Shopping costs
          text5: "${strings.get(59)}: ${data.currency}${data.tax}", // Taxes
          text6: "${strings.get(60)}: ${data.currency}${data.total}", // Total
          text6Style: theme.text16bold!,
        ));

        list.add(SizedBox(
          height: 15,
        ));

        list.add(SizedBox(
          height: 15,
        ));

        _backButton(list);

        list.add(SizedBox(
          height: 100,
        ));
      }
    }
    return list;
  }

  _backButton(List<Widget> list) {
    var text = strings.get(61); // "Back To Map",
    if (account?.backRoute == "orders") {
      text = strings.get(55);
    } // "Back To Orders",

    list.add(Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: text ?? '',
          textStyle: theme.text14boldWhite!,
          pressButton: () {
            widget.callback!(account?.backRoute ?? '');
          }),
    ));
  }

  _status() {
    var _return = Container();
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    for (var _data in orders) {
      if (account?.currentOrder == _data.id) {
        String? text =
            "${strings.get(99)} ${strings.get(42)}"; // "Set To", "Preparing"
        var status = strings.get(95); // "Received"
        if (_data.status == 1) {
          status = strings.get(42); // "Preparing"
          text = "${strings.get(99)} ${strings.get(43)}"; // "Set To", "Ready"

        }
        if (_data.status == 2) {
          status = strings.get(43); // "Ready",
          text = strings.get(100); // "Set Driver"
        }
        if (_data.status == 3) status = strings.get(96); // "On the way",
        if (_data.status == 4) status = strings.get(97); // "Delivered",

        var _name = "";
        var _min = 3;
        var stat;
        var driverid;
        if (_data.driverId == null) {
          print("driver id is null ");
          driverid = "";
        } else {
          driverid = _data.driverId;
        }
        //if (_data.driverId.isNotEmpty) {
        if (driverid.isNotEmpty) {
          print("driver id - ");
          print(driverid);
          for (var driver in drivers) {
            if (driver.id.toString() == _data.driverId) _name = driver.name;
          }
          _min = 2;
        }
//
        _return = Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  "${strings.get(98)}:",
                  style: theme.text18boldPrimary,
                ), // "Status",
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  status!,
                  style: theme.text16,
                )),
                //  if (_data.driverId.isNotEmpty)
                if (driverid.isNotEmpty)
                  Text(
                    "${strings.get(104)}: $_name",
                    style: theme.text14bold,
                  ), // Driver
                if (_data.status < _min)
                  Container(
                    alignment: Alignment.center,
                    child: IButton2(
                        color: theme.colorPrimary,
                        text: text ?? '',
                        textStyle: theme.text14boldWhite!,
                        pressButton: () {
                          if (_data.status == 2) {
                            _setDriver();
                          } else {
                            _restDataService.addStatNo(token, _data.pid);
                            //  setState(() {
                            //    _data.status++;

                            _ordersUpdate(_data.id);
                            //   });
                          }
                        }),
                  )
              ],
            ));
      }
    }
    return _return;
  }

  _onCallToCustomer() async {
    for (var item in orders) {
      if (item.id == account?.currentOrder) {
        var uri = 'tel:${item.phone}';
        if (await canLaunchUrl(Uri.parse(uri))) await launchUrl(Uri.parse(uri));
      }
    }
  }
}
