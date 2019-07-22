import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:guess_what/ui/pages/guessCreate.dart';
import 'package:image_picker/image_picker.dart';

class SourceImageOption {
  final _flutterVideoCompress = FlutterVideoCompress();

  Future<File> getImage(source) async {
    return await ImagePicker.pickImage(
        source: source, maxHeight: 1080, maxWidth: 1080);
  }

  Future<File> getVideo(source) async {
    return await ImagePicker.pickVideo(source: source);
  }

  Future<File> getThumbnailVideo(File file) async {
    final thumbnailFile =
        await _flutterVideoCompress.getThumbnailWithFile(file.path,
            quality: 50, // default(100)
            position: -1 // default(-1)
            );
    return thumbnailFile;
  }

  void navigateToCreate({BuildContext context, File mediaFile}) {
    Navigator.of(context).pop(); //Close the modal
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GuessCreate(multiMediaFile: mediaFile),
      ),
    );
  }
}
