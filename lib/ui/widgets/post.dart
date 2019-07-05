import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';

import 'package:guess_what/ui/widgets/charada.dart';
import 'package:guess_what/ui/widgets/description.dart';
import 'package:guess_what/ui/widgets/letter.dart';

class Post extends StatelessWidget {
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
        return Align(
          alignment: Alignment.topCenter,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            children: <Widget>[
              AspectRatio(
                aspectRatio: 4 / 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CharadaLayaout(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TargetDelegate(
                          target: targetBuilderDelegates,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SourceDelegate(
                source: sourceBuilderDelegates,
              ),
              Divider(
                color: Colors.black45,
              ),
              CostumDescription(text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
            ],
          ),
        );
      },
    );
  }
}

class SourceDelegate extends StatelessWidget {
  final List<SidekickBuilderDelegate<Item>> source;

  const SourceDelegate({
    Key key,
    this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: Wrap(
        children: source
            .map((builderDelegate) => builderDelegate.build(
                  context,
                  CustomLetter(builderDelegate.message, true),
                  animationBuilder: (animation) => CurvedAnimation(
                        parent: animation,
                        curve: Curves.ease,
                      ),
                ))
            .toList(),
      ),
    );
  }
}

class TargetDelegate extends StatelessWidget {
  final List<SidekickBuilderDelegate<Item>> target;
  const TargetDelegate({Key key, this.target}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: Wrap(
        children: target
            .map((builderDelegate) => builderDelegate.build(
                  context,
                  CustomLetter(builderDelegate.message, false),
                  animationBuilder: (animation) => CurvedAnimation(
                        parent: animation,
                        curve: FlippedCurve(Curves.ease),
                      ),
                ))
            .toList(),
      ),
    );
  }
}
