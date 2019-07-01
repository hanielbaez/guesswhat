import 'package:flutter/material.dart';

class CustomLetter extends StatelessWidget {
  final String letter;
  CustomLetter(this.letter);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        letter,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
