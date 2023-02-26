import 'package:flutter/material.dart';

import '../../main.dart';
import '../../model/category.dart';
import '../../model/dishes.dart';
import '../../model/restaurant.dart';
import '../widgets/ICard21FileCaching.dart';
import '../widgets/easyDialog2.dart';
import '../widgets/ibutton2.dart';
import '../widgets/iline.dart';
import 'dishesDetails.dart';

class DishesAllScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;
  final Map<String, dynamic>? params;
  const DishesAllScreen({Key? key, this.callback, this.params})
      : super(key: key);

  @override
  _DishesAllScreenState createState() => _DishesAllScreenState();
}

int _currentTabIndex = 0;

class _DishesAllScreenState extends State<DishesAllScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _openDishesDetails(String id, String hero) {
    for (var item in dishes) {
      if (item.id == id) {
        for (var rest in restaurants) {
          if (rest.id == item.id) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DishesDetailsScreen(
                    params: {
                      "heroid": hero,
                      "id": item.id,
                      "image": item.image,
                      "name": item.name,
                      "desc": item.desc,
                      "ingredients": item.ingredients,
                      "price": item.price,
                      "currency": item.currency,
                      "nameRestaurant": rest.name,
                      "phone": rest.phone,
                      "mobilephone": rest.mobilePhone,
                    },
                  ),
                ));
          }
        }
      }
    }
  }

  _addNewDishes() {
    print("User pressed button Add new Dishes");
    widget.callback!("addDishes", {
      "backRoute": "dishesAll",
      //"tabOpen" :
    });
  }

  _deleteDishes(String id) {
    print("Need delete dishes with id: $id");
  }

  _onEditButtonPress(String id) {
    for (var item in dishes) {
      if (item.id == id) {
        widget.callback!("editDishes", {
          "backRoute": "dishesAll",
          "edit": "true",
          "id": id,
          "name": item.name,
          "price": item.price.toString(),
          "descPrice": item.discPrice,
          "ingr": item.ingredients,
          "desc": item.desc,
          "image": item.image,
          "CategoryId": item.category
        });
      }
    }
  }

  _onBackPressed() {
    widget.callback!(_getStringParam("backRoute"), {});
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController? _tabController;

  _tabIndexChanged() {
    print("Tab index is changed. New index: ${_tabController?.index}");
    _currentTabIndex = _tabController!.index;
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: restaurants.length);
    _tabController?.addListener(_tabIndexChanged);
    _tabController?.animateTo(_currentTabIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          if (_show != 0) {
            setState(() {
              _show = 0;
            });
          } else {
            _onBackPressed();
          }
          return false;
        },
        child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 50),
                height: 30,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: theme.colorPrimary,
                  labelColor: Colors.black,
                  isScrollable: true,
                  tabs: _tabsHeader(),
                )),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 90),
                child: TabBarView(
                  controller: _tabController,
                  children: _tabBarScreens(),
                )),
            IEasyDialog2(
              setPosition: (double value) {
                _show = value;
              },
              getPosition: () {
                return _show;
              },
              color: theme.colorGrey,
              body: _body3(),
              backgroundColor: theme.colorBackground,
            ),
          ],
        ));
  }

  _tabsHeader() {
    List list = <Widget>[];
    for (var item in restaurants) {
      list.add(Text(
        item.name ?? '',
        style: theme.text14,
      ));
    }
    return list;
  }

  _tabBarScreens() {
    var list = <Widget>[];
    for (var item in restaurants) {
      list.add(ListView(
        padding: const EdgeInsets.only(top: 0),
        children: _body2(item.id ?? ''),
      ));
    }
    return list;
  }

  _body2(String sort) {
    var list = <Widget>[];

    list.add(const SizedBox(
      height: 20,
    ));

    var height = windowWidth * 0.3;

    for (var item in dishes) {
      if ((sort.isNotEmpty && item.restaurantId == sort) || sort.isEmpty) {
        var text = "";
        for (var cat in categories) {
          if (cat.id == item.category) {
            text = "${strings.get(135)}: ${cat.name}";
          }
        } // "Category",

        list.add(Container(
            width: windowWidth,
            height: height,
            child: ICard21FileCaching(
              colorProgressBar: theme.colorPrimary,
              color: theme.colorBackground!,
              text: item.name ?? '',
              text3: text,
              textStyle3: theme.text14!,
              enableFavorites: false,
              width: windowWidth - 20,
              height: height,
              image: item.image ?? '',
              id: item.id ?? '',
              text2: "${item.currency}${item.price?.toStringAsFixed(2)}",
              textStyle: theme.text16bold!,
              textStyle2: theme.text14primary!,
              callback: _openDishesDetails,
            )));
        _addButtonsDeleteEdit(list, item.id ?? '');
        list.add(ILine());
      }
    }

    list.add(const SizedBox(
      height: 15,
    ));

    _addNewButton(list);

    list.add(const SizedBox(
      height: 150,
    ));

    return list;
  }

  _addNewButton(List<Widget> list) {
    list.add(Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(138) ?? '', // Add new Dishes
          textStyle: theme.text14boldWhite!,
          pressButton: () {
            _addNewDishes();
          }),
    ));
  }

  _addButtonsDeleteEdit(List<Widget> list, String id) {
    list.add(Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IButton2(
                color: theme.colorPrimary,
                text: strings.get(108) ?? '', // Edit
                textStyle: theme.text14boldWhite!,
                pressButton: () {
                  _onEditButtonPress(id);
                }),
            SizedBox(
              width: 10,
            ),
            IButton2(
                color: Colors.red,
                text: strings.get(107) ?? '', // Delete
                textStyle: theme.text14boldWhite!,
                pressButton: () {
                  _showMessage(id);
                }),
          ],
        )));
  }

  double _show = 0;
  String _deleteId = "";

  _showMessage(String id) {
    _deleteId = id;
    if (mounted)
      setState(() {
        _show = 1;
      });
  }

  _body3() {
    return Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(
              strings.get(111) ?? '',
              textAlign: TextAlign.center,
              style: theme.text18boldPrimary,
            ), // "Are you sure?",
            SizedBox(
              height: 20,
            ),
            Text(
              strings.get(112) ?? '',
              textAlign: TextAlign.center,
              style: theme.text16,
            ), // "You will not be able to recover this item!"
            SizedBox(
              height: 50,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IButton2(
                    color: Colors.red,
                    text: strings.get(109) ?? '', // Yes, delete it!
                    textStyle: theme.text14boldWhite!,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                      _deleteDishes(_deleteId);
                    }),
                const SizedBox(
                  width: 10,
                ),
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(110) ?? '', // No, cancel plx!
                    textStyle: theme.text14boldWhite!,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                    }),
              ],
            )),
          ],
        ));
  }

  String _getStringParam(String name) {
    if (widget.params != null) {
      var ret = widget.params![name];
      ret ??= "";
      return ret;
    }
    return "";
  }
}
