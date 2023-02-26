import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../model/category.dart';
import '../widgets/easyDialog2.dart';
import '../widgets/ibackbutton.dart';
import '../widgets/ibutton2.dart';
import '../widgets/iinputField2.dart';
import '../widgets/iline.dart';

class AddDishesScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;
  final Map<String, dynamic>? params;
  const AddDishesScreen({Key? key, this.callback, this.params})
      : super(key: key);

  @override
  _AddDishesScreenState createState() => _AddDishesScreenState();
}

class _AddDishesScreenState extends State<AddDishesScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  _onSaveDishes() {
    dprint("User pressed Save Dishes");
  }

  _onBackPressed() {
    widget.callback!(_getStringParam("backRoute"), {
      "backRoute": _getStringParam("savedRoute"),
      "sort": _getStringParam("sort"),
    });
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  var editControllerName = TextEditingController();
  var editControllerPrice = TextEditingController();
  var editControllerDiscPrice = TextEditingController();
  var editControllerDesc = TextEditingController();
  var editControllerIngr = TextEditingController();

  _initEditControllers() {
    editControllerName.text = _getStringParam("name");
    editControllerPrice.text = _getStringParam("price");
    editControllerDiscPrice.text = _getDoubleParam("descPrice").toString();
    editControllerDesc.text = _getStringParam("desc");
    editControllerIngr.text = _getStringParam("Ingr");
  }

  @override
  void initState() {
    _initEditControllers();
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPrice.dispose();
    editControllerDiscPrice.dispose();
    editControllerDesc.dispose();
    editControllerIngr.dispose();
    super.dispose();
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
      padding: EdgeInsets.only(top: 0),
      children: _body2(),
    );
  }

  _body2() {
    var list = <Widget>[];

    list.add(const SizedBox(
      height: 20,
    ));

    var _text = strings.get(138); // "Add new Dishes",
    if (_getStringParam("edit") == "true") {
      _text = strings.get(137);
    } // "Edit Dishes"

    list.add(Container(
        alignment: Alignment.center,
        child: Text(
          _text!,
          style: theme.text18boldPrimary,
        )));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(113) ?? '', // name
          type: TextInputType.text,
          colorDefaultText: theme.colorDefaultText!,
          colorBackground: theme.colorBackground!,
          controller: editControllerName,
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(139) ?? '',
        style: theme.text12bold,
      ), // Enter Dishes Name
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(_category());
    list.add(Container(
      margin: const EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(146) ?? '',
        style: theme.text12bold,
      ), // Choose Dishes Category
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(140) ?? '', // Price
          colorDefaultText: theme.colorDefaultText!,
          type: TextInputType.number,
          colorBackground: theme.colorBackground!,
          controller: editControllerPrice,
        )));

    list.add(Container(
      margin: const EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(141) ?? '',
        style: theme.text12bold,
      ), // "Enter Dishes price",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(142) ?? '', // Discount Price
          colorDefaultText: theme.colorDefaultText!,
          type: TextInputType.number,
          colorBackground: theme.colorBackground!,
          controller: editControllerDiscPrice,
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(143) ?? '',
        style: theme.text12bold,
      ), // "Enter Discount Price",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(
      Container(
          height: 40,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: IInputField2(
            hint: strings.get(123) ?? '', // "Description",
            colorDefaultText: theme.colorDefaultText!,
            type: TextInputType.text,
            colorBackground: theme.colorBackground!,
            controller: editControllerDesc,
          )),
    );

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(124) ?? '',
        style: theme.text12bold,
      ), // "Enter description",
    ));

    list.add(const SizedBox(
      height: 20,
    ));

    list.add(
      Container(
          height: 40,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: IInputField2(
            hint: strings.get(144) ?? '', // "Ingredients",
            colorDefaultText: theme.colorDefaultText!,
            type: TextInputType.text,
            colorBackground: theme.colorBackground!,
            controller: editControllerIngr,
          )),
    );

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(145) ?? '',
        style: theme.text12bold,
      ), // "Enter Ingredients",
    ));
    list.add(SizedBox(
      height: 20,
    ));

    list.add(_selectImage());
    list.add(SizedBox(
      height: 20,
    ));
    list.add(_drawImage());

    list.add(SizedBox(
      height: 20,
    ));
    list.add(ILine());
    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      alignment: Alignment.bottomCenter,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(65) ?? '', // Save
          textStyle: theme.text14boldWhite!,
          pressButton: () {
            _onSaveDishes();
          }),
    ));

    list.add(SizedBox(
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
              errorWidget: (context, url, error) => Icon(Icons.error),
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
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 100,
          width: windowWidth,
          decoration: BoxDecoration(
            color: theme.colorGrey,
            borderRadius: BorderRadius.circular(10),
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
          margin: const EdgeInsets.only(top: 10),
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
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      _imagePath = pickedFile.path;
      setState(() {});
    }
  }

  var _value = "";

  _category() {
    var menuItems = <DropdownMenuItem>[];
    for (var item in categories) {
      menuItems.add(
        DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name ?? '',
            style: theme.text14,
          ),
        ),
      );
      if (_value.isEmpty) {
        _value = item.id!;
        if (_getStringParam("edit") == "true" &&
            _getStringParam("CategoryId") == item.id) {
          _value = item.id!;
        }
      }
    }
    return Container(
        width: windowWidth,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _value,
                items: menuItems,
                onChanged: (value) {
                  setState(() {
                    _value = 'value';
                  });
                })));
  }

  double _getDoubleParam(String name) {
    if (widget.params != null) {
      var _ret = widget.params![name];
      _ret ??= 0.0;
      return _ret;
    }
    return 0.0;
  }
}
