import 'package:Tekel/ui/widgets/riddle/letter.dart';
import 'package:flutter/material.dart';

//? I was trying to track the position of this widget
//? to assign a fit position to the target SideKick

class CustomHitBox extends StatelessWidget {
  final Function deleteLetter;
  final List<Item> hitList;
  final List<Item> selectedItems;

  CustomHitBox({this.deleteLetter, this.hitList, this.selectedItems});
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: hitList.map((item) {
          bool _isSelected = selectedItems.length - 1 >= item.id ? true : false;

          return GestureDetector(
            onTap: () {
              if (selectedItems.isNotEmpty && _isSelected) {
                print('${selectedItems[item.id].id}');
                deleteLetter(
                    sourceItemId: selectedItems[item.id].id,
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
                    color: _isSelected ? Colors.black : Colors.white),
              ),
              child:
                  Text(_isSelected ? '${selectedItems[item.id].letter}' : ''),
            ),
          );
        }).toList(),
      ),
    );
  }
}
