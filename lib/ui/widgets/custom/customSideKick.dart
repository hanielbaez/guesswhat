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
              hitList: model.targetHitList,
              selectedItems: model.selectedItems,
              deleteLetter: model.deleteLetter,
            ),
            SizedBox(
              height: 5.0,
            ),
            Wrap(
                children: model.sourceList
                    .map(
                      (item) => CustomLetter(
                        item: item,
                        setLetter: model.setLetter,
                      ),
                    )
                    .toList()),
          ],
        );
      },
    );
  }
}
