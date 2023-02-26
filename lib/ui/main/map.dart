import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../config/googleApi.dart';
import '../../main.dart';
import '../../model/Geocodinglocation.dart';
import '../../model/account.dart';
import '../../model/order.dart';
import '../../servicelocator.dart';
import 'dart:math';
import 'package:latlong2/latlong.dart' as lnlt;
import 'package:location/location.dart' as locations;

import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import '../../viewmodel/orderlistdata.dart';
import '../widgets/iboxCircle.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  Function(String)? callback;
  MapScreen({Key? key, this.callback}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  String gapikey = "AIzaSyA_O-vvaa6KAqb6GYHzh4A7BLFr-FHE6l8";
  Account? account;
  var orders = [];
  bool _isLoading = true;
  bool _serviceEnabled = false;
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();

  final OrderListDataViewModel _orderlistviewmodel =
      serviceLocator<OrderListDataViewModel>();

  BitmapDescriptor? pinLocationIcon;
  static LatLng _initialPosition = LatLng(48.895605, 2.087823);

  @override
  void didChangeDependencies() async {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.userName);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    orders = kIsWeb
        ? await _orderlistviewmodel.orders2(token, account?.email ?? '')
        : await _orderlistviewmodel.orders(token, account?.email ?? '');
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/googlepointer.png');
    setPermissions();
    _getUserLocation();
    if (account?.openOrderOnMap != "") {}
    for (var item in orders) {
      if (item.id == account?.openOrderOnMap) {
        print("got here to set the position");
        _kGooglePlex = CameraPosition(
          target:
              LatLng(lat: item.address1Latitude, lng: item.address1Longitude),
          zoom: _currentZoom,
        ); // paris coordinates
      }
    }
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _add();
    Future.delayed(const Duration(seconds: 7), () {});
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  void _getUserLocation() async {
    Position? position;
    locations.LocationData? positionLast;

    if (kIsWeb) {
      var location = locations.Location();
      positionLast = await location.getLocation();
    } else {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("user lat- ${position.latitude}");
      print("user lng- ${position.longitude}");
    }
    // Position position = await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // List<Placemark> placemark = await Geolocator()
    //     .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = kIsWeb
          ? LatLng(lat: positionLast?.latitude, lng: positionLast?.longitude)
          : LatLng(lat: position?.latitude, lng: position?.longitude);
      //  print('${placemark[0].name}');
    });
  }

  void setPermissions() async {
    locations.Location location = locations.Location();
    if (!kIsWeb) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
    } else {
      var permissionGranted = await location.hasPermission();
      _serviceEnabled = await location.serviceEnabled();

      if (permissionGranted != PermissionStatus.granted || !_serviceEnabled) {
        permissionGranted = await location.requestPermission();
        _serviceEnabled = await location.requestService();
      } else {
        print("-----> $_serviceEnabled");

        setState(() {
          _serviceEnabled = true;
          //  _loading = false;
        });
      }
    }
  }

  dynamic windowWidth;
  dynamic windowHeight;
  String _currentDistance = "";
  String? _mapStyle;
  //var location = Location();
  double _currentZoom = 12;

  _initCameraPosition(Order item, LatLng coord) async {
    // calculate zoom
    LatLng latLng_1 = LatLng(
      lat: item.address1Latitude,
      lng: item.address1Longitude,
    );
    LatLng latLng_2 =
        LatLng(lat: item.address2Latitude, lng: item.address2Longitude);
    dprint("latLng_1 = $latLng_1");
    dprint("latLng_2 = $latLng_2");
    Dio dio = Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${item.address1Latitude},${item.address1Longitude}&destinations=${item.address2Latitude}%2C, ${item.address2Longitude}&key=$gapikey");
    print(response.data);
    LatLngBounds bound;
    if (latLng_1.latitude >= latLng_2.latitude) {
      if (latLng_1.longitude <= latLng_2.longitude) {
        latLng_1 = LatLng(
          item.address1Latitude,
          item.address2Longitude,
        );
        latLng_2 = LatLng(item.address2Latitude, item.address1Longitude);
      }
      bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
    } else {
      bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
    }

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    // if (_controller != null)
    //   _controller.animateCamera(u2).then((void v) {
    //     // check(u2,_controller);
    //   });
    var distance2 = const lnlt.Distance();

    // km = 423
    // final km = distance2.as(lnlt.LengthUnit.Kilometer, lnlt.LatLng(item.address1Latitude,
    //       item.address1Longitude),
    //     lnlt.LatLng(item.address2Latitude, item.address2Longitude));
    //   double distance = await location.distanceBetween(item.address1Latitude,
    //       item.address1Longitude, item.address2Latitude, item.address2Longitude);
    //   // _currentDistance = (distance / 1000).toStringAsFixed(0); // to km
    _currentDistance = item.distance.toString(); // to km
    print("Distance - $_currentDistance");
    setState(() {});
  }

  LatLng coordinates1 = LatLng(lat: 48.895605, lng: 2.087823);
  LatLng? coordinates2;

//  void check(CameraUpdate u, GoogleMapController c) async {
//    c.animateCamera(u);
//    _controller.animateCamera(u);
//    LatLngBounds l1=await c.getVisibleRegion();
//    LatLngBounds l2=await c.getVisibleRegion();
//    print(l1.toString());
//    print(l2.toString());
//    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
//      check(u, c);
//  }

  final Map<PolylineId, Polyline> _mapPolyLines = {};
  int _polylineIdCounter = 1;
  Future<void> _add() async {
    for (var item in orders) {
      if (item.id == account?.openOrderOnMap) {
        print("Longitude : ${item.address1Latitude}");
        print("Latitude : ${item.address1Longitude}");
        final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
        _polylineIdCounter++;
        final PolylineId polylineId = PolylineId(polylineIdVal);

        var polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApi,
          PointLatLng(item.address1Latitude, item.address1Longitude),
          PointLatLng(item.address2Latitude, item.address2Longitude),
          travelMode: TravelMode.driving,
        );
        List<LatLng> polylineCoordinates = [];

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates
                .add(LatLng(lat: point.latitude, lng: point.longitude));
          }
        }

        final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.red,
          width: 4,
          points: polylineCoordinates,
        );

        setState(() {
          _mapPolyLines[polylineId] = polyline;
        });
        LatLng coordinates =
            LatLng(lat: item.address1Longitude, lng: item.address1Latitude);
        if (polylineCoordinates.isNotEmpty) {
          coordinates = polylineCoordinates[polylineCoordinates.length ~/ 2];
        }
        _initCameraPosition(item, coordinates);
        coordinates1 =
            LatLng(lat: item.address1Longitude, lng: item.address1Latitude);
        //   coordinates2 = LatLng(item.address1Longitude, item.address1Latitude);
        print(coordinates1);
        _addMarker(item);
      }
    }
  }

  _callUser() async {
    for (var item in orders) {
      if (item.id == account?.openOrderOnMap) {
        var uri = 'tel:${item.phone}';
        if (await canLaunchUrl(Uri.parse(uri))) await launchUrl(Uri.parse(uri));
      }
    }
  }

  @override
  void initState() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.userName);
    // var _openOrdermap;
    // if(account.openOrderOnMap == null) _openOrdermap = "";
    _isLoading = true;

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
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

    var body = Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
        child: Stack(children: <Widget>[
          _map(),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
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
                margin: EdgeInsets.only(left: 10),
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
                    _buttonCall(),
                    _buttonOrder(),
                  ],
                )),
          ),
          if (_currentDistance.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: theme.colorBackgroundDialog,
                        borderRadius: new BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(40),
                            spreadRadius: 6,
                            blurRadius: 6,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                          "${strings.get(46)}: $_currentDistance ${strings.get(49)}",
                          style: theme.text14bold) // Distance 4 km
                      )),
            ),
        ]));

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

    return Scaffold(
      body: Container(child: _isLoading ? bodyProgress : body),
    );
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
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 12,
        ),
        polylines: Set<Polyline>.of(_mapPolyLines.values),
        onCameraMove: (CameraPosition cameraPosition) {
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {},
        onLongPress: (LatLng pos) {},
        markers: markers != null ? Set<Marker>.from(markers) : null,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _controller?.moveCamera(CameraUpdate.newLatLng(coordinates1));

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
                  widget.callback!(account?.backRouteMap ?? '');
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonCall() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(
              child: Icon(
            Icons.phone,
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
                  _callUser();
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonOrder() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(
              child: Icon(
            Icons.assignment,
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
                  account?.currentOrderSet(account?.openOrderOnMap ?? '');
                  account?.backRouteset("orders");
                  widget.callback!("orderDetails");
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMyLocation() {
    return Stack(
      children: <Widget>[
        SizedBox(
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
    dynamic location;
    if (kIsWeb) {
      location = locations.Location();
    } else {
      location = Location();
    }

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

  _addMarker(Order item) {
    print("add marker ${item.id}");
    _lastMarkerId = MarkerId("addr1${item.id}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position:
            LatLng(lat: item.address1Latitude, lng: item.address1Longitude),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {});
    markers.add(marker);
    _lastMarkerId = MarkerId("addr2${item.id}");
    final marker2 = Marker(
        markerId: _lastMarkerId,
        position:
            LatLng(lat: item.address2Latitude, lng: item.address2Longitude),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {});
    markers.add(marker2);
    print(markers);
  }
}
