//Flutter and Dart import
import 'package:audioplayers/audio_cache.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Self import
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:Tekel/core/custom/paginationRiddles.dart';

class CustomListRiddle extends StatelessWidget {
  final PaginationViewModel model;
  final swingPath = 'audios/swing.wav';
  final AudioCache player = AudioCache();

  CustomListRiddle({this.model});

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        EasyLocalizationProvider(
            data: data, child: CustomCategory(model: model)),
        Expanded(
          flex: 12,
          child: Swiper(
            key: Key(model.category),
            loop: false,
            onIndexChanged: (value) {
              if (value == model.riddlesList.length - 1) {
                model.getRiddles();
              }
              try {
                player.play(swingPath, volume: 1);
              } catch (e) {
                print('Swing sound error: $e');
              }
            },
            itemCount: model.riddlesList.length,
            control: controlButtons,
            curve: Curves.elasticOut,
            itemBuilder: (context, index) =>
                RiddleLayaout(riddle: model.riddlesList[index]),
          ),
        ),
      ],
    );
  }

  //? I need to first find a way to position it.
  final SwiperControl controlButtons = SwiperControl(
      iconNext: SimpleLineIcons.getIconData('arrow-right'),
      iconPrevious: SimpleLineIcons.getIconData('arrow-left'),
      color: Colors.black,
      disableColor: Colors.black12);
}

class CustomCategory extends StatelessWidget {
  final PaginationViewModel model;

  const CustomCategory({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List categoryList = [
      'sport',
      'culture',
      'animal',
      'math',
      'people',
      'movieAndTv',
      'scienceAndTechnology',
      'others'
    ];

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          var bordeColor = model.category == categoryList[index]
              ? Colors.yellow[700]
              : Colors.transparent;
          return InkWell(
            onTap: () => categoryList[index] != model.category
                ? model.selectCategory(selectedCategory: categoryList[index])
                : null,
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: bordeColor,
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                AppLocalizations.of(context)
                    .tr('category.' + categoryList[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
