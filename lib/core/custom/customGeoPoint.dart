//Flutter and Dart import
import 'package:geocoder/geocoder.dart' as geoCoder;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class CustomGeoPoint {
  final Geoflutterfire _geo = Geoflutterfire();
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

  ///Return the subLocality of a given coordinate
  Future getAddress({double latitude, double longitude}) async {
    final coordinates = new geoCoder.Coordinates(latitude, longitude);
    var listAddresses =
        await geoCoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return listAddresses.first.subLocality;
  }

  ///Return a Map with the user curren address and geoPoints
  Future<Map<dynamic, dynamic>> addGeoPoint() async {
    var _locationData = await getCurrentLocation();
    if (_locationData == null) return null;
    var address = await getAddress(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    var geoLocation = _geo.point(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    return {'address': address, 'position': geoLocation.data};
  }
}
