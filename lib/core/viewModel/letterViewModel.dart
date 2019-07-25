import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_what/ui/widgets/guess/letter.dart';

class LettersViewModel extends ChangeNotifier {
  String _guessWord;
  List<Item> selectedItems = [];
  List<Item> sourceList = [];

  LettersViewModel({String guessWord}) : _guessWord = guessWord;

  //TODO: Revisar cuando la respuesta es correcta.

  String randomLetters(context) {
    //Add randoms letters to the supply secret word
    final String _abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final _random = Random();
    String _word = _guessWord.toUpperCase();

    while (_word.length < 14) {
      _word += _abc[_random.nextInt(_abc.length)];
    }

    //Sort the string
    List<String> _list = _word.split('');
    _list.sort();
    _word = _list.join();
    return _word;
  }

  generateItemList(context) {
    //Generar una lista de character for the source (SidedKick)
    if (sourceList.isEmpty) {
      String _word = randomLetters(context);

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
    if (_selectedWord == _guessWord) {
      print('Correct Answear!');
    }
  }

  void deleteLetter({Item selectedItem}) {
    //Remove letter from the target
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
  }
}
