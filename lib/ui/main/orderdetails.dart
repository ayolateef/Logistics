import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
import 'map.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Function(String)? callback;
  const OrderDetailsScreen({Key? key, this.callback}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  Account? account;
  bool _isLoading = true;
  var orders = [];
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();
  final OrderListDataViewModel _orderlistviewmodel =
      serviceLocator<OrderListDataViewModel>();

  @override
  void didChangeDependencies() async {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
//    print(account.notifyCount);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    try {
      orders = await _orderlistviewmodel.orders(token, account?.email ?? '');
      _isLoading = false;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error Connecting to the Database")));
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  _onBackPressed() {
    widget.callback!(account?.backRoute ?? '');
  }

  routes(String route) {
    setState(() {});
  }

  _onMapClick(String id) {
    print("User click On Map button with id: $id");
    // account.openOrderOnMap = id;
    account?.openOrderOnMapset(id);
    account?.backRouteset("map");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MapScreen(
              callback: routes,
              params: const {"backRoute": "orderDetails"},
            )));
    // widget.callback("map", {"backRoute": "orders"});
  }
  //
  // routes2(String route, Map<String, dynamic> params) {
  //   _params = params;
  //   if (route != "redraw") _currentPage = route;
  //   setState(() {});
  // }

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
    var body = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: MediaQuery.of(context).padding.top + 50),
          child: _body(),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, top: 40),
          alignment: Alignment.topLeft,
          child: IBackButton(
              onBackClick: () {
                _onBackPressed();
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
            decoration: const BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0x00000000),
                  borderRadius: BorderRadius.circular(10.0)),
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
      children: _body2(),
    );
  }

  _body2() {
    final List list = [];

    for (var _data in orders) {
      if (account?.currentOrder == _data.id) {
        list.add(const SizedBox(
          height: 15,
        ));
        list.add(ICard22(
          color: theme.colorBackgroundDialog!,
          colorRoute: theme.colorPrimary,
          id: _data.id,
          text: "${strings.get(44)} #${_data.id}", // Order ID122
          textStyle: theme.text18boldPrimary!,
          text2: "${strings.get(45)}: ${_data.date}", // Date: 2020-07-08 12:35
          text2Style: theme.text14!,
          text3: "₦${_data.summa.toStringAsFixed(2)}",
          text3Style: theme.text18bold!,
          text4: _data.method, // cache on delivery
          text4Style: theme.text14!,
          text5: "${strings.get(46)}:", // Distance
          text5Style: theme.text16!,
          text6:
              "${(_data.distance / 1000).toStringAsFixed(3)} ${strings.get(49)}", // km
          text6Style: theme.text18boldPrimary!,
          text7: _data.address1,
          text7Style: theme.text14!,
          text8: _data.address2,
          text8Style: theme.text14!!,
          //button1Enable: (status == 0 || status == 1),
          button1Enable: false,
          button2Enable: false,
          button1Text: strings.get(47), // On Map
          button1Style: theme.text14boldWhite!!,
          //button2Text: (status == 0) ? strings.get(48) : strings.get(51),
          // Accept or Complete
          button2Style: theme.text14boldWhite!!,
//              callbackButton1: _onAcceptClick,
//              callbackButton2: _onMapClick
        ));

        list.add(ICard23(
          text: "${strings.get(52)}:", // Customer name
          textStyle: theme.text14!!,
          text2: "${strings.get(53)}:", // "Customer phone",
          text2Style: theme.text14!!,
          text3: "${_data.customerName}",
          text3Style: theme.text16bold!,
          text4: _data.phone,
          text4Style: theme.text16bold!,
        ));

        list.add(const SizedBox(
          height: 10,
        ));

        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.center,
              child: IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(54), // "Call to Customer",
                  textStyle: theme.text14boldWhite!,
                  pressButton: _onCallToCustomer),
            ),
            Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    strings.get(47),
                    style: theme.text14boldWhite,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        splashColor: Colors.grey[400],
                        onTap: () {
                          if (_data.id != null) {
                            _onMapClick(_data.id);
                          }
                        }, // needed
                      )),
                )
              ],
            ),
          ],
        ));

        list.add(const SizedBox(
          height: 10,
        ));

        var _dataDetails = <ICard24Data>[];
        for (var _details in _data.orderDetails) {
          _dataDetails.add(ICard24Data("₦", _details.image, _details.foodName,
              _details.count, _details.foodPrice));
        }
        double dataFee = _data.fee * 0.075;

        list.add(ICard24(
          color: theme.colorBackgroundDialog!,
          text: "${strings.get(56)}:", // Order Details
          textStyle: theme.text18boldPrimary!,
          text2Style: theme.text16!,
          colorProgressBar: theme.colorPrimary,
          data: _dataDetails,
          text3Style: theme.text16!,
          text3: "${strings.get(57)}:", // Subtotal
          // text4:
          //     "${strings.get(58)}: ${_data.currency}${_data.fee}", // Shopping costs
          text5: "${strings.get(59)} (7.5%): ₦$dataFee", // Taxes
          text6: "${strings.get(60)}: ₦${_data.total}", // Total
          text6Style: theme.text16bold!,
        ));

        list.add(const SizedBox(
          height: 10,
        ));

        var _text = strings.get(61); // "Back To Map",
        if (account?.backRoute == "orders") {
          _text = strings.get(55);
        } // "Back To Orders",

        list.add(Container(
          alignment: Alignment.center,
          child: IButton2(
              color: theme.colorPrimary,
              text: _text,
              textStyle: theme.text14boldWhite!,
              pressButton: () {
                widget.callback!(account?.backRoute ?? '');
              }),
        ));

        list.add(SizedBox(
          height: 100,
        ));
      }
    }
    return list;
  }

  _onCallToCustomer() async {
    for (var item in orders) {
      if (item.id == account?.currentOrder) {
        var uri = 'tel:${item.phone}';
        await launchUrl(Uri.parse(uri));
      }
    }
  }
}
