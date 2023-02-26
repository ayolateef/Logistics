import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../widgets/easyDialog2.dart';
import '../widgets/ibackbutton.dart';
import '../widgets/ibutton2.dart';
import '../widgets/iinputField2.dart';
import '../widgets/iline.dart';

class AddRestaurantScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;
  final Map<String, dynamic>? params;
  AddRestaurantScreen({Key? key, this.callback, this.params}) : super(key: key);

  @override
  _AddRestaurantScreenState createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _selectPositionOnMap() {
    widget.callback!("mapRestaurant", {
      "selectLatLng": "true",
      "backRoute": "addRestaurant",
      "savedRoute": _getStringParam("backRoute"),
      "edit": _getStringParam("edit"),
      "id": _getStringParam("id"),
      "latitude": _getDoubleParam("latitude"),
      "longitude": _getDoubleParam("longitude"),
      "name": _getStringParam("name"),
      "Address": _getStringParam("Address"),
      "phone": _getStringParam("phone"),
      "mobilephone": _getStringParam("mobilephone"),
      "desc": _getStringParam("desc"),
      "image": _getStringParam("image"),
    });
  }

  _onSaveRestaurant() {
    dprint("User pressed Save Restaurant");
  }

  _onBackPressed() {
    widget.callback!(_getStringParam("backRoute"), {});
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  var editControllerName = TextEditingController();
  var editControllerAddress = TextEditingController();
  var editControllerPhone = TextEditingController();
  var editControllerMobilePhone = TextEditingController();
  var editControllerLatitude = TextEditingController();
  var editControllerLongitude = TextEditingController();
  var editControllerDesc = TextEditingController();

  _initEditControllers() {
    editControllerLatitude.text =
        _getDoubleParam("latitude").toStringAsFixed(6);
    editControllerLongitude.text =
        _getDoubleParam("longitude").toStringAsFixed(6);
    editControllerName.text = _getStringParam("name");
    editControllerAddress.text = _getStringParam("Address");
    editControllerPhone.text = _getStringParam("phone");
    editControllerMobilePhone.text = _getStringParam("mobilephone");
    editControllerDesc.text = _getStringParam("desc");
    var lat = _getDoubleParam("backLatitude");
    var lng = _getDoubleParam("backLongitude");
    if (lat != 0 && lng != null) {
      editControllerLatitude.text = lat.toStringAsFixed(6);
      editControllerLongitude.text = lng.toStringAsFixed(6);
    }
  }

  @override
  void initState() {
    _initEditControllers();
    super.initState();
  }

  double _getDoubleParam(String name) {
    if (widget.params != null) {
      var _ret = widget.params![name];
      _ret ??= 0.0;
      return _ret;
    }
    return 0.0;
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerAddress.dispose();
    editControllerPhone.dispose();
    editControllerLatitude.dispose();
    editControllerLongitude.dispose();
    editControllerMobilePhone.dispose();
    editControllerDesc.dispose();
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

    var _text = strings.get(106); // "Add new Restaurant"
    if (_getStringParam("edit") == "true") {
      _text = strings.get(132);
    } // "Edit Restaurant"

    list.add(Container(
        alignment: Alignment.center,
        child: Text(
          _text!,
          style: theme.text18boldPrimary,
        )));

    list.add(const SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(113) ?? '', // name
          type: TextInputType.text,
          colorDefaultText: theme.colorDefaultText!,
          colorBackground: theme.colorBackground!,
          controller: editControllerName,
        )));

    list.add(Container(
      margin: const EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(114) ?? '',
        style: theme.text12bold,
      ), // Enter Restaurant Name
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(115) ?? '', // address
          colorDefaultText: theme.colorDefaultText!,
          type: TextInputType.text,
          colorBackground: theme.colorBackground!,
          controller: editControllerAddress,
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(116) ?? '',
        style: theme.text12bold,
      ), // "Enter Restaurant Address",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(63) ?? '', // Phone
          colorDefaultText: theme.colorDefaultText!,
          type: TextInputType.phone,
          colorBackground: theme.colorBackground!,
          controller: editControllerPhone,
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(117) ?? '',
        style: theme.text12bold,
      ), // "Enter Restaurant Phone",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(63) ?? '', // Phone
          colorDefaultText: theme.colorDefaultText!,
          type: TextInputType.phone,
          colorBackground: theme.colorBackground!,
          controller: editControllerPhone,
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(130) ?? '',
        style: theme.text12bold,
      ), // "Enter Restaurant Mobile Phone",
    ));

    list.add(const SizedBox(
      height: 20,
    ));

    list.add(
      Container(
          height: 40,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: IInputField2(
            hint: strings.get(118) ?? '', // "Latitude",
            colorDefaultText: theme.colorDefaultText!,
            type: TextInputType.phone,
            colorBackground: theme.colorBackground!,
            controller: editControllerLatitude,
          )),
    );

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(119) ?? '',
        style: theme.text12bold,
      ), // "Enter Latitude. Example: 52.2165157",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(
      Container(
          height: 40,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: IInputField2(
            hint: strings.get(120) ?? '', // "Longitude",
            colorDefaultText: theme.colorDefaultText!,
            type: TextInputType.phone,
            colorBackground: theme.colorBackground!,
            controller: editControllerLongitude,
          )),
    );

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(121) ?? '',
        style: theme.text12bold,
      ), // "Enter Longitude. Example: 2.331359",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: const EdgeInsets.only(right: 15),
      alignment: Alignment.bottomRight,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(122) ?? '?? ', // Select position on Map
          textStyle: theme.text14boldWhite!,
          pressButton: () {
            _selectPositionOnMap();
          }),
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(
      Container(
          height: 40,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: IInputField2(
            hint: strings.get(123) ?? '?? ', // "Description",
            colorDefaultText: theme.colorDefaultText!,
            type: TextInputType.text,
            colorBackground: theme.colorBackground!,
            controller: editControllerDesc,
          )),
    );

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(124) ?? '?? ',
        style: theme.text12bold,
      ), // "Enter description",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(_selectImage());
    list.add(SizedBox(
      height: 20,
    ));
    list.add(_drawImage());

    list.add(const SizedBox(
      height: 20,
    ));
    list.add(ILine());
    list.add(const SizedBox(
      height: 20,
    ));

    list.add(Container(
      alignment: Alignment.bottomCenter,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(65) ?? '', // Save
          textStyle: theme.text14boldWhite!,
          pressButton: () {
            _onSaveRestaurant();
          }),
    ));

    list.add(const SizedBox(
      height: 150,
    ));

    return list;
  }

  Widget _drawImage() {
    if (_imagePath.isNotEmpty) {
      return Container(
          height: windowWidth * 0.3,
          child: Image.file(
            File(_imagePath),
            fit: BoxFit.contain,
          ));
    } else {
      if (_getStringParam("image").isNotEmpty) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            width: MediaQuery.of(context).size.width,
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
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      }
    }
    return Container();
  }

  _selectImage() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          height: 100,
          width: windowWidth,
          decoration: BoxDecoration(
            color: theme.colorGrey,
            borderRadius: new BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 10),
            child: Opacity(
                opacity: 0.6,
                child: Text(
                  strings.get(125) ?? '',
                  style: theme.text12bold,
                ) // Click here for select Image
                ),
          ), // "Enter description",
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: UnconstrainedBox(
              child: Container(
                  height: 60,
                  width: 40,
                  child: Image.asset("assets/selectimage.png",
                      fit: BoxFit.contain))),
        ),
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: () {
                    _showMessage("");
                  }, // needed
                )),
          ),
        )
      ],
    );
  }

  String _getStringParam(String name) {
    if (widget.params != null) {
      var _ret = widget.params![name];
      _ret ??= "";
      return _ret;
    }
    return "";
  }

  double _show = 0;

  _showMessage(String id) {
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
              strings.get(126) ?? '',
              textAlign: TextAlign.center,
              style: theme.text18boldPrimary,
            ), // "Select image from",
            SizedBox(
              height: 50,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(127) ?? '', // "Camera",
                    textStyle: theme.text14boldWhite!,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                      getImage2(ImageSource.camera);
                    }),
                const SizedBox(
                  width: 10,
                ),
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(128) ?? '', // Gallery
                    textStyle: theme.text14boldWhite!,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                      getImage2(ImageSource.gallery);
                    }),
              ],
            )),
          ],
        ));
  }

  final picker = ImagePicker();
  String _imagePath = "";

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      print("Photo file: ${pickedFile.path}");
      _imagePath = pickedFile.path;
      setState(() {});
    }
  }
}
