import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';

class TextCreatePage extends StatelessWidget {
  static GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Text Riddle',
        ),
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "riddle",
                    maxLines: 5,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Riddle",
                      hintText:
                          'Write a riddle that intrigues the entire world',
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
                    autocorrect: false,
                    validators: [
                      FormBuilderValidators.minLength(25,
                          errorText: 'Your message should be longer.'),
                      FormBuilderValidators.max(200),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FormBuilderTextField(
                    attribute: "answer",
                    decoration: InputDecoration(
                      labelText: "Answer",
                      hintText: 'The respective answer to your riddle',
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
                    child: FlatButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {},
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
