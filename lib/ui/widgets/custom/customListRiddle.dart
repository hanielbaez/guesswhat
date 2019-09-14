//Flutter and Dart import
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Self import
import 'package:Tekel/core/viewModel/paginationViewModel.dart';
import 'package:provider/provider.dart';

class CustomListRiddle extends StatefulWidget {
  final PaginationViewModel model;

  CustomListRiddle({Key key, this.model}) : super(key: key);

  @override
  _CustomListRiddleState createState() => _CustomListRiddleState();
}

class _CustomListRiddleState extends State<CustomListRiddle> {
  PaginationViewModel model;
  ConfettiController controllerTopCenter;

  @override
  void initState() {
    controllerTopCenter = ConfettiController(duration: Duration(seconds: 5));
    super.initState();
  }

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
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: widget.model.getRiddles(),
            builder: (contex, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Please wait...'),
                        SpinKitThreeBounce(
                          color: Colors.black,
                          size: 50.0,
                        ),
                      ],
                    ),
                  );
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    print('Index ${widget.model.index}');
                    return Swiper(
                      onIndexChanged: (index) {
                        if (index == snapshot.data.length - 1) {
                          setState(() {});
                        }
                      },
                      index: widget.model.index,
                      itemCount: snapshot.data.length,
                      viewportFraction: 0.85,
                      scale: 0.9,
                      /* layout: SwiperLayout
                          .STACK, //!The index just work with the DEFAULT
                      itemWidth: MediaQuery.of(context).size.width / 1.1,
                      itemHeight: MediaQuery.of(context).size.height / 1.2, */
                      itemBuilder: (context, index) =>
                          ListenableProvider<ConfettiController>.value(
                        value: controllerTopCenter,
                        child: RiddleLayaout(riddle: snapshot.data[index]),
                      ),
                    );
                  }

                  break;
              }
              return Container();
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 10,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 5,
            ),
          ),
        ],
      ),
    );
  }
}
