//Flutter import
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/model/ridlle.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/widgets/custom/customSideKick.dart';
import 'package:guess_what/ui/widgets/custom/userBar.dart';
import 'package:guess_what/ui/widgets/ridlle/actionsBar.dart';
import 'package:guess_what/ui/widgets/ridlle/description.dart';
import 'package:guess_what/ui/widgets/ridlle/video.dart';

class RidlleLayaout extends StatefulWidget {
  final Ridlle ridlle;

  RidlleLayaout({this.ridlle});

  @override
  _RidlleLayaoutState createState() => _RidlleLayaoutState();
}

class _RidlleLayaoutState extends State<RidlleLayaout> {
  final changeNotifier = new StreamController.broadcast();

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: UserBar(
              userData: widget.ridlle.user,
              timeStamp: widget.ridlle.creationDate,
              address: widget.ridlle.address,
            ),
          ),
          Hero(
            tag: widget.ridlle.id,
            child: ChangeNotifierProvider<VideoViewModel>.value(
              value: VideoViewModel(ridlle: widget.ridlle),
              child: Consumer<VideoViewModel>(
                builder: (context, model, child) {
                  return SizedBox.fromSize(
                    child: VideoLayaout(
                        ridlle: widget.ridlle,
                        model: model,
                        shouldTriggerChange: changeNotifier.stream),
                  );
                },
              ),
            ),
          ),
          if (widget.ridlle.answer.isNotEmpty)
            StreamBuilder<FirebaseUser>(
              stream: Provider.of<AuthenticationServices>(context).user(),
              builder: (context, userSnap) {
                if (userSnap.hasData) {
                  return ChangeNotifierProvider<LettersViewModel>.value(
                    value: LettersViewModel(
                        ridlle: widget.ridlle,
                        db: Provider.of(context),
                        user: userSnap.data,
                        changeNotifier: changeNotifier),
                    child: Consumer<LettersViewModel>(
                      builder: (context, model, child) {
                        return CustomSidekick(
                          ridlle: widget.ridlle,
                          model: model,
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          if (widget.ridlle.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomDescription(text: '${widget.ridlle.description}'),
              ),
            ),
          ActionBar(ridlle: widget.ridlle),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
