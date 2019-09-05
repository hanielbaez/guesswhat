import 'dart:io';

import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  final User user;

  EditUserPage({this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget imageWidget;
  File file;
  bool imageChanged = false;

  @override
  void initState() {
    imageWidget = FadeInImage.assetNetwork(
      placeholder: 'assets/images/noiseTv.gif',
      image: '${widget.user.photoURL}',
      fit: BoxFit.cover,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow[600], Colors.orange[400]],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: FlatButton.icon(
              icon: Icon(SimpleLineIcons.getIconData('cloud-upload')),
              //color: Colors.yellow,
              label: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                if (_fbKey.currentState.saveAndValidate()) {
                  var imageUrl;
                  if (imageChanged) {
                    imageChanged = false;
                    imageUrl = await Provider.of<DatabaseServices>(context)
                        .uploadToFireStore(file);
                  }

                  var newUser = User(
                    uid: widget.user.uid,
                    displayName: _fbKey.currentState.value['name'],
                    photoURL: imageUrl ?? widget.user.photoURL,
                    webSite: _fbKey.currentState.value['webSite'],
                    biography: _fbKey.currentState.value['biography'],
                  );
                  Provider.of<DatabaseServices>(context)
                      .updateUserData(newUser);

                  Navigator.popAndPushNamed(context, 'userPage',
                      arguments: newUser);
                }
              },
            ),
          )
        ],
        title: Text('Tekel'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                child: imageWidget,
              ),
              RaisedButton(
                child: Text('Change profile image'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.yellow[100],
                        title: Text(
                          'Select Image',
                          style: TextStyle(),
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                  color: Colors.white,
                                  child: Text(
                                    'Gallery',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    file = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    if (file != null) {
                                      imageChanged = true;
                                      setState(() {
                                        imageWidget = Image.file(file);
                                      });
                                    }
                                  }),
                              SizedBox(
                                width: 10.0,
                              ),
                              RaisedButton(
                                  color: Colors.white,
                                  child: Text(
                                    'Camera',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    file = await ImagePicker.pickImage(
                                        source: ImageSource.camera);
                                    if (file != null) {
                                      imageChanged = true;
                                      setState(() {
                                        imageWidget = Image.file(file);
                                      });
                                    }
                                  })
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(),
              FormBuilder(
                key: _fbKey,
                autovalidate: true,
                child: Expanded(
                  child: ListView(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'name',
                        autovalidate: true,
                        initialValue: '${widget.user.displayName}',
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(20,
                              errorText: 'Try a shorter name.')
                        ],
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FormBuilderTextField(
                        attribute: 'webSite',
                        initialValue: '${widget.user.webSite}',
                        decoration: InputDecoration(
                          labelText: "Web Site",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FormBuilderTextField(
                        attribute: 'biography',
                        initialValue: '${widget.user.biography}',
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Biography",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
