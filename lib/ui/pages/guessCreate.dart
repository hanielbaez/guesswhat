//Flutter and dart import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/custom/customGeoPoint.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//Self import
import 'package:guess_what/core/services/db.dart';
import 'package:guess_what/core/viewModel/guessCreateModelView.dart';
import 'package:guess_what/ui/pages/home.dart';

class GuessCreate extends StatelessWidget {
  final Map _multiMedia;
  final FirebaseUser _user;
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();
  GuessCreate({multiMedia, user})
      : _multiMedia = multiMedia,
        _user = user;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _guess = {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a Guess',
        ),
        leading: IconButton(
          //Costum Back Button
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => navigateHome(context),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200.0,
                child: Image.file(
                  _multiMedia['imageThumbnail'] ??
                      _multiMedia['videoThumbnail'],
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            FormBuilder(
              key: _formCreateKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "word",
                    decoration: InputDecoration(
                      labelText: "Word",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Word to be guess',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                        borderSide: BorderSide(color: Colors.black26, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                        borderSide:
                            BorderSide(color: Colors.black26, width: 2.5),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: 9,
                    validators: [
                      (val) {
                        RegExp regex = RegExp(r'^[0-9a-zA-Z ]+$');
                        if (!regex.hasMatch(val) && val.toString().isNotEmpty) {
                          return "No special characters or numbers";
                        }
                        return null;
                      },
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FormBuilderTextField(
                    attribute: "description",
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText:
                          'You can write something funny about your guess',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                        borderSide: BorderSide(color: Colors.black26, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                        borderSide:
                            BorderSide(color: Colors.black26, width: 2.5),
                      ),
                    ),
                    maxLength: 350,
                    maxLengthEnforced: true,
                    validators: [
                      FormBuilderValidators.max(350),
                    ],
                  ),
                  ChangeNotifierProvider<GuessCreateViewModel>.value(
                    value: GuessCreateViewModel(
                        databaseServices: Provider.of(context)),
                    child: Consumer<GuessCreateViewModel>(
                      builder: (context, model, child) {
                        return model.loading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SpinKitThreeBounce(
                                    color: Colors.black,
                                    size: 25.0,
                                  ),
                                ),
                              )
                            : FlatButton(
                                color: Colors.black,
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  _formCreateKey.currentState.save();
                                  if (_formCreateKey.currentState.validate()) {
                                    var _file = _multiMedia['video'] ??
                                        _multiMedia['image'];
                                    //? I think that the thumbnail is not needed for now
                                    /* var _fileThumbnail = _multiMedia[
                                                    'imageThumbnail'] ??
                                                _multiMedia['videoThumbnail']; */

                                    /* var _urlThumbnail =
                                                await model.uploadFireStore(
                                                    file: _fileThumbnail
                                                    ); */

                                    //Set the map with the form text value

                                    var _userDb =
                                        await Provider.of<DatabaseServices>(
                                                context)
                                            .getUser(_user);

                                    if (_formCreateKey
                                            .currentState.value['word'] !=
                                        '') {
                                      _guess['word'] = _formCreateKey
                                          .currentState.value['word'];
                                    }

                                    if (_formCreateKey.currentState
                                            .value['description'] !=
                                        '') {
                                      _guess['description'] = _formCreateKey
                                          .currentState.value['description'];
                                    }

                                    _guess['user'] = {
                                      'uid': _user.uid,
                                      'displayName': _user.displayName,
                                      'photoURL': _userDb.photoURL,
                                    };

                                    var _guessLocation =
                                        await CustomGeoPoint().addGeoPoint();
                                    if (_guessLocation != null) {
                                      _guess['location'] = _guessLocation;
                                    }

                                    // _guess['thumbnail'] = _urlThumbnail;
                                    _guess['creationDate'] = DateTime.now();

                                    navigateHome(context);

                                    //Upload media to FireStore
                                    var _url =
                                        await Provider.of<DatabaseServices>(
                                                context)
                                            .uploadToFireStore(_file);

                                    //Get the media Type video/image
                                    var listSplit =
                                        lookupMimeType(_file.path).split('/');
                                    listSplit[0] == 'image'
                                        ? _guess['imageURL'] = _url
                                        : _guess['videoURL'] = _url;

                                    Provider.of<DatabaseServices>(context)
                                        .uploadGuess(_guess);
                                  }
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => HomePage(),
    ),
  );
}
