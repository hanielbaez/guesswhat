//Flutter and dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:image_picker/image_picker.dart';

//Self import
import 'package:Tekel/core/viewModel/SourceMediaViewModel.dart';

/* Handle the user actions, when trying to add new content,
if the user is not singIn him will be redirected to the singIng buttons */

void onButtonPressed({BuildContext context}) {
  SourceImageOption _sourceOption = SourceImageOption();
  showModalBottomSheet(
    context: context,
    builder: (context) {
      Map _multiMedia = {};
      var data = EasyLocalizationProvider.of(context).data;
      return EasyLocalizationProvider(
        data: data,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context).tr('bottomSheet.title'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.black26,
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context).tr('bottomSheet.write_it'),
                ),
                dense: false,
                leading: Icon(
                  SimpleLineIcons.getIconData('note'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'createTextRiddle');
                },
              ),
              Divider(
                color: Colors.black26,
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context).tr('bottomSheet.capture_image'),
                ),
                leading: Icon(
                  SimpleLineIcons.getIconData('camera'),
                ),
                onTap: () async {
                  try {
                    _multiMedia['image'] = await _sourceOption.getImage(
                        ImageSource.camera, context);

                    _sourceOption.navigateToCreate(
                        context: context, multiMedia: _multiMedia);
                  } catch (error) {
                    print('Error: $error');
                  }
                },
              ),
              Divider(
                color: Colors.black26,
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context).tr('bottomSheet.gallery_image'),
                ),
                leading: Icon(
                  SimpleLineIcons.getIconData('picture'),
                ),
                onTap: () async {
                  try {
                    _multiMedia['image'] = await _sourceOption.getImage(
                        ImageSource.gallery, context);

                    _sourceOption.navigateToCreate(
                        context: context, multiMedia: _multiMedia);
                  } catch (error) {
                    print('getImage error: ' + error.toString());
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
