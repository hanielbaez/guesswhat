import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class CostumDescription extends StatelessWidget {
  final String text;
  CostumDescription({this.text});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      collapsed: Text(
        text,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.justify,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      expanded: Text(
        text,
        style: TextStyle(color: Colors.white),
        softWrap: true,
      ),
      tapHeaderToExpand: true,
      tapBodyToCollapse: true,
      hasIcon: false,
    );
  }
}
