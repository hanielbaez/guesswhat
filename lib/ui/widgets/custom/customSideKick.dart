//Flutter and Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customHitBox.dart';
import 'package:Tekel/ui/widgets/riddle/letter.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';

class CustomSidekick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LettersViewModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            CustomHitBox(
              model: model,
            ),
            SizedBox(
              height: 5.0,
            ),
            model.correctAnswer
                ? Container()
                : Wrap(
                    children: model.sourceList
                        .map(
                          (item) => CustomLetter(
                            item: item,
                            model: model,
                          ),
                        )
                        .toList()),
          ],
        );
      },
    );
  }
}
