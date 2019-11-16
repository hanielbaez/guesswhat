//Flutter and Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customTargetLetter.dart';
import 'package:Tekel/ui/widgets/riddle/letter.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:screenshot/screenshot.dart';

//? I should rename this class
class CustomSidekick extends StatelessWidget {
  final Riddle riddle;
  final ScreenshotController screenShot;
  CustomSidekick({this.riddle, this.screenShot});

  @override
  Widget build(BuildContext context) {
    return Consumer<LettersViewModel>(
      builder: (context, model, child) {
        Widget _sourceWidget = Container();

        if (model.sourceList.isNotEmpty && !model.correctAnswer) {
          _sourceWidget = Wrap(
            children: model.sourceList
                .map(
                  (item) => CustomLetter(
                      item: item,
                      model: model,
                      riddle: riddle,
                      screenShot: screenShot),
                )
                .toList(),
          );
        }

        return Column(
          children: [
            TargetLetter(
              model: model,
            ),
            _sourceWidget,
          ],
        );
      },
    );
  }
}
