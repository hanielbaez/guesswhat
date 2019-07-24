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
              _multiMedia['image'] =
                  await _sourceOption.getImage(ImageSource.camera);
                  print(' MultiMedia Image ${_multiMedia['image']}');
              _multiMedia['imageThumbnail'] =
                  await _sourceOption.getthumbnailImage(
                      _multiMedia['image'], _multiMedia['image'].path);
              _sourceOption.navigateToCreate(
                  context: context, multiMedia: _multiMedia);
            },
          ),
          ListTile(
            title: Text('Capture Video'),
            leading: Icon(Icons.videocam),
            onTap: () async {
              _multiMedia['video'] =
                  await _sourceOption.getVideo(ImageSource.camera);
              _multiMedia['videoThumbnail'] =
                  await _sourceOption.getThumbnailVideo(_multiMedia['video']);
              _sourceOption.navigateToCreate(
                  context: context, multiMedia: _multiMedia);
            },
          ),
          ListTile(
            title: Text('Image from Gallery'),
            leading: Icon(Icons.photo_album),
            onTap: () async {
              _multiMedia['image'] =
                  await _sourceOption.getImage(ImageSource.gallery);
              _multiMedia['imageThumbnail'] =
                  await _sourceOption.getthumbnailImage(
                      _multiMedia['image'], _multiMedia['image'].path);
              _sourceOption.navigateToCreate(
                  context: context, multiMedia: _multiMedia);
            },
          ),
          ListTile(
            title: Text('Video from Gallery'),
            leading: Icon(Icons.video_library),
            onTap: () async {
              _multiMedia['video'] =
                  await _sourceOption.getVideo(ImageSource.gallery);
              _multiMedia['videoThumbnail'] =
                  await _sourceOption.getThumbnailVideo(_multiMedia['video']);
              _sourceOption.navigateToCreate(
                  context: context, multiMedia: _multiMedia);
            },
          ),
        ],
      );
    },
  );
}
