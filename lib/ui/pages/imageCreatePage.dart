//Flutter and dart import
import 'package:Tekel/core/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/viewModel/riddleCreateModelView.dart';
import 'package:Tekel/core/custom/customGeoPoint.dart';

class ImageCreatePage extends StatelessWidget {
  final Map _multiMedia;
  final User _user;
  final BuildContext _context;
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();
  ImageCreatePage({multiMedia, user, context})
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
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
                    maxLength: 10,
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
                  ChangeNotifierProvider<RiddleCreateViewModel>.value(
                    value: RiddleCreateViewModel(),
                    child: Consumer<RiddleCreateViewModel>(
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
                                      var _userDb =
                                          await Provider.of<DatabaseServices>(
                                                  context)
                                              .getUser();

                                      if (_formCreateKey
                                              .currentState.value['answer'] !=
                                          '') {
                                        model.riddle['answer'] = _formCreateKey
                                            .currentState.value['answer'];
                                      }

                                      if (_formCreateKey.currentState
                                              .value['description'] !=
                                          '') {
                                        model.riddle['description'] =
                                            _formCreateKey.currentState
                                                .value['description'];
                                      }

                                      model.riddle['user'] = {
                                        'uid': _user.uid,
                                        'displayName': _user.displayName,
                                        'photoUrl': _userDb.photoUrl,
                                      };

                                      var _riddleLocation =
                                          await CustomGeoPoint().addGeoPoint();
                                      if (_riddleLocation != null) {
                                        model.riddle['location'] =
                                            _riddleLocation;
                                      }

                                      // _riddle['thumbnail'] = _urlThumbnail;
                                      model.riddle['creationDate'] =
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
