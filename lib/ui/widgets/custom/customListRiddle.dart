//Flutter and Dart import
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Self import
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:Tekel/core/custom/paginationRiddles.dart';

class CustomListRiddle extends StatelessWidget {
  //static String countryCode;
  final PaginationViewModel model;
  final swingPath = 'audios/swing.wav';
  final AudioCache player = AudioCache();

  CustomListRiddle({this.model});

  @override
  Widget build(BuildContext context) {
    /* Provider.of<LocationServices>(context).getGeoPoint().then((user) {
      countryCode = user['location']['countryCode'];
    }); */
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomCategory(),
        Expanded(
          flex: 12,
          child: Swiper(
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

List categoryList = [
  '⚽Sport',
  '🗺Culture',
  '🐥Animals',
  '🔢Maths',
  '💁‍People',
  '🎬Movie and TV',
  '🔭Science and Technology',
  '📁Others'
];

class CustomCategory extends StatelessWidget {
  const CustomCategory({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Text(categoryList[index]),
          );
        },
      ),
    );
  }
}
