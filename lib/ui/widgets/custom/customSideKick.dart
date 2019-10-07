//Flutter and Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customTargetLetter.dart';
import 'package:Tekel/ui/widgets/riddle/letter.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';

//? I should rename this class
class CustomSidekick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LettersViewModel>(
      builder: (context, model, child) {
        Widget _sourceWidget = Container();

        if (model.sourceList.isNotEmpty) {
          _sourceWidget = Wrap(
            children: model.sourceList
                .map(
                  (item) => CustomLetter(
                    item: item,
                    model: model,
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: [
            TargetLetter(
              model: model,
            ),
            SizedBox(
              height: 5.0,
            ),
            _sourceWidget,
          ],
        );
      },
    );
  }
}
