import 'package:flutter/cupertino.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/services/db.dart';

class GuessModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  final List<Guess> _allGuesses = [];

  GuessModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  List<Guess> get allGuesses => _allGuesses;

  Future<void> getAllGuesses() async {
    _allGuesses.addAll(
      await _databaseServices.fectchGuesses(),
    );
    notifyListeners();
  }

}
