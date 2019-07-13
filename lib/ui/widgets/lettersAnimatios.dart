import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/ui/widgets/letter.dart';
import 'package:provider/provider.dart';

class LettersAnimations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LettersViewModel>.value(
      value: LettersViewModel(),
      child: Consumer<LettersViewModel>(
        builder: (context, model, child) {
          model.generateList(context);
          return SidekickTeamBuilder<Item>(
            animationDuration: Duration(milliseconds: 500),
            initialSourceList: model.sourceList,

            /* <Item>[
              Item(id: 1, letter: "H"),
              Item(id: 2, letter: "A"),
              Item(id: 3, letter: "N"),
              Item(id: 4, letter: "I"),
              Item(id: 5, letter: "E"),
              Item(id: 6, letter: "L"),
              Item(id: 1, letter: "H"),
              Item(id: 2, letter: "A"),
              Item(id: 3, letter: "N"),
              Item(id: 4, letter: "I"),
              Item(id: 5, letter: "E"),
              Item(id: 6, letter: "L"),
              Item(id: 5, letter: "E"),
              Item(id: 6, letter: "L"),
            ], */
            builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
              return Container(
                height: MediaQuery.of(context).size.height / 2.65,
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
                                      model: model),
                                  animationBuilder: (animation) =>
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: FlippedCurve(Curves.ease),
                                      )),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    SizedBox(
                      height: 125.0,
                      child: Wrap(
                        children: sourceBuilderDelegates
                            .map(
                              (builderDelegate) => builderDelegate.build(
                                    context,
                                    CustomLetter(
                                        item: builderDelegate.message,
                                        isSource: true,
                                        model: model),
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
        },
      ),
    );
  }
}
