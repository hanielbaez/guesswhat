import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:guess_what/ui/widgets/guess/letter.dart';

class LettersViewModel extends ChangeNotifier {
  final DatabaseServices _db;
  final FirebaseUser _user;
  final Guess _guess;
  List<Item> selectedItems = [];
  List<Item> sourceList = [];
  List<Item> targetList = [];
  bool correctAnswear = false;

  LettersViewModel({Guess guess, DatabaseServices db, FirebaseUser user})
      : _guess = guess,
        _db = db,
        _user = user;

  ///Add randoms characteres(LETTERS AND NUMBERS) to the supply secret word
  String randomCharacters() {
    String _word = _guess.word.toUpperCase();

    final String _abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final String _numbers = '0123456789';
    String _newCharacter = '';
    final _random = Random();

    if (_word.contains(RegExp(r'[A-Z]'))) {
      _newCharacter = _abc;
    } else if (_word.contains(RegExp(r'[0-9]'))) {
      _newCharacter = _numbers;
    }

    // Add ulti 14 characters
    while (_word.length < 14) {
      _word += _newCharacter[_random.nextInt(_newCharacter.length)];
    }

    //Sort the string
    List<String> _list = _word.split('');
    _list.sort();
    _word = _list.join();
    return _word;
  }

  ///Generate a list of character for the source (SidedKick)
  generateItemList(context) {
    if (sourceList.isEmpty) {
      String _word = randomCharacters();

      List<Item> _list;
      _list = List.generate(
        _word.length,
        (i) {
          return Item(
            id: i,
            letter: _word[i],
          );
        },
      );
      sourceList = _list;
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  String getWord(List<Item> items) {
    //From a list of characters get a word
    String _word = '';
    items.forEach(
      (item) {
        _word += item.letter;
      },
    );
    return _word;
  }

  ///Returns a list for the destination list only if the user has previously solved it.
  getTargetList() async {
    var response = await _db.getGuessesDone(customID: _guess.id + _user.uid);
    if (response?.data != null) {
      var list = List.generate(
        _guess.word.length,
        (i) {
          return Item(
            id: i,
            letter: _guess.word[i].toUpperCase(),
          );
        },
      );
      targetList = list;
      correctAnswear = true;
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  void setLetter({Item selectedItem}) {
    //Add letter to the target
    selectedItems.add(selectedItem);
    var _selectedWord = getWord(selectedItems);
    if (_selectedWord == _guess.word.toUpperCase()) {
      print('Correct Answear!');
      if (_user != null) _db.setGuessesDone(customID: _guess.id + _user.uid);
      correctAnswear = true;
    }
  }

  void deleteLetter({Item selectedItem}) {
    //Remove letter from the target
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
  }
}
