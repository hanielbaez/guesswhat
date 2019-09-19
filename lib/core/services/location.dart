//Flutter and Dart import
import 'dart:async';

import 'package:geocoder/geocoder.dart' as geoCoder;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

//Self import
import 'package:Tekel/core/model/userLocation.dart';

class LocationServices {
  // final Geoflutterfire _geo = Geoflutterfire();
  final Location _location = Location();
  UserLocation _currentLocation;
  // Continuously emit location updates
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationServices() {
    _location.requestPermission().then((granted) {
      if (granted) {
        _location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            getAddress(
                    longitude: locationData.longitude,
                    latitude: locationData.latitude)
                .then((address) {
              var countryCode = address['location']['countryCode'];
              _locationController.add(
                UserLocation(
                  latitude: locationData.latitude.toString(),
                  longitude: locationData.longitude.toString(),
                  countryCode: countryCode,
                ),
              );
            });
          } else {
            _locationController.add(UserLocation());
          }
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  ///Return the LocatioData by the phone
  Future<LocationData> getCurrentLocation() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      return await _location.getLocation();
    }
    return null;
  }

  ///return Map Location
  Future getAddress({double latitude, double longitude}) async {
    try {
      final coordinates = new geoCoder.Coordinates(latitude, longitude);
      var listAddresses = await geoCoder.Geocoder.local
          .findAddressesFromCoordinates(coordinates);
      return {
        'location': {
          'countryCode': listAddresses.first.countryCode,
          'address': listAddresses.first.subLocality
        }
      };
    } catch (e) {
      print(e.toString());
    }
  }

  ///Return a Location Map with the user curren country and address
  Future<Map<String, dynamic>> getGeoPoint() async {
    var _locationData = await getCurrentLocation();
    if (_locationData == null) return null;
    var location = await getAddress(
        latitude: _locationData.latitude, longitude: _locationData.longitude);

    return location;
  }
}
