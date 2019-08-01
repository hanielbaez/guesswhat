import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/SourceMediaViewModel.dart';
import 'package:image_picker/image_picker.dart';

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
            leading: Icon(Icons.photo_camera),
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
            leading: Icon(Icons.videocam),
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
            leading: Icon(Icons.photo_album),
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
            leading: Icon(Icons.video_library),
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
