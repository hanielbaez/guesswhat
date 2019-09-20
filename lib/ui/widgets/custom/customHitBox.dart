import 'package:Tekel/ui/widgets/riddle/letter.dart';
import 'package:flutter/material.dart';

//? I was trying to track the position of this widget
//? to assign a fit position to the target SideKick

class CustomHitBox extends StatefulWidget {
  final Function function;
  final List<Item> list;

  CustomHitBox({this.function, this.list});

  @override
  _CustomHitBoxState createState() => _CustomHitBoxState();
}

class _CustomHitBoxState extends State<CustomHitBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: widget.list.map((builderDelegate) {
          return Container(
            alignment: Alignment.center,
            width: 43.5,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// by: https://coflutter.com/flutter-dart/get-size-and-position-of-a-widget-in-flutter/
