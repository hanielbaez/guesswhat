import 'package:Tekel/core/services/db.dart';

class CreateTextViewModel {
  final DatabaseServices _db;

  CreateTextViewModel({db}) : _db = db;

  Future upload(Map<String, dynamic> riddle) async {
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
    await _db.uploadRiddle(riddle);
    return true;
  }
}
