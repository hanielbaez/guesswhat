import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/model/ridlle.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:guess_what/ui/widgets/ridlle/letter.dart';

class LettersViewModel extends ChangeNotifier {
  final DatabaseServices _db;
  final FirebaseUser _user;
  final Ridlle _ridlle;
  final StreamController _changeNotifier;
  static AudioCache player = new AudioCache();
  List<Item> selectedItems = [];
  List<Item> sourceList = [];
  List<Item> targetList = [];
  bool correctAnswer = false;
  bool wronganswer = false;

  LettersViewModel(
      {Ridlle ridlle,
      DatabaseServices db,
      FirebaseUser user,
      StreamController changeNotifier})
      : _ridlle = ridlle,
        _db = db,
        _user = user,
        _changeNotifier = changeNotifier;

  ///Add randoms characteres(LETTERS AND NUMBERS) to the supply secret word
  String randomCharacters() {
    String _word = _ridlle.answer.toUpperCase();

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
    var response = await _db.getRidlleDone(customID: _ridlle.id + _user.uid);
    if (response?.data != null) {
      var list = List.generate(
        _ridlle.answer.length,
        (i) {
          return Item(
            id: i,
            letter: _ridlle.answer[i].toUpperCase(),
          );
        },
      );
      targetList = list;
      correctAnswer = true;
      Future.delayed(Duration.zero, () => notifyListeners());
    } else {
      generateItemList();
    }
  }

  ///Return a color for the target list depending of the target list state
  ///if it is correct it get a color yellow, if it is wrong it get a color red
  ///if it is not correct or wrong it get white
  Color letterColor(bool isSource) {
    if ((correctAnswer) && !isSource) {
      return Colors.yellow;
    } else if (wronganswer && !isSource) {
      return Colors.red[400];
    } else {
      return Colors.white;
    }
  }

  ///Add letter to the target
  ///If it is equal to the ridlle.word it get a color yellow
  void setLetter({Item selectedItem}) {
    const tapAudioPath = 'audios/fingerTap.wav';
    const wrongChoiceAudioPath = 'audios/wrongChoice.wav';
    const successAudioPath = 'audios/success.wav';

    selectedItems.add(selectedItem);
    var _selectedWord = getWord(selectedItems);

    if (_selectedWord == _ridlle.answer.toUpperCase()) {
      if (_user != null)
        _db.setRidlleDone(
            customID: _ridlle.id + _user.uid,
            ridlleId: _ridlle.id,
            userId: _user.uid);
      correctAnswer = true;
      player.play(successAudioPath);
      _changeNotifier.sink.add(true);
    } else if (_selectedWord.length >= _ridlle.answer.length) {
      player.play(wrongChoiceAudioPath);
      wronganswer = true;
    } else {
      //Play the basic tap sound
      player.play(tapAudioPath);
    }
  }

  ///Remove letter from the target list
  ///If it is longer that the answer it get a red color
  void deleteLetter({Item selectedItem}) {
    const tapAudioPath = 'audios/fingerTap.wav';
    int _letterID = selectedItem.id;
    selectedItems.removeWhere((item) => item.id == _letterID);
    player.play(tapAudioPath);
    if (selectedItems.length < _ridlle.answer.length) {
      wronganswer = false;
    }
  }
}
