import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/geoservices/update_user_location.dart';

/// https://pub.dev/packages/geolocator
/// https://www.digitalocean.com/community/tutorials/flutter-geolocator-plugin
class LocationService {
  Position _currentPosition;
  Position _currentLocation;
  String _currentAddress;

  LocationService() {
    //checkPermission();
  }

  Future<LocationPermission> checkPermission() async {
    return await checkPermission();
  }

  Future<Position> getLastKnownLocation() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /*final Geolocator geolocator = Geolocator()
        // enable fusedLocationProvider on android device to get faster location update
        ..forceAndroidLocationManager = Platform.isAndroid;*/
      _currentLocation = await Geolocator.getLastKnownPosition();
    } on PlatformException {
      _currentLocation = null;
    }
    print(_currentPosition);
    return _currentLocation;
  }

  Future<Position> getCurrentLocation() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
    } on PlatformException {
      _currentLocation = null;
    }
    print(_currentPosition);
    return _currentPosition;
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    final List<Placemark> placemarks =
        await Future(() => placemarkFromCoordinates(latitude, longitude))
            .catchError((onError) {
      print(onError);
      return Future.value(List<Placemark>());
    });

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark place = placemarks[0];
      _currentAddress =
          "${place.subLocality}, ${place.locality}, ${place.postalCode}";
    }
    return _currentAddress;
  }

  Future<String> getLocationFromAddress(String geoAddress) async {
    final List<Location> locations =
        await Future(() => locationFromAddress(geoAddress))
            .catchError((onError) {
      print(onError);
      return Future.value(List<Location>());
    });

    if (locations != null && locations.isNotEmpty) {
      _currentAddress = locations[0].toString();
    }
    return _currentAddress;
  }

  _bindLocationChangeEvent() {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() + ', ' + position.longitude.toString());
    });
    print(positionStream);
  }

  // call for public
  Future initService() async {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (ConstantValues.isUserLogin) UpdateUserLocation().update();
    });
  }
}
