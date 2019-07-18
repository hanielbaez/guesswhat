import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          color: Colors.transparent,
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
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
              SizedBox(
                height: 35.0,
              ),
              SizedBox(
                height: 110.0,
                child: Wrap(
                  children: sourceBuilderDelegates.isEmpty
                      ? [
                          Center(
                            child: SpinKitFadingCube(
                              color: Colors.black12,
                              size: 50.0,
                            ),
                          )
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
            ],
          ),
        );
      },
    );
  }
}
