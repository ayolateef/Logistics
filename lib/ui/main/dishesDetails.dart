import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../model/restaurantsreviews.dart';
import '../widgets/ICard1FileCaching.dart';
import '../widgets/IList1.dart';
import '../widgets/iboxCircle.dart';
import '../widgets/iinkwell.dart';

class DishesDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? params;
  const DishesDetailsScreen({Key? key, this.params}) : super(key: key);
  @override
  _DishesDetailsScreenState createState() => _DishesDetailsScreenState();
}

class _DishesDetailsScreenState extends State<DishesDetailsScreen>
    with SingleTickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //

  _onBackClick() {
    Navigator.pop(context);
  }

  ///////////////////////////////////////////////////////////////////////////////
  dynamic windowWidth;
  dynamic windowHeight;
  final dynamic _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.colorBackground,
        body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: windowHeight * 0.35,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: theme.colorPrimary,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _imageBuild(),
                  ),
                  title: Container(
                    width: windowWidth,
                    height: 30,
                    child: UnconstrainedBox(
                      alignment: Alignment.centerLeft,
                      child: IInkWell(
                        child: _iconBackWidget(),
                        onPress: _onBackClick,
                      ),
                    ),
                  ),
                )
              ];
            },
            body: Stack(
              children: <Widget>[
                Container(
                  child: _body(),
                ),
              ],
            )));
  }

  _body() {
    return Container(
      child: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: _children(),
      ),
    );
  }

  _children() {
    var list = <Widget>[];

    list.add(const SizedBox(
      height: 20,
    ));

    var price =
        "${_getStringParam("currency")}${_getDoubleParam("price").toStringAsFixed(2)}";
    list.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(
              child: IList1(
                imageAsset: "assets/orders.png",
                text: _getStringParam("name"), // dish name
                textStyle: theme.text16bold!,
                imageColor: theme.colorDefaultText!,
              ),
            ),
            Text(
              price,
              style: theme.text18boldPrimary,
            ),
          ],
        )));
    list.add(const SizedBox(
      height: 20,
    ));

    if (_getStringParam("desc").isNotEmpty) {
      list.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Text(_getStringParam("desc"),
            style: theme.text14), // dish description
      ));
      list.add(const SizedBox(
        height: 20,
      ));
    }

    if (_getStringParam("ingredients").isNotEmpty) {
      list.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: IList1(
            imageAsset: "assets/ingredients.png",
            text: strings.get(152) ?? '', // Ingredients
            textStyle: theme.text16bold!,
            imageColor: theme.colorDefaultText!),
      ));
      list.add(SizedBox(
        height: 20,
      ));
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Text(_getStringParam("ingredients"),
            style: theme.text14), // Ingredients description
      ));
      list.add(SizedBox(
        height: 20,
      ));
    }

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: IList1(
          imageAsset: "assets/info.png",
          text: strings.get(153) ?? '', // Information
          textStyle: theme.text16bold!,
          imageColor: theme.colorDefaultText!),
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 20, top: 15, bottom: 10),
        child: Text(_getStringParam("nameRestaurant"))));

    list.add(_phone());
    list.add(_phoneMobile());

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20),
      child: IList1(
          imageAsset: "assets/reviews.png",
          text: strings.get(151) ?? '', // "Reviews",
          textStyle: theme.text16bold!,
          imageColor: theme.colorDefaultText!),
    ));
    list.add(SizedBox(
      height: 10,
    ));

    _reviews(list);

    list.add(SizedBox(
      height: 200,
    ));

    return list;
  }

  _reviews(List<Widget> list) {
    for (var item in reviews) {
      list.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: ICard1FileCaching(
          color: theme.colorPrimary,
          title: item.name ?? '',
          text: item.text ?? '',
          date: item.date ?? '',
          titleStyle: theme.text18bold!,
          textStyle: theme.text16!,
          dateStyle: theme.text14grey!,
          userAvatar: item.image ?? '',
          rating: item.star ?? 0.0,
        ),
      ));
    }
  }

  _imageBuild() {
    return Container(
        child: Hero(
            tag: _getStringParam("heroid"),
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => UnconstrainedBox(
                        child: Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        backgroundColor: theme.colorPrimary,
                      ),
                    )),
                    imageUrl: _getStringParam("image"),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ))));
  }

  _phone() {
    if (_getStringParam("phone").isEmpty) return Container();

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text("${strings.get(63)}: ${_getStringParam("phone")}",
                  style: theme.text14) //  "Phone",
              ),
          IInkWell(
            child: IBoxCircle(
              child: _icon(),
              color: Colors.white,
            ),
            onPress: _callMe,
          )
        ],
      ),
    );
  }

  _phoneMobile() {
    if (_getStringParam("mobilephone").isEmpty) return Container();

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
                  "${strings.get(148)}: ${_getStringParam("mobilephone")}",
                  style: theme.text14) // "Mobile Phone",
              ),
          IInkWell(
            onPress: _callMeMobile,
            child: IBoxCircle(child: _icon()),
          )
        ],
      ),
    );
  }

  _icon() {
    String icon = "assets/call.png";
    return Container(
        padding: const EdgeInsets.all(5),
        child: UnconstrainedBox(
            child: Container(
                height: 30,
                width: 30,
                child: Image.asset(
                  icon,
                  fit: BoxFit.contain,
                  color: Colors.black,
                ))));
  }

  _callMe() async {
    var uri = 'tel:${_getStringParam("phone")}';
    if (await canLaunchUrl(Uri.parse(uri))) await launchUrl(Uri.parse(uri));
  }

  _callMeMobile() async {
    var uri = 'tel:${_getStringParam("mobilephone")}';
    if (await canLaunchUrl(Uri.parse(uri))) await launchUrl(Uri.parse(uri));
  }

  _iconBackWidget() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(
                "assets/back.png",
                fit: BoxFit.contain,
                color: Colors.white,
              ))),
    );
  }

  String _getStringParam(String name) {
    if (widget.params != null) {
      var ret = widget.params![name];
      ret ??= "";
      return ret;
    }
    return "";
  }

  double _getDoubleParam(String name) {
    if (widget.params != null) {
      var ret = widget.params![name];
      ret ??= 0.0;
      return ret;
    }
    return 0.0;
  }
}
