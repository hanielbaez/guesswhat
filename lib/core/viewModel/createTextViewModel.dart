import 'package:Tekel/core/services/db.dart';

class CreateTextViewModel {
  final DatabaseServices _db;

  CreateTextViewModel({db}) : _db = db;

  Future upload(Map<String, dynamic> riddle) async {
    await _db.uploadRiddle(riddle);
    return true;
  }
}
