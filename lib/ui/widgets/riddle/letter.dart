//Flutter and Dart import
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:flutter/material.dart';

class Item {
  Item({
    this.id,
    this.letter,
    this.isSource,
  });
  final int id;
  final String letter;
  bool isSource;
}

class CustomLetter extends StatelessWidget {
  final Item item;
  final LettersViewModel model;

  CustomLetter({this.item, this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //If correct aswear TRUE do nothing
        if (item.isSource && !model.correctAnswer) {
          if (!model.wrongAnswer) item.isSource = !item.isSource;
          model.setLetter(item: item);
        }
      },
      child: Opacity(
        opacity: item.isSource ? 1 : 0.3,
        child: Container(
          height: 45,
          width: 50,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 10.0,
            child: Center(
              child: Text(
                item.letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
