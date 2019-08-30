//Flutter and Dart
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';

//Self import
import 'package:Tekel/core/model/ridlle.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:Tekel/ui/widgets/ridlle/letter.dart';

class CustomSidekick extends StatefulWidget {
  final Ridlle ridlle;
  final LettersViewModel model;
  CustomSidekick({this.ridlle, this.model});

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
      animationDuration: Duration(milliseconds: 500),
      initialTargetList: _model.targetList,
      initialSourceList: widget.model.sourceList,
      builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
        return Container(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Wrap(
                      children: targetBuilderDelegates
                          .map(
                            (builderDelegate) => builderDelegate.build(
                              context,
                              CustomLetter(
                                  item: builderDelegate.message,
                                  isSource: false,
                                  model: widget.model),
                              animationBuilder: (animation) => CurvedAnimation(
                                parent: animation,
                                curve: FlippedCurve(Curves.ease),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              Container(
                child: AnimatedSwitcher(
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
                                          model: widget.model),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
