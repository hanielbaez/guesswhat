//Flutter and Dart import
import 'package:flutter/material.dart';

//Selt import
import 'package:Tekel/core/viewModel/letterViewModel.dart';

class CustomHitBox extends StatelessWidget {
  final LettersViewModel model;

  CustomHitBox({this.model});
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: model.targetHitList.map((item) {
          bool _isSelected =
              model.selectedItems.length - 1 >= item.id ? true : false;

          return GestureDetector(
            onTap: () {
              if (model.selectedItems.isNotEmpty && _isSelected) {
                model.deleteLetter(
                    sourceItemId: model.selectedItems[item.id].id,
                    targetItemId: item.id);
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: 43.5,
              height: 40,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    _isSelected ? Colors.white : Colors.black.withOpacity(0.15),
                border: Border.all(
                    color: _isSelected ? model.letterColor() : Colors.white),
              ),
              child: Text(
                _isSelected ? '${model.selectedItems[item.id].letter}' : '',
                style: TextStyle(
                    color: model.letterColor(), fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
