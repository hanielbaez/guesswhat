//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

//Self import
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:flutter_icons/simple_line_icons.dart';

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
  final ScreenshotController screenShot;

  CustomLetter({this.item, this.model, this.riddle, this.screenShot});

  void onTapAction(context) async {
    if (item.letter != 'share' && item.letter != 'trash') {
      //If correct aswear TRUE do nothing
      if (item.isSource && !model.correctAnswer) {
        if (!model.wrongAnswer) item.isSource = !item.isSource;
        model.setLetter(item: item);
      }
    } else {
      if (item.letter == 'share') {
        if (riddle != null) {
          try {
            var imageFile =
                await screenShot.capture(delay: Duration(milliseconds: 40));
            ShareExtend.share(imageFile.path, 'image');
          } catch (e) {
            print('Screenshot error: $e');
          }
        }
      } else {
        model.deleteLetter();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isShare = item.letter == 'share';
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: InkWell(
        onTap: () => onTapAction(context),
        child: Opacity(
          opacity: item.isSource ? 1 : 0.3,
          child: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 10.0,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              color: isShare ? Colors.yellow[700] : Colors.white,
              child: Center(
                child: item.letter == 'share' || item.letter == 'trash'
                    ? Icon(
                        SimpleLineIcons.getIconData('${item.letter}'),
                        color: isShare ? Colors.black : Colors.red,
                      )
                    : Text(
                        item.letter,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: isShare ? Colors.black : Colors.black),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
