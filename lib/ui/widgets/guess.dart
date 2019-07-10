import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';

import 'package:guess_what/ui/widgets/video.dart';
import 'package:guess_what/ui/widgets/description.dart';
import 'package:guess_what/ui/widgets/letter.dart';

class GuessLayaout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        AspectRatio(
          aspectRatio: 4 / 6.5,
          child: Stack(
            children: <Widget>[
              FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: 0.7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: VideoLayaout(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SecretLayout(),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black45,
        ),
        CostumDescription(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      ],
    );
  }
}

class SecretLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SidekickTeamBuilder<Item>(
      animationDuration: Duration(milliseconds: 500),
      initialSourceList: <Item>[
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
      ],
      builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
        return Container(
          //color: Colors.green,
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
                              CustomLetter(builderDelegate.message, false),
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
                height: 60.0,
              ),
              SizedBox(
                height: 125.0,
                child: Wrap(
                  children: sourceBuilderDelegates
                      .map(
                        (builderDelegate) => builderDelegate.build(
                              context,
                              CustomLetter(builderDelegate.message, true),
                              animationBuilder: (animation) => CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.ease,
                                  ),
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
