//Flutter and dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//Self import
import 'package:guess_what/core/custom/customGeoPoint.dart';

class GuessCreate extends StatelessWidget {
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom support',
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
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
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
                          'You can write something funny about your riddle',
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
                  FlatButton(
                    color: Colors.black,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _formCreateKey.currentState.save();
                      if (_formCreateKey.currentState.validate()) {
                        var _guessLocation =
                            await CustomGeoPoint().addGeoPoint();
                      }
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
