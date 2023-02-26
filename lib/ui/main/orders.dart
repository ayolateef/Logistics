import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/account.dart';
import '../../servicelocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../../viewmodel/orderlistdata.dart';
import '../widgets/ICard27.dart';

class OrdersScreen extends StatefulWidget {
  final Function(String)? callback;
  const OrdersScreen({Key? key, this.callback}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

int _currentTabIndex = 0;

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  var orders = [];

  bool _isLoading = true;

  Account? account;
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();
  final OrderListDataViewModel _orderlistviewmodel =
      serviceLocator<OrderListDataViewModel>();

  void didChangeDependencies() async {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.notifyCount);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    orders = kIsWeb
        ? await _orderlistviewmodel.orders2(token, account?.email ?? '')
        : await _orderlistviewmodel.orders(token, account?.email ?? '');

    setState(() {
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(OrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  _onCallback(String id) {
    print("User tap on order card with id: $id");
    account?.currentOrderSet(id);
    for (var _data in orders) {
      if (id == _data.id) {
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .setpid(_data.pid.toString());
      }
    }
    account?.backRouteset("orders");
    widget.callback!("orderDetails");
  }

  _tabIndexChanged() {
    print("Tab index is changed. New index: ${_tabController.index}");
    setState(() {});
    _currentTabIndex = _tabController.index;
  }

  _onLoad() {
    Future.delayed(const Duration(seconds: 10), () {
      _isLoading = false;
    });
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  late TabController _tabController;
  final editController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 6);
    _tabController.addListener(_tabIndexChanged);
    _tabController.animateTo(_currentTabIndex);
    _isLoading = true;
    _onLoad();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dprint("orders build");
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var body = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 50,
              left: windowWidth > 800
                  ? windowWidth * 0.20
                  : MediaQuery.of(context).padding.left,
              right: windowWidth > 800
                  ? windowWidth * 0.20
                  : MediaQuery.of(context).padding.right),
          alignment:
              windowWidth > 800 ? Alignment.centerLeft : Alignment.center,
          height: 30,
          width: windowWidth,
          child: TabBar(
            indicatorColor: theme.colorPrimary,
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Text(strings.get(41) ?? '', // "All",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(95) ?? '', // "Received",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(42) ?? '', // "Preparing",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(43) ?? '', // "Ready",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(96) ?? '', // "On the way",
                  textAlign: TextAlign.center,
                  style: theme.text14),
              Text(strings.get(97) ?? '', // "Delivered",
                  textAlign: TextAlign.center,
                  style: theme.text14),
            ],
            controller: _tabController,
          ),
        ),
        Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 90,
              left: windowWidth > 800 ? windowWidth * 0.24 : 10,
              right: windowWidth > 800 ? windowWidth * 0.24 : 10,
            ),
            width: windowWidth > 800 ? windowWidth * 0.6 : windowWidth,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                  child: _body(-1),
                ),
                Container(
                  child: _body(0),
                ),
                Container(
                  child: _body(1),
                ),
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
      ],
    );
    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
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

    _onmainbody() {
      return new Scaffold(
        body: new Container(child: _isLoading ? bodyProgress : body),
      );
    }

    return RefreshIndicator(
      child: _onmainbody(),
      onRefresh: _pullRefresh,
    );
  }

  Future<void> _pullRefresh() async {
    _isLoading = true;
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.notifyCount);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    orders = await _orderlistviewmodel.orders(token, account?.email ?? '');
    setState(() {
      _isLoading = false;
      orders = orders;
    });
  }

  _body(int status) {
    int size = 0;
    for (var data in orders) {
      if (data.status == status || status == -1) size++;
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
          SizedBox(
            height: 20,
          ),
          Text(strings.get(50) ?? '', // "Not Have Orders",
              overflow: TextOverflow.clip,
              style: theme.text16bold),
          const SizedBox(
            height: 50,
          ),
        ],
      ));
    }
    return ListView(
      padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
      children: _body2(status),
    );
  }

  _body2(int status) {
    var list = <Widget>[];

    for (var _data in orders) {
      if (_data.status == status || status == -1) {
        var _balloonText = strings.get(95); // "Received"
        Color _balloonColor = theme.colorCompanion3;
        if (_data.status == 1) {
          _balloonText = strings.get(42); // "Preparing"
          _balloonColor = theme.colorPrimary;
        }
        if (_data.status == 2) {
          _balloonText = strings.get(43); // "Ready",
          _balloonColor = theme.colorCompanion4;
        }
        if (_data.status == 3) {
          _balloonText = strings.get(96); // "On the way",
          _balloonColor = theme.colorCompanion2;
        }
        if (_data.status == 4) {
          _balloonText = strings.get(97); // "Delivered",
          _balloonColor = Colors.blue;
        }

        list.add(ICard27(
          color: theme.colorBackgroundDialog!,
          colorRoute: theme.colorPrimary,
          id: _data.id,
          text: "${strings.get(44)} #${_data.id}", // Order ID122
          textStyle: theme.text18boldPrimary!,
          text2: "${strings.get(45)}: ${_data.date}", // Date: 2020-07-08 12:35
          text2Style: theme.text14!,
          text3: "${_data.currency}${_data.summa.toStringAsFixed(2)}",
          text3Style: theme.text18bold!,
          text4: _data.method, // cache on delivery
          text4Style: theme.text14!,
          text5: "${strings.get(52)}:", // Customer name",
          text5Style: theme.text16!,
          text6: _data.customerName,
          text6Style: theme.text18boldPrimary!,
          text7: _data.address1,
          text7Style: theme.text14!,
          callback: _onCallback,
          //
          balloon: true,
          balloonColor: _balloonColor,
          balloonText: _balloonText!,
          balloonStyle: theme.text14boldWhite!,
        ));
      }
    }
    list.add(const SizedBox(
      height: 100,
    ));
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
}
