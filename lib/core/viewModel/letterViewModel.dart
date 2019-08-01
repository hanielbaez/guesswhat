import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_what/ui/widgets/guess/letter.dart';

class LettersViewModel extends ChangeNotifier {
  String _guessWord;
  List<Item> selectedItems = [];
  List<Item> sourceList = [];
  bool correctAnswear = false;

  LettersViewModel({String guessWord}) : _guessWord = guessWord;

  String randomCharacters() {
    String _word = _guessWord.toUpperCase();
    //Add randoms characteres(LETTERS AND NUMBERS) to the supply secret word
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

//Generar una lista de character for the source (SidedKick)
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

  void setLetter({Item selectedItem}) {
    //Add letter to the target
    selectedItems.add(selectedItem);
    var _selectedWord = getWord(selectedItems);
    if (_selectedWord == _guessWord.toUpperCase()) {
      print('Correct Answear!');
      correctAnswear = true;
      //notifyListeners();
    }
  }

  void deleteLetter({Item selectedItem}) {
    //Remove letter from the target
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
  }
}
