//Flutter and Dart import
import 'package:Tekel/core/services/location.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Self import
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:Tekel/core/custom/paginationRiddles.dart';
import 'package:provider/provider.dart';

class CustomListRiddle extends StatelessWidget {
  final PaginationViewModel pagination = PaginationViewModel();
  static String countryCode;
  final swingPath = 'audios/swing.wav';
  final AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationServices>(context).getGeoPoint().then((user) {
      countryCode = user['location']['countryCode'];
    });
    return FutureBuilder(
      future: pagination.getRiddles(countryCode: countryCode),
      builder: (contex, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.black,
                size: 50.0,
              ),
            );
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              return Swiper(
                loop: false,
                onIndexChanged: (value) {
                  PaginationViewModel.index = value;
                  player.play(swingPath, volume: 0.5);
                },
                index: PaginationViewModel.index,
                itemCount: snapshot.data.length,
                control: controlButtons,
                curve: Curves.elasticOut,
                itemBuilder: (context, index) =>
                    RiddleLayaout(riddle: snapshot.data[index]),
              );
            }
            break;
        }
        return Container();
      },
    );
  }

  //? I need to first find a way to position it.
  final SwiperControl controlButtons = SwiperControl(
      iconNext: SimpleLineIcons.getIconData('arrow-right'),
      iconPrevious: SimpleLineIcons.getIconData('arrow-left'),
      color: Colors.black,
      disableColor: Colors.black12);
}
