import 'dart:async';
import 'package:flutter_app/models/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocation _currentLocation;

  Location location = new Location();

  // Set up location stream
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  // Stream used for updating the user's location dynamically
  Stream<UserLocation> get locationStream => _locationController.stream;

  // Request all necessary permissions to use location
  Future<void> requestPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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
  }

  // Used for starting the location stream
  LocationService() {
    location.requestPermission().then((PermissionStatus granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((data) {
          if (data != null) {
            _locationController
                .add(UserLocation(data.latitude, data.longitude));
          }
        });
      }
    });
  }

  // Get current location (non-dynamically)
  Future<UserLocation> getLocation() async {
    try {
      await requestPermission();
      var userLocation = await location.getLocation();
      _currentLocation =
          UserLocation(userLocation.latitude, userLocation.longitude);
    } catch (e) {
      print(e.toString());
    }
    return _currentLocation;
  }
}
