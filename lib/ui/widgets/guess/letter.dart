import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';

class Item {
  Item({
    this.id,
    this.letter,
  });
  final int id;
  final String letter;
}

class CustomLetter extends StatelessWidget {
  final Item item;
  final bool isSource;
  final LettersViewModel model;

  CustomLetter({this.item, this.isSource, this.model});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //If correct aswear TRUE do nothing
        if (model.correctAnswear == false) {
          SidekickTeamBuilder.of<Item>(context).move(item);
        }

        //Delete or add letter base on isSource
        isSource
            ? model.setLetter(selectedItem: item)
            : model.deleteLetter(selectedItem: item);
      },
      child: Opacity(
        opacity: isSource ? 0.5 : 1,
        child: Container(
          width: 35,
          height: 40,
          margin: EdgeInsets.all(isSource ? 7 : 2),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.transparent,
            border: Border.all(
              color: model.letterColor(isSource),
            ),
          ),
          child: Center(
            child: Text(
              item.letter,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: model.letterColor(isSource),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
