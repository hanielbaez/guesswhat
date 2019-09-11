//Flutter and Dart import
import 'package:geocoder/geocoder.dart' as geoCoder;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class CustomGeoPoint {
  // final Geoflutterfire _geo = Geoflutterfire();
  final Location _location = Location();

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
          'country': listAddresses.first.countryName,
          'address': listAddresses.first.subLocality
        }
      };
    } catch (e) {
      print(e.toString());
    }
  }

  ///Return a Location Map with the user curren country and address
  Future<Map<String, dynamic>> addGeoPoint() async {
    var _locationData = await getCurrentLocation();
    if (_locationData == null) return null;
    var location = await getAddress(
        latitude: _locationData.latitude, longitude: _locationData.longitude);

    return location;
  }
}
