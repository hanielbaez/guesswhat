//Flutter and Dart import
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
  final Function setLetter;

  CustomLetter({this.item, this.setLetter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //If correct aswear TRUE do nothing
        if (item.isSource) {
          item.isSource = !item.isSource;
          setLetter(selectedItem: item);
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
