//Flutter and Dart import
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class CustomGeoPoint {
  final Geoflutterfire _geo = Geoflutterfire();
  final Location _location = Location();

  Future<LocationData> getCurrentLocation() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      return await _location.getLocation();
    }
    return null;
  }

  ///Return a Map withe the user curren location and geoPoints
  Future<Map<dynamic, dynamic>> addGeoPoint() async {
    var _locationData = await getCurrentLocation();
    if (_locationData == null) return null;
    var geoLocation = _geo.point(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    return geoLocation.data;
  }
}
