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
        textAlign: TextAlign.justify,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      expanded: Text(
        text,
        softWrap: true,
      ),
      tapHeaderToExpand: true,
      tapBodyToCollapse: true,
      hasIcon: false,
    );
  }
}
