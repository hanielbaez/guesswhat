//Flutter and Dart import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

//Self import
import 'package:guess_what/ui/pages/guessCreate.dart';

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

  Future<File> getthumbnailImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 50, autoCorrectionAngle: true);
    return result;
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
      {BuildContext context, Map multiMedia, FirebaseUser user}) {
    if (multiMedia.isNotEmpty) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GuessCreate(
            multiMedia: multiMedia,
            user: user,
          ),
        ),
      );
    }
  }
}
