//Flutter and dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:image_picker/image_picker.dart';

//Self import
import 'package:Tekel/core/viewModel/SourceMediaViewModel.dart';

/* Handle the user actions, when trying to add new content,
if the user is not singIn him will be redirected to the singIng buttons */

void onButtonPressed({context, user}) {
  SourceImageOption _sourceOption = SourceImageOption();
  showModalBottomSheet(
    context: context,
    builder: (context) {
      Map _multiMedia = {};

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Create a Riddle',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Write it'),
            leading: Icon(
              SimpleLineIcons.getIconData('note'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'createTextRiddle');
            },
          ),
          ListTile(
            title: Text('Capture Image'),
            leading: Icon(
              SimpleLineIcons.getIconData('camera'),
            ),
            onTap: () async {
              try {
                _multiMedia['image'] =
                    await _sourceOption.getImage(ImageSource.camera, context);

                _sourceOption.navigateToCreate(
                    context: context, multiMedia: _multiMedia, user: user);
              } catch (error) {
                print('Error: $error');
              }
            },
          ),
          /* ListTile(
                title: Text('Capture Video'),
                leading: Icon(SimpleLineIcons.getIconData('camrecorder')),
                onTap: () async {
                  try {
                    _multiMedia['video'] =
                        await _sourceOption.getVideo(ImageSource.camera, context);
                    _multiMedia['videoThumbnail'] =
                        await _sourceOption.getThumbnailVideo(_multiMedia['video']);
                    _sourceOption.navigateToCreate(
                        context: context, multiMedia: _multiMedia);
                  } catch (error) {
                    print('Error: ' + error.toString());
                  }
                },
              ), */
          ListTile(
            title: Text('Image from Gallery'),
            leading: Icon(
              SimpleLineIcons.getIconData('picture'),
            ),
            onTap: () async {
              try {
                _multiMedia['image'] =
                    await _sourceOption.getImage(ImageSource.gallery, context);

                _sourceOption.navigateToCreate(
                    context: context, multiMedia: _multiMedia, user: user);
              } catch (error) {
                print('Error: ' + error.toString());
              }
            },
          ),
          /* ListTile(
                title: Text('Video from Gallery'),
                leading: Icon(SimpleLineIcons.getIconData('film')),
                onTap: () async {
                  try {
                    _multiMedia['video'] =
                        await _sourceOption.getVideo(ImageSource.gallery, context);
                    _multiMedia['videoThumbnail'] =
                        await _sourceOption.getThumbnailVideo(_multiMedia['video']);
                    _sourceOption.navigateToCreate(
                        context: context, multiMedia: _multiMedia);
                  } catch (error) {
                    print('Error: ' + error.toString());
                  }
                },
              ), */
        ],
      );
    },
  );
}
