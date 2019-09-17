//Flutter and Dart
import 'package:Tekel/ui/widgets/custom/customHitBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';

//Self import
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:Tekel/ui/widgets/riddle/letter.dart';

class CustomSidekick extends StatefulWidget {
  final Riddle riddle;
  final LettersViewModel model;
  CustomSidekick({this.riddle, this.model});

  @override
  _CustomSidekickState createState() => _CustomSidekickState();
}

class _CustomSidekickState extends State<CustomSidekick> {
  LettersViewModel _model;

  @override
  void initState() {
    _model = widget.model;
    _model.getTargetList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SidekickTeamBuilder<Item>(
      animationDuration: Duration(milliseconds: 600),
      initialTargetList: _model.targetList,
      initialSourceList: _model.sourceList,
      builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomHitBox(list: _model.targetHitList),
                  Wrap(
                    children: targetBuilderDelegates
                        .map(
                          (builderDelegate) => builderDelegate.build(
                            context,
                            CustomLetter(
                                item: builderDelegate.message,
                                isSource: false,
                                model: _model),
                            animationBuilder: (animation) => CurvedAnimation(
                              parent: animation,
                              curve: FlippedCurve(Curves.ease),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              //Small space between
              SizedBox(
                height: 20.0,
              ),

              AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                child: _model.correctAnswer
                    ? Container()
                    : Wrap(
                        children: sourceBuilderDelegates.isEmpty
                            ? [
                                Container(),
                              ]
                            : sourceBuilderDelegates
                                .map(
                                  (builderDelegate) => builderDelegate.build(
                                    context,
                                    CustomLetter(
                                        item: builderDelegate.message,
                                        isSource: true,
                                        model: _model),
                                    animationBuilder: (animation) {
                                      return CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.ease,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
