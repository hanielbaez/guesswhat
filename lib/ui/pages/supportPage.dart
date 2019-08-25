//Flutter and dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//Self import
import 'package:guess_what/core/custom/customGeoPoint.dart';

class SupportPage extends StatelessWidget {
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Support',
        ),
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              key: _formCreateKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Text(
                    'We are here to help you. You will receive a response if necessary through your email as soon as possible.',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FormBuilderTextField(
                    attribute: "message",
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "Message",
                      labelStyle: TextStyle(color: Colors.black),
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
                    maxLength: 500,
                    maxLengthEnforced: true,
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(500),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FlatButton(
                    color: Colors.black,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _formCreateKey.currentState.save();
                      if (_formCreateKey.currentState.validate()) {}
                    },
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
