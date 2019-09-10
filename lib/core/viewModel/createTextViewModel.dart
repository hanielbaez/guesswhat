import 'package:Tekel/core/custom/customGeoPoint.dart';
import 'package:Tekel/core/services/db.dart';

class CreateTextViewModel {
  final DatabaseServices _db;

  CreateTextViewModel({db}) : _db = db;

  void upload(Map<String, dynamic> riddle) async {
    //Get the current user information
    var user = await _db.getUser();
    Map<String, dynamic> userMap = {
      'user': {
        'uid': user.uid,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
      }
    };

    riddle.addAll(userMap);

    //Add the user location
    var riddleLocation = await CustomGeoPoint().addGeoPoint();
    if (riddleLocation != null) {
      riddle.addAll({'location': riddleLocation});
    }

    riddle.addAll({'creationDate': DateTime.now()});

    _db.uploadRiddle(riddle);
  }
}
