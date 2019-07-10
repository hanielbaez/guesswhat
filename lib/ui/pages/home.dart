import 'package:flutter/material.dart';
import 'package:guess_what/ui/widgets/guess.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black45,
          onPressed: () {},
        ),
        title: Text(
          'GuessWhat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Center(child: GuessLayaout()),
    );
  }
}
