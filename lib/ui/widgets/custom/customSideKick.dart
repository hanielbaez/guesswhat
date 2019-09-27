//Flutter and Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customTargetLetter.dart';
import 'package:Tekel/ui/widgets/riddle/letter.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';

//? I should rename this class
class CustomSidekick extends StatefulWidget {
  @override
  _CustomSidekickState createState() => _CustomSidekickState();
}

class _CustomSidekickState extends State<CustomSidekick>
    with SingleTickerProviderStateMixin {
  AnimationController _fadeSourceController;
  Animation<double> _fadeSourceAnimation;

  @override
  void initState() {
    _fadeSourceController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeSourceAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_fadeSourceController);
    super.initState();
  }

  @override
  void dispose() {
    _fadeSourceController.dispose();
    super.dispose();
  }

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
          _fadeSourceController.forward();
        }

        return Column(
          children: [
            TargetLetter(
              model: model,
            ),
            SizedBox(
              height: 5.0,
            ),
            model.correctAnswer
                ? Container()
                : FadeTransition(
                    opacity: _fadeSourceAnimation,
                    child: _sourceWidget,
                  )
          ],
        );
      },
    );
  }
}
