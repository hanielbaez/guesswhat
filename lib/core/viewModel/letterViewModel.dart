import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/ui/widgets/letter.dart';
import 'package:provider/provider.dart';
import 'package:guess_what/core/services/db.dart';

//TODO: Generate random letters and fix the letter size.

class LettersViewModel extends ChangeNotifier {
  List<Item> selectedItems = [];
  List<Item> sourceList = [];

  Future<String> fetchWord(BuildContext context) async {
    Guess _guess;
    _guess =
        await Provider.of<DatabaseServices>(context, listen: false).getGuess();
    return _guess.word;
  }

  Future<String> randomLetters(context) async {
    final String _abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final _random = Random();
    String _word = await fetchWord(context);

    while (_word.length < 14) {
      _word += _abc[_random.nextInt(_abc.length)];
    }

    //Sort the string
    List<String> _list = _word.split('');
    _list.sort();
    _word = _list.join();
    print(_word);
    return _word;
  }

  // ? This function run two time, do not know way.
  Future<void> generateItemList(context) async {
    if (sourceList.isEmpty) {
      String _word = await randomLetters(context);

      List<Item> _list;
      _list = List.generate(
        _word.length,
        (i) {
          print(i);
          return Item(
            id: i,
            letter: _word[i],
          );
        },
      );
      sourceList = _list;
      notifyListeners();
    }
  }

  String getWord(List<Item> items) {
    String _word = '';
    items.forEach(
      (item) {
        _word += item.letter;
      },
    );
    return _word;
  }

  void setLetter({Item selectedItem}) {
    selectedItems.add(selectedItem);
    var _word = getWord(selectedItems);
    print('DEBBUG THE LETTERS ARE $_word');
  }

  void deleteLetter({Item selectedItem}) {
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
  }
}
