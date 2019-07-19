import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guess_what/ui/pages/guessCreate.dart';
import 'package:image_picker/image_picker.dart';

//? This class is temporaly
class SourceImageOption {
  final String title;
  final IconData icon;
  final ImageSource source;

  SourceImageOption({
    this.title,
    this.icon,
    this.source,
  });

  Future<File> getImage() async {
    return await ImagePicker.pickImage(
        source: this.source, maxHeight: 1080, maxWidth: 1080);
  }
}

List<SourceImageOption> pickerList = [
  SourceImageOption(
    title: 'Gallery',
    icon: Icons.photo_library,
    source: ImageSource.gallery,
  ),
  SourceImageOption(
      title: 'Camara', icon: Icons.photo_camera, source: ImageSource.camera),
  //SourceImageOption(title: 'Take a video', icon: Icons.videocam, source: ImageSource.),
];

//TODO: Add image Picker
//Nota: I dont need to make a StateFull, just reditet to where the data is gonna be loaded

class CostumPopupMenu extends StatelessWidget {
  const CostumPopupMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File _imageFile;

    return PopupMenuButton(
      icon: Icon(
        Icons.add,
        color: Colors.black45,
      ),
      itemBuilder: (BuildContext context) {
        return pickerList.map((SourceImageOption imagePicker) {
          return PopupMenuItem(
            child: ListTile(
                leading: Icon(imagePicker.icon),
                title: Text(imagePicker.title),
                onTap: () async {
                  _imageFile = await imagePicker.getImage();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => GuessCreate(
                        imageFile: _imageFile,
                      ),
                    ),
                  );
                }),
          );
        }).toList();
      },
    );
  }
}
