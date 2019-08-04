import 'package:flutter/cupertino.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/services/db.dart';

class GuessModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  final List<Guess> allGuesses = [];

  GuessModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  Future<List<Guess>> getAllGuesses() async {
    allGuesses.addAll(
      await _databaseServices.fectchGuesses(),
    );
    return allGuesses;
  }
}
