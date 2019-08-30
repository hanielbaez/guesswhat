import 'package:Tekel/core/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';

class EditUserPage extends StatelessWidget {
  final User user;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  EditUserPage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(SimpleLineIcons.getIconData('cloud-upload')),
            color: Colors.yellow,
            label: Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              //TODO: Implement upload
            },
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
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/noiseTv.gif',
                  image: '${user.photoURL}',
                  fit: BoxFit.cover,
                ),
              ),
              RaisedButton(
                child: Text('Change profile image'),
                onPressed: () {
                  //TODO: Implemented select image
                },
              ),
              Divider(),
              FormBuilder(
                key: _fbKey,
                child: Expanded(
                  child: ListView(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'name',
                        initialValue: '${user.displayName}',
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
                        initialValue: '${user.webSite}',
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
                        initialValue: '${user.biography}',
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
