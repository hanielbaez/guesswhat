import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_what/ui/widgets/guess/letter.dart';

class LettersViewModel extends ChangeNotifier {
  String word;
  List<Item> selectedItems = [];
  List<Item> sourceList = [];

  LettersViewModel({this.word});

  //TODO: Revisar cuando la respuesta es correcta.

  /*  Future<String> fetchWord(BuildContext context) async {
    Guess _guess;
    _guess =
        await Provider.of<DatabaseServices>(context, listen: false).getGuess();
    return _guess.word;
  } */

  String randomLetters(context) {
    final String _abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final _random = Random();
    String _word = word.toUpperCase();

    while (_word.length < 12) {
      _word += _abc[_random.nextInt(_abc.length)];
    }

    //Sort the string
    List<String> _list = _word.split('');
    _list.sort();
    _word = _list.join();
    return _word;
  }

  generateItemList(context) {
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
    var _selectedWord = getWord(selectedItems);
    if (_selectedWord == word) {
      print('Correct Answear!');
    }
  }

  void deleteLetter({Item selectedItem}) {
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
  }
}
