//Flutter and Dart import
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/ui/widgets/riddle/letter.dart';

class LettersViewModel extends ChangeNotifier {
  final DatabaseServices _db;
  final Stream<User> _user;
  final Riddle _riddle;
  final StreamController _changeNotifier;
  static AudioCache player = AudioCache();
  List<Item> selectedItems = [];
  final List<Item> sourceList = [];
  final List<Item> targetList = [];
  List<Item> targetHitList = [];
  bool correctAnswer = false;
  bool wrongAnswer = false;

  LettersViewModel(
      {Riddle riddle,
      DatabaseServices db,
      Stream<User> user,
      StreamController changeNotifier})
      : _riddle = riddle,
        _db = db,
        _user = user,
        _changeNotifier = changeNotifier {
    getTargetList();
  }

  ///Add randoms characteres(LETTERS AND NUMBERS) to the supply secret word
  String randomCharacters() {
    String _word = _riddle.answer.toUpperCase();

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
    while (_word.length < 12) {
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
      generateTargetHit();
      String _word = randomCharacters();

      List<Item> _list;
      _list = List.generate(
        _word.length,
        (i) {
          return Item(
            id: i,
            letter: _word[i],
            isSource: true,
          );
        },
      );
      sourceList.addAll(_list);
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  ///Generate the Target Hit List
  generateTargetHit() {
    List.generate(
      _riddle.answer.length,
      (index) => {
        targetHitList.add(
          Item(id: index, letter: _riddle.answer[index]),
        )
      },
    );
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

  ///Get a list for the target, only if the user has previously solved it.
  getTargetList() async {
    var _response;

    //? I have to delay, cause the first it gets the current user it is not ready.
    //? There should be a better way to do it.
    await Future.delayed(
      Duration(seconds: 1),
      () async {
        _response = await _db.isSolvedBy(riddleId: _riddle.id);
      },
    );

    if (_response?.data != null) {
      var _list = List.generate(
        _riddle.answer.length,
        (i) {
          return Item(
            id: i,
            letter: _riddle.answer[i].toUpperCase(),
            isSource: false,
          );
        },
      );
      targetHitList.addAll(_list);
      selectedItems = targetHitList;

      correctAnswer = true;
      notifyListeners();
    } else {
      generateItemList();
    }
  }

  ///Return a color for the target list depending of the target list state
  ///if it is correct it get a color yellow, if it is wrong it get a color red
  ///if it is not correct or wrong it get white
  Color letterColor() {
    if (wrongAnswer) {
      return Colors.red[400];
    } else {
      return Colors.black;
    }
  }

  Color targetColor(bool isSelected) {
    if (correctAnswer) {
      return Colors.yellow[700];
    } else if (isSelected) {
      return Colors.white;
    } else {
      return Colors.black.withOpacity(0.15);
    }
  }

  ///Add letter to the target
  ///If it is equal to the riddle.word it get a color yellow
  void setLetter({Item item}) async {
    try {
      const tapAudioPath = 'audios/fingerTap.wav';
      const wrongChoiceAudioPath = 'audios/wrongChoice.wav';
      const successAudioPath = 'audios/success-fanfare-trumpets.mp3';

      selectedItems.add(item);
      var _userAnswer = getWord(selectedItems);

      if (_userAnswer == _riddle.answer.toUpperCase()) {
        if (_user != null)
          _db.setSolvedBy(
              riddleId: _riddle.id,
              ownerId: _riddle.ownerId,
              thumbnailUrl: _riddle.thumbnailUrl,
              text: _riddle.text);

        correctAnswer = true;
        player.play(successAudioPath);
        _changeNotifier.sink.add(true);
        notifyListeners();
      } else if (_userAnswer.length >= _riddle.answer.length) {
        player.play(wrongChoiceAudioPath);

        //Remove the last Item if it exceeds the limit
        if (_userAnswer.length > _riddle.answer.length)
          selectedItems.removeLast();

        wrongAnswer = true;
        notifyListeners();
      } else {
        //Play the basic tap sound
        player.play(tapAudioPath);
        notifyListeners();
      }
    } catch (e) {
      print('setLetter error: $e');
    }
  }

  ///Remove letter from the target list,
  ///If it is longer that the answer it get a red color
  void deleteLetter({int sourceItemId, int targetItemId}) {
    const tapAudioPath = 'audios/fingerTap.wav';

    sourceList[sourceItemId].isSource = true;
    selectedItems.removeAt(targetItemId);

    player.play(tapAudioPath);
    if (selectedItems.length < _riddle.answer.length) {
      wrongAnswer = false;
    }
    notifyListeners();
  }
}
