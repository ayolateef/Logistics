import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:location/location.dart';

import '../../main.dart';
import '../../model/Geocodinglocation.dart';
import '../widgets/iboxCircle.dart';

// ignore: must_be_immutable
class MapInfoScreen extends StatefulWidget {
  Function(String, Map<String, dynamic>)? callback;
  final Map<String, dynamic>? params;
  MapInfoScreen({Key? key, this.callback, this.params}) : super(key: key);
  @override
  _MapInfoScreenState createState() => _MapInfoScreenState();
}

class _MapInfoScreenState extends State<MapInfoScreen> {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _backButtonPress() {
    if (selectLatLng == "true") {
      double _lat = (_currentPos != null) ? _currentPos.latitude : 0;
      double _lng = (_currentPos != null) ? _currentPos.longitude : 0;
      widget.callback!(_getStringParam("backRoute"), {
        "backLatitude": _lat,
        "backLongitude": _lng,
        "backRoute": _getStringParam("savedRoute"),
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
    } else {
      widget.callback!(_getStringParam("backRoute"), {});
    }
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  dynamic windowWidth;
  dynamic windowHeight;
  String? _mapStyle;
  var location = Location();
  double _currentZoom = 12;
  LatLng? _currentPos;

  double _getDoubleParam(String name) {
    if (widget.params != null) {
      var ret = widget.params![name];
      ret ??= 0.0;
      return ret;
    }
    return 0.0;
  }

  String _getStringParam(String name) {
    if (widget.params != null) {
      var ret = widget.params?[name];
      ret ??= "";
      return ret;
    }
    return "";
  }

  String selectLatLng = "";

  @override
  void initState() {
    selectLatLng = _getStringParam("selectLatLng");
    if (selectLatLng == "true") {
    } else {
      var lat = _getDoubleParam("lat");
      var lng = _getDoubleParam("lng");
      _kGooglePlex = CameraPosition(
        target: LatLng(lat: lat, lng: lng),
        zoom: _currentZoom,
      );
      _addMarker(lat, lng);
    }

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(lat: 48.895605, lng: 2.087823),
    zoom: 12,
  ); // paris coordinates
  Set<Marker> markers = {};
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (_controller != null) {}
    if (theme.darkMode) {
      _controller?.setMapStyle(_mapStyle);
    } else {
      _controller?.setMapStyle(null);
    }

    return WillPopScope(
        onWillPop: () async {
          _backButtonPress();
          return false;
        },
        child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
            child: Stack(children: <Widget>[
              _map(),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 15,
                        ),
                        _buttonPlus(),
                        _buttonMinus(),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        _buttonMyLocation(),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        _buttonBack(),
                        _buttonMyLocation(),
                      ],
                    )),
              ),
              if (selectLatLng == "true")
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: theme.colorBackgroundDialog,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(40),
                                spreadRadius: 6,
                                blurRadius: 6,
                                offset:
                                    Offset(2, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Text(
                            (_currentPos != null)
                                ? "${strings.get(129)} \n ${_currentPos?.latitude?.toStringAsFixed(6)}, ${_currentPos?.longitude.toStringAsFixed(6)}"
                                : "${strings.get(129)}",
                            style: theme.text14bold,
                            textAlign: TextAlign.center,
                          ) // "Select Place and Go Back",
                          )),
                ),
            ])));
  }

  _map() {
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled:
            false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled:
            true, // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled:
            false, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        onCameraMove: (CameraPosition cameraPosition) {
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {
          if (selectLatLng == "true") _selectPos(pos);
        },
        onLongPress: (LatLng pos) {},
        markers: markers != null ? Set<Marker>.from(markers) : null,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode) _controller?.setMapStyle(_mapStyle);
        });
  }

  _buttonPlus() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(
              child: Icon(
            Icons.add,
            size: 30,
            color: Colors.black.withOpacity(0.5),
          )),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  _controller?.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMinus() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(
              child: Icon(
            Icons.remove,
            size: 30,
            color: Colors.black.withOpacity(0.5),
          )),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  _controller?.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonBack() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(
              child: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black.withOpacity(0.5),
          )),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  _backButtonPress();
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMyLocation() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(
              child: Icon(
            Icons.my_location,
            size: 30,
            color: Colors.black.withOpacity(0.5),
          )),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  _getCurrentLocation();
                }, // needed
              )),
        )
      ],
    );
  }

  _getCurrentLocation() async {
    var position = await location.getCurrent();
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat: position.latitude, lng: position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  late MarkerId _lastMarkerId;

  _addMarker(double lat, double lng) {
    _lastMarkerId = MarkerId("addr$lat");
    final marker = Marker(
        markerId: _lastMarkerId, position: LatLng(lat, lng), onTap: () {});
    markers.add(marker);
  }

  _selectPos(LatLng pos) {
    markers.clear();
    _currentPos = pos;
    _lastMarkerId = MarkerId("addr${pos.latitude}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(pos.latitude, pos.longitude),
        onTap: () {});
    markers.add(marker);
    setState(() {});
  }
}
