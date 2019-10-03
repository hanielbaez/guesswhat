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
    with TickerProviderStateMixin {
  AnimationController _shakeController;
  AnimationController _fadeTargetController;
  Animation<double> _shakeAnimation;
  Animation<double> _fadeTargetAnimation;

  @override
  void initState() {
    _shakeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeTargetController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeTargetAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_fadeTargetController);
    super.initState();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeTargetController.dispose();
    super.dispose();
  }

  v.Vector3 _shake() {
    double progress = _shakeController.value;
    double offset = sin(progress * pi * 10.0);
    return v.Vector3(offset * 4, 0.0, 0.0);
  }

  Widget build(BuildContext context) {
    if (widget.model.targetHitList.isNotEmpty) {
      _fadeTargetController.forward();
    }

    if (widget.model.wrongAnswer) {
      if (!_shakeController.isAnimating) {
        _shakeController.forward();
      }
    }
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reset();
        }
      });

    return FadeTransition(
      opacity: _fadeTargetAnimation,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) => Transform(
          transform: Matrix4.translation(_shake()),
          child: Wrap(
            children: widget.model.targetHitList.map((item) {
              bool _isSelected =
                  widget.model.selectedItems.length - 1 >= item.id
                      ? true
                      : false;

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
                  margin: EdgeInsets.only(top: 4.0, left: 2.0, bottom: 4.0),
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
      ),
    );
  }
}
