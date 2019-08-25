import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';

class SupportContact {
  final String userId;
  final String userEmail;
  final String description;
  //static Map<String, dynamic> deviceInfo;
  final Timestamp creationDate = Timestamp.now();

  SupportContact({this.userId, this.description, this.userEmail});

  Future<Map> getDeviceInfo() async {
    Map<String, dynamic> map = Map<String, dynamic>();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    map['model'] = androidInfo.model;
    map['product'] = androidInfo.product;
    map['supportedAbis'] = androidInfo.supportedAbis;
    map['baseOS'] = androidInfo.version.baseOS;
    map['androidId'] = androidInfo.androidId;
    map['bootloader'] = androidInfo.bootloader;
    map['device'] = androidInfo.device;
    map['display'] = androidInfo.display;
    map['fingerprint'] = androidInfo.fingerprint;
    map['hardware'] = androidInfo.hardware;
    map['host'] = androidInfo.host;
    map['isPhysicalDevice'] = androidInfo.isPhysicalDevice;
    map['manufacture'] = androidInfo.manufacturer;
    return map;
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> _map = Map<String, dynamic>();
    _map['userId'] = this.userId;
    _map['userEmail'] = this.userEmail;
    _map['description'] = this.description;
    _map['deviceInfo'] = await getDeviceInfo();
    _map['creationDate'] = this.creationDate;
    return _map;
  }
}
