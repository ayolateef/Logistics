import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../model/order.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../../viewmodel/orderlistdata.dart';
import '../widgets/ICard22.dart';
import '../widgets/easyDialog2.dart';
import '../widgets/ibutton2.dart';

class OrdersScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;
  final Map<String, dynamic>? params;
  const OrdersScreen({Key? key, this.callback, this.params}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

int _currentTabIndex = 0;

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  List orders = <Order>[];

  bool _isLoading = true;

  Account? account;
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final OrderListDataViewModel _orderlistviewmodel =
      serviceLocator<OrderListDataViewModel>();

  @override
  void didChangeDependencies() async {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    print("didChangedependencies orders${account?.notifyCount}");
    try {
      orders = await _orderlistviewmodel.orders(token, account?.email ?? '');
      print(orders);
      print('super.didchange isloading: $_isLoading');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error Connecting to the Database")));
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  _onCallback(String id) {
    print("User tap on order card with id: $id");

    account?.currentOrderset(id);
    account?.backRouteset("orders");
    widget.callback!("orderDetails", {});
  }

  _tabIndexChanged() {
    print("Tab index is changed. New index: ${_tabController?.index}");
    setState(() {});
    _currentTabIndex = _tabController!.index;
  }

  _onRejectClick(String id) {
    print("User click Reject button with id: $id");
    _openRejectDialog();
  }

  _onAcceptClick(String id) {
    print("User click Accept button with id: $id");
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    for (var item in orders) {
      if (item.id == id) {
        if (item.status == 2) {
          // item.status = 1;
          _restdataService.addstatno(token, item.pid);
          setState(() {});
          account?.currentOrderset(id);
          account?.backRouteset("orders");
          widget.callback!("orderDetails", {});
          return;
        }
        if (item.status == 3) {
          _restdataService.addstatno(token, item.pid);
          setState(() {});
          account?.currentOrderset(id);
          account?.backRouteset("orders");
          widget.callback!("orderDetails", {});
          return;
        }
      }
    }
  }

  @override
  void didUpdateWidget(OrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  _onMapClick(String id) {
    print("User click On Map button with id: $id");
    // account.openOrderOnMap = id;
    account?.openOrderOnMapset(id);
    widget.callback!("map", {"backRoute": "orders"});
  }

  _callbackReject() {
    print("User click Send on Reject dialog");
    print("text=${editController.text}");
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController? _tabController;
  final editController = TextEditingController();
  double _show = 0;
  var _dialogBody = Container();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController?.addListener(_tabIndexChanged);
    _tabController?.animateTo(_currentTabIndex);
    _isLoading = true;
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    var mainbody = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
          height: 30,
          child: TabBar(
            indicatorColor: theme.colorPrimary,
            labelColor: Colors.black,
            tabs: [
              Text(strings.get(41), // "New",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(42), // "Active",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(43), // "History",
                  textAlign: TextAlign.center,
                  style: theme.text14),
            ],
            controller: _tabController,
          ),
        ),
        Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 90),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                  child: _body(2),
                ),
                Container(
                  child: _body(3),
                ),
                Container(
                  child: _body(4),
                ),
              ],
            )),
        IEasyDialog2(
            setPosition: (double value) {
              _show = value;
            },
            getPosition: () {
              return _show;
            },
            color: theme.colorGrey,
            body: _dialogBody,
            backgroundColor: theme.colorBackground!!),
      ],
    );
    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          mainbody,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0x00000000),
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
      body: Container(child: _isLoading ? bodyProgress : mainbody),
    );
  }

  _body(int status) {
    print("orders _body status: $status");
    int size = 0;
    for (var _data in orders) {
      if (_data.status == status) {
        size++;
      }
    }

    if (size == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UnconstrainedBox(
              child: SizedBox(
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
          Text(strings.get(50), // "Not Have Orders",
              overflow: TextOverflow.clip,
              style: theme.text16bold),
          SizedBox(
            height: 50,
          ),
        ],
      ));
    }
    if (status == 2) {
      return ListView(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
        children: _body2(status),
      );
    }
    if (status == 3) {
      return ListView(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
        children: _body3(status),
      );
    }
    if (status == 4) {
      return ListView(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
        children: _body4(status),
      );
    }
  }

  _body4(int status) {
    var list = <Widget>[];

    var driver =
        Provider.of<CreateAccountViewModel>(context, listen: false).drivers;
    // print("driver id - ${driver.id}");
    for (var _data in orders) {
      if (_data.status == status) {
        if (driver?.id.toString() == _data.driverId) {
          print("orders _body4 _data.status: ${_data.status}");

          list.add(ICard22(
            color: theme.colorBackgroundDialog!,
            colorRoute: theme.colorPrimary,
            id: _data.id,
            text: "${strings.get(44)} #${_data.id}", // Order ID122
            textStyle: theme.text18boldPrimary!,
            text2:
                "${strings.get(45)}: ${_data.date}", // Date: 2020-07-08 12:35
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
            text8Style: theme.text14!,
            button1Enable: (status == 2 || status == 2),
            button2Enable: true,
            button1Text: strings.get(47), // On Map
            button1Style: theme.text14boldWhite!,
            button2Text: (status == 2)
                ? strings.get(48)
                : strings.get(51), // Accept or Complete
            button2Style: theme.text14boldWhite!!,
            callbackButton1: _onAcceptClick,
            callbackButton2: _onMapClick,
            callback: _onCallback,
            //
            //
            //
            button34Enable: (status == 0),
            button3Text: strings.get(84), // Rejection
            button3Style: theme.text14boldWhite!!,
            button3Color: Colors.red,
            callbackButton3: _onRejectClick,
            button4Text: strings.get(48), // Accept
            button4Style: theme.text14boldWhite!!,
            button4Color: theme.colorPrimary,
            callbackButton4: _onAcceptClick,
          ));
        }
      }
    }
    print(list.length);
    return list;
  }

  _body2(int status) {
    var list = <Widget>[];

    var driver =
        Provider.of<CreateAccountViewModel>(context, listen: false).drivers;
    // print("driver id - ${driver.id}");
    for (Order _data in orders) {
      if (_data.status == status) {
        // print('orders driver.id.toString() and _data.driverId ${driver.id.toString()} + ${_data.driverId} ');

        if (driver?.id.toString() == _data.driverId) {
          print("orders _body2 _data.status: ${_data.status}");

          list.add(ICard22(
            color: theme.colorBackgroundDialog!,
            colorRoute: theme.colorPrimary,
            id: _data.id,
            text: "${strings.get(44)} #${_data.id}", // Order ID122
            textStyle: theme.text18boldPrimary!,
            text2:
                "${strings.get(45)}: ${_data.date}", // Date: 2020-07-08 12:35
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
            text8Style: theme.text14!,
            button1Enable: (status == 2 || status == 2),
            button2Enable: true,
            button1Text: strings.get(47), // On Map
            button1Style: theme.text14boldWhite!,
            button2Text: (status == 2)
                ? strings.get(48)
                : strings.get(51), // Accept or Complete
            button2Style: theme.text14boldWhite!,
            callbackButton1: _onAcceptClick,
            callbackButton2: _onMapClick,
            callback: _onCallback,
            //
            //
            //
            button34Enable: (status == 0),
            button3Text: strings.get(84), // Rejection
            button3Style: theme.text14boldWhite!,
            button3Color: Colors.red,
            callbackButton3: _onRejectClick,
            button4Text: strings.get(48), // Accept
            button4Style: theme.text14boldWhite!,
            button4Color: theme.colorPrimary,
            callbackButton4: _onAcceptClick,
          ));
        }
      }
    }
    return list;
  }

  _body3(int status) {
    var list = <Widget>[];
    var driver =
        Provider.of<CreateAccountViewModel>(context, listen: false).drivers;
    print("driver id - ${driver?.id}");
    for (var _data in orders) {
      if (_data.status == status) {
        if (driver?.id.toString() == _data.driverId) {
          list.add(ICard22(
            color: theme.colorBackgroundDialog!,
            colorRoute: theme.colorPrimary,
            id: _data.id,
            text: "${strings.get(44)} #${_data.id}", // Order ID122
            textStyle: theme.text18boldPrimary!,
            text2:
                "${strings.get(45)}: ${_data.date}", // Date: 2020-07-08 12:35
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
            text8Style: theme.text14!,
            button1Enable: (status == 3 || status == 3),
            button2Enable: true,
            button1Text: strings.get(47), // On Map
            button1Style: theme.text14boldWhite!,
            button2Text: strings.get(51), // Accept or Complete
            button2Style: theme.text14boldWhite!,
            callbackButton1: _onAcceptClick,
            callbackButton2: _onMapClick,
            callback: _onCallback,
            //
            //
            //
            button34Enable: (status == 0),
            button3Text: strings.get(84), // Rejection
            button3Style: theme.text14boldWhite!,
            button3Color: Colors.red,
            callbackButton3: _onRejectClick,
            button4Text: strings.get(48), // Accept
            button4Style: theme.text14boldWhite!,
            button4Color: theme.colorPrimary,
            callbackButton4: _onAcceptClick,
          ));
        }
      }
    }
    return list;
  }

  slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset("assets/delete.png",
                      fit: BoxFit.contain, color: Colors.white))),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset("assets/delete.png",
                      fit: BoxFit.contain, color: Colors.white)))
        ],
      ),
    );
  }

  _openRejectDialog() {
    _dialogBody = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(
                strings.get(85),
                textAlign: TextAlign.center,
                style: theme.text18boldPrimary,
              )), // "Reason to Reject",
          SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(87)}:",
            style: theme.text12bold,
          ), // "Enter Reason",
          _edit(editController, strings.get(88), false), //  "here",
          SizedBox(
            height: 30,
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(86), // Send
                  textStyle: theme.text14boldWhite!,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                    _callbackReject();
                  }),
              SizedBox(
                width: 10,
              ),
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(66), // Cancel
                  textStyle: theme.text14boldWhite!,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                  }),
            ],
          )),
        ],
      ),
    );

    setState(() {
      _show = 1;
    });
  }

  _edit(TextEditingController _controller, String _hint, bool _obscure) {
    return Container(
      height: 30,
      child: TextField(
        controller: _controller,
        onChanged: (String value) async {},
        cursorColor: theme.colorDefaultText,
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 1,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: _hint,
            hintStyle: theme.text14),
      ),
    );
  }
}
