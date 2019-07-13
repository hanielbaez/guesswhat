import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/ui/widgets/letter.dart';
import 'package:provider/provider.dart';
import 'package:guess_what/core/services/db.dart';

class LettersViewModel extends ChangeNotifier {
  String selectedLetters = '';
  List<Item> sourceList;
  bool _done = false;

  Future<String> getWord(BuildContext context) async {
    Guess _guess;
    _guess =
        await Provider.of<DatabaseServices>(context, listen: false).getGuess();
    return _guess.word;
  }

  Future<void> generateList(context) async {
    String _word = await getWord(context);

    List<Item> _list;
    _list = List.generate(
      _word.length,
      (i) => Item(
            id: i,
            letter: _word[i],
          ),
    );
    sourceList = _list;
    !_done ? notifyListeners() : null;
    _done = true;
  }

  void setItem({Item selectedItem}) {
    String _letter = selectedItem.letter;
    selectedLetters = selectedLetters + _letter;
    print('DEBBUG THE LETTERS ARE $selectedLetters');
  }
}
