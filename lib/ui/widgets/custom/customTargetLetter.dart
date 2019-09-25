//Flutter and Dart import
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as v;

//Selt import
import 'package:Tekel/core/viewModel/letterViewModel.dart';

class TargetLetter extends StatefulWidget {
  final LettersViewModel model;

  TargetLetter({this.model});

  @override
  _TargetLetterState createState() => _TargetLetterState();
}

class _TargetLetterState extends State<TargetLetter>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  v.Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return v.Vector3(offset * 4, 0.0, 0.0);
  }

  Widget build(BuildContext context) {
    if (widget.model.wrongAnswer) {
      if (!animationController.isAnimating) {
        animationController.forward();
      }
    }
    animation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      });

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform(
        transform: Matrix4.translation(_shake()),
        child: Wrap(
          children: widget.model.targetHitList.map((item) {
            bool _isSelected =
                widget.model.selectedItems.length - 1 >= item.id ? true : false;

            return GestureDetector(
              onTap: () {
                if (widget.model.selectedItems.isNotEmpty &&
                    _isSelected &&
                    !widget.model.correctAnswer) {
                  widget.model.deleteLetter(
                      sourceItemId: widget.model.selectedItems[item.id].id,
                      targetItemId: item.id);
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: 43.5,
                height: 40,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _isSelected
                      ? Colors.white
                      : Colors.black.withOpacity(0.15),
                  border: Border.all(
                      color: _isSelected
                          ? widget.model.letterColor()
                          : Colors.white),
                ),
                child: Text(
                  _isSelected
                      ? '${widget.model.selectedItems[item.id].letter}'
                      : '',
                  style: TextStyle(
                      color: widget.model.letterColor(),
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
