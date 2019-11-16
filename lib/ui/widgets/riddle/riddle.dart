//Flutter import
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

//Self import
import 'package:Tekel/core/services/auth.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/ui/widgets/custom/userBar.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:Tekel/core/viewModel/videoViewModel.dart';
import 'package:Tekel/ui/widgets/custom/customSideKick.dart';
import 'package:Tekel/ui/widgets/riddle/actionsBar.dart';
import 'package:Tekel/ui/widgets/riddle/description.dart';
import 'package:Tekel/ui/widgets/riddle/video.dart';

class RiddleLayaout extends StatefulWidget {
  final Riddle riddle;
  RiddleLayaout({this.riddle});

  @override
  _RiddleLayaoutState createState() => _RiddleLayaoutState();
}

class _RiddleLayaoutState extends State<RiddleLayaout> {
  final changeNotifier = StreamController.broadcast();
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return Stack(
      children: <Widget>[
        Screenshot(
          controller: screenshotController,
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: ListView(
              children: <Widget>[
                UserBar(
                  user: User.fromMap(widget.riddle.user),
                  timeStamp: widget.riddle.createdAt,
                  address: widget.riddle.address,
                  riddle: widget.riddle,
                ),
                ChangeNotifierProvider<VideoViewModel>.value(
                  value: VideoViewModel(riddle: widget.riddle),
                  child: Consumer<VideoViewModel>(
                    builder: (context, model, child) {
                      return VideoLayaout(
                        riddle: widget.riddle,
                        model: model,
                        shouldTriggerChange: changeNotifier.stream,
                        confettiController:
                            Provider.of<ConfettiController>(context),
                      );
                    },
                  ),
                ),
                if (widget.riddle.answer.isNotEmpty)
                  ChangeNotifierProvider<LettersViewModel>.value(
                    value: LettersViewModel(
                        riddle: widget.riddle,
                        db: Provider.of(context),
                        user: Provider.of<AuthenticationServices>(context)
                            .profile,
                        changeNotifier: changeNotifier),
                    child: CustomSidekick(
                        riddle: widget.riddle,
                        screenShot: screenshotController),
                  ),
                SizedBox(
                  height: 5.0,
                ),
                ActionBar(riddle: widget.riddle),
                if (widget.riddle.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomDescription(
                          text: '${widget.riddle.description}'),
                    ),
                  ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
        //Network connection status
        EasyLocalizationProvider(
          data: data,
          child: ConnectionStatusBar(
            title: Text(
              AppLocalizations.of(context).tr('connectionStatusBar.title'),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
