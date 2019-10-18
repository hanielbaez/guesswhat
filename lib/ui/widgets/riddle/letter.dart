//Flutter and Dart import
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//Self import
import 'package:Tekel/core/viewModel/letterViewModel.dart';

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

  CustomLetter({this.item, this.model});

  void onTapAction(context) {
    if (item.letter != '?') {
      //If correct aswear TRUE do nothing
      if (item.isSource && !model.correctAnswer) {
        if (!model.wrongAnswer) item.isSource = !item.isSource;
        model.setLetter(item: item);
      }
    } else {
      Alert(
        context: context,
        title: AppLocalizations.of(context).tr('hints.title'),
        content: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            RaisedButton.icon(
              label: Text(
                AppLocalizations.of(context).tr('hints.askFriend'),
              ),
              icon: Icon(SimpleLineIcons.getIconData('emotsmile')),
              onPressed: () {
                /* if (riddle != null) {
                  var url = riddle.imageUrl ?? riddle.videoUrl;
                  if (url != null) {
                    var f = await CustomCacheManager().getSingleFile('$url');
                    var mimeType = lookupMimeType(f.path.split('/').first);
                    ShareExtend.share(f.path, mimeType);
                  } else {
                    ShareExtend.share(riddle.text, 'text');
                  }
                } */
              },
            ),
            SizedBox(height: 10.0),
            RaisedButton.icon(
              label: Text(
                  AppLocalizations.of(context).tr('hints.showLastCharacter')),
              icon: Icon(SimpleLineIcons.getIconData('bulb')),
              onPressed: () {},
            ),
          ],
        ),
        buttons: [],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: InkWell(
        onTap: () => onTapAction(context),
        child: Opacity(
          opacity: item.isSource ? 1 : 0.3,
          child: Container(
            height: 50,
            width: item.letter == '?' ? 120 : 50,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: item.letter == '?'
                    ? Colors.yellow[700]
                    : Colors.transparent,
              ),
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 10.0,
              child: Center(
                child: Text(
                  item.letter,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: item.letter == '?'
                          ? Colors.yellow[700]
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
