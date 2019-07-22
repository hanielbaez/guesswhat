import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/SourceMediaViewModel.dart';
import 'package:guess_what/core/viewModel/guessModel.dart';
import 'package:guess_what/ui/pages/guessCreate.dart';
import 'package:guess_what/ui/widgets/costum/costumListGuess.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black45,
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black38,
            ),
            onPressed: () => _onButtonPressed(context), //Add multimedia
          )
        ],
        title: Text(
          'GuessWhat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider<GuessModel>.value(
        value: GuessModel(
          databaseServices: Provider.of(context),
        ),
        child: Consumer<GuessModel>(
          builder: (context, model, child) {
            return CostumListGuess(
              model: model,
              onModelReady: () => model.getAllGuesses(),
            );
          },
        ),
      ),
    );
  }
}

void _onButtonPressed(context) {
  SourceImageOption _sourceOption = SourceImageOption();

  //Todo: Add the thrumbal for the video

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Capture Image'),
            leading: Icon(Icons.photo_camera),
            onTap: () async {
              var _mediaFile = await _sourceOption.getImage(ImageSource.camera);
              _sourceOption.navigateToCreate(
                  context: context, mediaFile: _mediaFile);
            },
          ),
          ListTile(
            title: Text('Capture Video'),
            leading: Icon(Icons.videocam),
            onTap: () async {
              var _mediaFile = await _sourceOption.getVideo(ImageSource.camera);
              _mediaFile = await _sourceOption.getThumbnailVideo(_mediaFile);
              //? Remember I'm still need get the videoFile
              _sourceOption.navigateToCreate(
                  context: context, mediaFile: _mediaFile);
            },
          ),
          ListTile(
            title: Text('Image from Gallery'),
            leading: Icon(Icons.photo_album),
            onTap: () async {
              var _mediaFile =
                  await _sourceOption.getImage(ImageSource.gallery);
              _sourceOption.navigateToCreate(
                  context: context, mediaFile: _mediaFile);
            },
          ),
          ListTile(
            title: Text('Video from Gallery'),
            leading: Icon(Icons.video_library),
            onTap: () async {
              var _mediaFile =
                  await _sourceOption.getVideo(ImageSource.gallery);
              _mediaFile = await _sourceOption.getThumbnailVideo(_mediaFile);
              _sourceOption.navigateToCreate(
                  context: context, mediaFile: _mediaFile);
            },
          ),
        ],
      );
    },
  );
}
