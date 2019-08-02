import 'package:flutter/material.dart';

class UserBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Placeholder(
          fallbackHeight: 30.0,
          fallbackWidth: 30.0,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          'UserName ・ Two day ago',
          style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
