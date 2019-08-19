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
  bool wrongAnswear = false;

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
  generateItemList() {
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

  ///Get a list for the target list only if the user has previously solved it.
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
    }else{
      generateItemList();
    }
  }

  ///Return a color for the target list depending of the target list state
  ///if it is correct it get a color yellow, if it is wrong it get a color red
  ///if it is not correct or wrong it get white
  Color letterColor(bool isSource) {
    if ((correctAnswear) && !isSource) {
      return Colors.yellow;
    } else if (wrongAnswear && !isSource) {
      return Colors.red[400];
    } else {
      return Colors.white;
    }
  }

  ///Add letter to the target
  ///If it is equal to the guess.word it get a color yellow
  void setLetter({Item selectedItem}) {
    selectedItems.add(selectedItem);
    var _selectedWord = getWord(selectedItems);
    if (_selectedWord == _guess.word.toUpperCase()) {
      if (_user != null) _db.setGuessesDone(customID: _guess.id + _user.uid);
      correctAnswear = true;
    } else if (_selectedWord.length >= _guess.word.length) {
      wrongAnswear = true;
    }
  }

  ///Remove letter from the target list
  ///If it is longer that the answear it get a red color
  void deleteLetter({Item selectedItem}) {
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
    if (selectedItems.length < _guess.word.length) {
      wrongAnswear = false;
    }
  }
}
