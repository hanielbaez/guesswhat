import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/services/location.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TextCreatePage extends StatefulWidget {
  static GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  _TextCreatePageState createState() => _TextCreatePageState();
}

class _TextCreatePageState extends State<TextCreatePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Text Riddle',
        ),
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
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
              key: TextCreatePage._formKey,
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "text",
                      maxLines: 4,
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
                      maxLength: 200,
                      autocorrect: false,
                      validators: [
                        FormBuilderValidators.minLength(3,
                            errorText: 'Your riddle should be longer.'),
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
                          if (!regex.hasMatch(val) &&
                              val.toString().isNotEmpty) {
                            return "No special characters or numbers";
                          }
                          return null;
                        },
                      ],
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
                      child: isLoading == true
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
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () async {
                                if (TextCreatePage._formKey.currentState
                                    .saveAndValidate()) {
                                  final Map<String, dynamic> riddle =
                                      Map<String, dynamic>();
                                  riddle['text'] = TextCreatePage
                                      ._formKey.currentState.value['text'];
                                  riddle['answer'] = TextCreatePage
                                      ._formKey.currentState.value['answer'];
                                  riddle['description'] = TextCreatePage
                                      ._formKey
                                      .currentState
                                      .value['description'];

                                  var location =
                                      await Provider.of<LocationServices>(
                                              context)
                                          .getGeoPoint();
                                  await Provider.of<DatabaseServices>(context)
                                      .uploadRiddle(
                                          riddle: riddle, location: location);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.pushReplacementNamed(context, '/');
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
