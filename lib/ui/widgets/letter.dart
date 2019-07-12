import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';

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
  CustomLetter(this.item, this.isSource);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SidekickTeamBuilder.of<Item>(context).move(item),
      child: Opacity(
        opacity: isSource ? 0.5 : 1,
              child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Text(
            item.letter,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
