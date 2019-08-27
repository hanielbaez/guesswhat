import 'package:flutter/material.dart';

class BuildAvatarIcon extends StatelessWidget {
  const BuildAvatarIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.yellow,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'User Name',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
