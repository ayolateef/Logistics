import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide LocationAccuracy;

//
// v2.0 - 29/09/2020
//

class LocationPos {
  Position? _currentPosition;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;

  Future<Position?> getCurrent() async {
    _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .timeout(const Duration(seconds: 10), onTimeout: () async {
      throw Geolocator.getLastKnownPosition()
          .timeout(const Duration(seconds: 10));
    });
    return _currentPosition;
  }

  distance(double lat, double lng) async {
    var _distanceInMeters = -1.0;
    Location location = Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude, _currentPosition!.longitude, lat, lng);

    return _distanceInMeters;
  }

  distanceBetween(double lat, double lng, double lat2, double lng2) async {
    var _distanceInMeters = -1.0;
    _distanceInMeters = Geolocator.distanceBetween(lat2, lng2, lat, lng);
    return _distanceInMeters;
  }
}

timeout(Duration duration) {}
