import 'package:flutter/material.dart';
import 'package:owner2/ui/main/restaurantDetails.dart';

import '../../main.dart';
import '../../model/restaurant.dart';
import '../widgets/ICard20FileCaching.dart';
import '../widgets/easyDialog2.dart';
import '../widgets/ibutton2.dart';
import '../widgets/iline.dart';

class RestaurantsScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;
  const RestaurantsScreen({Key? key, this.callback}) : super(key: key);

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  _openRestaurantDetails(String id, String hero) {
    for (var item in restaurants) {
      if (item.id == id) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailsScreen(
                params: {
                  "heroid": hero,
                  "id": item.id,
                  "image": item.image,
                  "phone": item.phone,
                  "mobilephone": item.mobilePhone,
                  "name": item.name,
                  "desc": item.desc,
                },
              ),
            ));
      }
    }
  }

  _onDishesListButton(String id) {
    print("User pressed button Dishes List");
    for (var item in restaurants) {
      if (item.id == id) {
        widget.callback!(
            "dishes", {"backRoute": "restaurants", "sort": item.id});
      }
    }
  }

  _addNewRestaurant() {
    print("User pressed button Add new Restaurant");
    widget.callback!("addRestaurant", {"backRoute": "restaurants"});
  }

  _deleteRestaurant(String id) {
    print("Need delete restaurant with id: $id");
  }

  _onEditButtonPress(String id) {
    for (var item in restaurants) {
      if (item.id == id) {
        widget.callback!("editRestaurant", {
          "backRoute": "restaurants",
          "edit": "true",
          "id": id,
          "latitude": item.lat,
          "longitude": item.lng,
          "name": item.name,
          "Address": item.address,
          "phone": item.phone,
          "mobilephone": item.mobilePhone,
          "desc": item.desc,
          "image": item.image,
        });
      }
    }
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;

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
          }
          return false;
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
              child: _body(),
            ),
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

  _body() {
    return ListView(
      padding: const EdgeInsets.only(top: 0),
      children: _body2(),
    );
  }

  _body2() {
    var list = <Widget>[];

    list.add(SizedBox(
      height: 20,
    ));

    var height = windowWidth * 0.4;

    for (var item in restaurants) {
      list.add(Container(
          width: windowWidth,
          height: height,
          child: ICard20FileCaching(
            color: theme.colorBackground!,
            colorProgressBar: theme.colorPrimary,
            text: item.name ?? '',
            text2: item.address ?? '',
            text3: item.phone ?? '',
            image: item.image ?? '',
            colorRoute: theme.colorPrimary,
            id: item.id ?? '',
            title: theme.text18boldPrimary!,
            body: theme.text16!,
            callbackNavigateIcon: _navigate,
            callback: _openRestaurantDetails,
          )));
      _addButtonsDeleteEdit(list, item.id ?? '');
      list.add(ILine());
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

  _navigate(String id) {
    for (var item in restaurants) {
      if (item.id == id) {
        widget.callback!("mapRestaurant",
            {"lat": item.lat, "lng": item.lng, "backRoute": "restaurants"});
      }
    }
  }

  _addNewButton(List<Widget> list) {
    list.add(Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(106) ?? '', // Add new Restaurant
          textStyle: theme.text14boldWhite!,
          pressButton: () {
            _addNewRestaurant();
          }),
    ));
  }

  _addButtonsDeleteEdit(List<Widget> list, String id) {
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IButton2(
                color: theme.colorPrimary,
                text: strings.get(133) ?? '', // "Dishes List"
                textStyle: theme.text14boldWhite!,
                pressButton: () {
                  _onDishesListButton(id);
                }),
            Expanded(
              child: Container(),
            ),
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
    if (mounted) {
      setState(() {
        _show = 1;
      });
    }
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
                      _deleteRestaurant(_deleteId);
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
}
