import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//Coustom import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/ui/widgets/guess/letter.dart';

class CostumSidekick extends StatefulWidget {
  final Guess guess;
  final LettersViewModel model;
  CostumSidekick({this.guess, this.model});

  @override
  _CostumSidekickState createState() => _CostumSidekickState();
}

class _CostumSidekickState extends State<CostumSidekick> {
  LettersViewModel _model;

  @override
  void initState() {
    _model = widget.model;
    _model.generateItemList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SidekickTeamBuilder<Item>(
      animationDuration: Duration(milliseconds: 600),
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
                  //height: 110.0,
                  child: AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: _model.correctAnswear
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
              )),
            ],
          ),
        );
      },
    );
  }
}
