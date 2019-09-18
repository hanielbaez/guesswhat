//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Self import
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:Tekel/core/custom/paginationRiddles.dart';

class CustomListRiddle extends StatelessWidget {
  final PaginationViewModel pagination = PaginationViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.black38],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: FutureBuilder(
        future: pagination.getRiddles(),
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
                  //onIndexChanged: (index) {},
                  loop: false,
                  
                  index: pagination.index,
                  itemCount: snapshot.data.length,
                  control: controlButtons,
                  itemBuilder: (context, index) =>
                      RiddleLayaout(riddle: snapshot.data[index]),
                );
              }
              break;
          }
          return Container();
        },
      ),
    );
  }

  final SwiperControl controlButtons = SwiperControl(
      iconNext: SimpleLineIcons.getIconData('arrow-right'),
      iconPrevious: SimpleLineIcons.getIconData('arrow-left'),
      size: 40.0,
      padding: EdgeInsets.only(bottom: 300),
      color: Colors.yellowAccent[700],
      disableColor: Colors.black12);
}
