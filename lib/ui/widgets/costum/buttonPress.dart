import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:guess_what/core/viewModel/SourceMediaViewModel.dart';
import 'package:image_picker/image_picker.dart';

//TODO: Rename this

void onButtonPressed(context) {
  SourceImageOption _sourceOption = SourceImageOption();
  showModalBottomSheet(
    context: context,
    builder: (context) {
      Map _multiMedia = {};

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Capture Image'),
            leading: Icon(SimpleLineIcons.getIconData('camera')),
            onTap: () async {
              try {
                _multiMedia['image'] =
                    await _sourceOption.getImage(ImageSource.camera, context);

                _multiMedia['imageThumbnail'] =
                    await _sourceOption.getthumbnailImage(
                        _multiMedia['image'], _multiMedia['image']?.path);

                _sourceOption.navigateToCreate(
                    context: context, multiMedia: _multiMedia);
              } catch (error) {
                print('Error: $error');
              }
            },
          ),
          ListTile(
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
          ),
          ListTile(
            title: Text('Image from Gallery'),
            leading: Icon(SimpleLineIcons.getIconData('picture')),
            onTap: () async {
              try {
                _multiMedia['image'] =
                    await _sourceOption.getImage(ImageSource.gallery, context);
                _multiMedia['imageThumbnail'] =
                    await _sourceOption.getthumbnailImage(
                        _multiMedia['image'], _multiMedia['image'].path);
                _sourceOption.navigateToCreate(
                    context: context, multiMedia: _multiMedia);
              } catch (error) {
                print('Error: ' + error.toString());
              }
            },
          ),
          ListTile(
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
          ),
        ],
      );
    },
  );
}
