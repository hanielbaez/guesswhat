//Flutter and dart import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/viewModel/SourceMediaViewModel.dart';

/* Handle the user actions, when trying to add new content,
if the user is not singIn him will be redirected to the singIng buttons */

void onButtonPressed(context) {
  SourceImageOption _sourceOption = SourceImageOption();
  showModalBottomSheet(
    context: context,
    builder: (context) {
      Map _multiMedia = {};

      return StreamBuilder<FirebaseUser>(
        stream: Provider.of<AuthenticationServices>(context).user(),
        builder: (context, userSnap) {
          if (userSnap.data == null) {
            return Column(
              children: <Widget>[
                Text(
                  'Deseas registarte',
                  style: TextStyle(color: Colors.black),
                ),
                //TODO: SingIn opciones
              ],
            );
          }
          if (userSnap.hasError) {
            print('${userSnap.error}');
          }
          if (userSnap.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Create a Ridlle',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Capture Image'),
                    leading: Icon(
                      SimpleLineIcons.getIconData('camera'),
                    ),
                    onTap: () async {
                      try {
                        _multiMedia['image'] = await _sourceOption.getImage(
                            ImageSource.camera, context);

                        _sourceOption.navigateToCreate(
                            context: context,
                            multiMedia: _multiMedia,
                            user: userSnap.data);
                      } catch (error) {
                        print('Error: $error');
                      }
                    },
                  ),
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
                Card(
                  child: ListTile(
                    title: Text('Image from Gallery'),
                    leading: Icon(
                      SimpleLineIcons.getIconData('picture'),
                    ),
                    onTap: () async {
                      try {
                        _multiMedia['image'] = await _sourceOption.getImage(
                            ImageSource.gallery, context);

                        _sourceOption.navigateToCreate(
                            context: context,
                            multiMedia: _multiMedia,
                            user: userSnap.data);
                      } catch (error) {
                        print('Error: ' + error.toString());
                      }
                    },
                  ),
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
          }

          return Container(); //Unattainable
        },
      );
    },
  );
}
