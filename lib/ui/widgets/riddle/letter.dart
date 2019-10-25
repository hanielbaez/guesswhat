//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:mime/mime.dart';

//Self import
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:Tekel/core/custom/customCacheManager.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:share_extend/share_extend.dart';

class Item {
  Item({
    this.id,
    this.letter,
    this.isSource,
  });
  final int id;
  final String letter;
  bool isSource;
}

class CustomLetter extends StatelessWidget {
  final Item item;
  final LettersViewModel model;
  final Riddle riddle;

  CustomLetter({this.item, this.model, this.riddle});

  void onTapAction(context) async {
    if (item.letter != '?') {
      //If correct aswear TRUE do nothing
      if (item.isSource && !model.correctAnswer) {
        if (!model.wrongAnswer) item.isSource = !item.isSource;
        model.setLetter(item: item);
      }
    } else {
      if (riddle != null) {
        var url = riddle.imageUrl ?? riddle.videoUrl;
        if (url != null) {
          var f = await CustomCacheManager().getSingleFile('$url');
          var mimeType = lookupMimeType(f.path.split('/').first);
          ShareExtend.share(f.path, mimeType);
        } else {
          ShareExtend.share(riddle.text, 'text');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isQuestion = item.letter == '?';
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: InkWell(
        onTap: () => onTapAction(context),
        child: Opacity(
          opacity: item.isSource ? 1 : 0.3,
          child: Container(
            height: 50,
            width: isQuestion ? 120 : 50,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 10.0,
              color: isQuestion ? Colors.yellow[700] : Colors.white,
              child: Center(
                child: Text(
                  item.letter,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: isQuestion ? Colors.black : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
