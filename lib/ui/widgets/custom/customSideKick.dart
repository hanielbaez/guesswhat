//Flutter and Dart
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/ui/widgets/guess/letter.dart';

class CustomSidekick extends StatefulWidget {
  final Guess guess;
  final LettersViewModel model;
  CustomSidekick({this.guess, this.model});

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
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                    ),
                                  ),
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
