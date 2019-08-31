//Flutter and dart import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/viewModel/ridlleCreateModelView.dart';
import 'package:Tekel/core/custom/customGeoPoint.dart';

class GuessCreate extends StatelessWidget {
  final Map _multiMedia;
  final FirebaseUser _user;
  final BuildContext _context;
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();
  GuessCreate({multiMedia, user, context})
      : _multiMedia = multiMedia,
        _user = user,
        _context = context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a Riddle',
        ),
        leading: IconButton(
          //Costum Back Button
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200.0,
                child: _multiMedia['image'] == null
                    ? Icon(
                        SimpleLineIcons.getIconData('plus'),
                        size: 40.0,
                      )
                    : Image.file(
                        _multiMedia['image'],
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
                    attribute: "answer",
                    decoration: InputDecoration(
                      labelText: "Answer",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'The answer of your riddle',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
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
                          'You can write something funny about your riddle',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero),
                      ),
                    ),
                    maxLength: 350,
                    maxLengthEnforced: true,
                    validators: [
                      FormBuilderValidators.max(350),
                    ],
                  ),
                  ChangeNotifierProvider<RidlleCreateViewModel>.value(
                    value: RidlleCreateViewModel(),
                    child: Consumer<RidlleCreateViewModel>(
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
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow[600],
                                      Colors.orange[400]
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp,
                                  ),
                                ),
                                child: FlatButton(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    if (_formCreateKey.currentState
                                        .saveAndValidate()) {
                                      model.getFile(_multiMedia['video'],
                                          _multiMedia['image']);

                                      //? I think that the thumbnail is not needed for now
                                      /*  var _fileThumbnail = _multiMedia[
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
                                              .getUser();

                                      if (_formCreateKey
                                              .currentState.value['answer'] !=
                                          '') {
                                        model.ridlle['answer'] = _formCreateKey
                                            .currentState.value['answer'];
                                      }

                                      if (_formCreateKey.currentState
                                              .value['description'] !=
                                          '') {
                                        model.ridlle['description'] =
                                            _formCreateKey.currentState
                                                .value['description'];
                                      }

                                      model.ridlle['user'] = {
                                        'uid': _user.uid,
                                        'displayName': _user.displayName,
                                        'photoURL': _userDb.photoURL,
                                      };

                                      var _ridlleLocation =
                                          await CustomGeoPoint().addGeoPoint();
                                      if (_ridlleLocation != null) {
                                        model.ridlle['location'] =
                                            _ridlleLocation;
                                      }

                                      // _ridlle['thumbnail'] = _urlThumbnail;
                                      model.ridlle['creationDate'] =
                                          DateTime.now();

                                      model.upload(_context);
                                    }
                                  },
                                ),
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
