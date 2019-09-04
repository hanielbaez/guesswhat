//Flutter and Dart import
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';

//Self import
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/ui/pages/guessCreatePage.dart';

//Pick the image or video from different sources as gallery or camera
class SourceImageOption {
  final _flutterVideoCompress = FlutterVideoCompress();
  Map multimediaFile = {};

  Future<File> getImage(source, context) async {
    return await ImagePicker.pickImage(
        source: source, maxHeight: 1080, maxWidth: 1080);
  }

  Future<File> getVideo(source, context) async {
    return await ImagePicker.pickVideo(source: source);
  }

  Future<File> getThumbnailVideo(File file) async {
    final thumbnailFile =
        await _flutterVideoCompress.getThumbnailWithFile(file.path,
            quality: 10, // default(100)
            position: -1 // default(-1)
            );
    return thumbnailFile;
  }

  void navigateToCreate(
      {BuildContext context, Map multiMedia, User user}) {
    if (multiMedia['image'] != null) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GuessCreate(
            multiMedia: multiMedia,
            user: user,
            context: context,
          ),
        ),
      );
    }
  }
}
