import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/services/location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';

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
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr('textCreatePage.title')),
          leading: IconButton(
            icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'homePage'),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FormBuilder(
                key: TextCreatePage._formKey,
                child: Expanded(
                  child: ListView(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "text",
                        maxLines: 3,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .tr("textCreatePage.riddleLabelText"),
                          hintText: AppLocalizations.of(context)
                              .tr("textCreatePage.riddleHitText"),
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
                        maxLength: 500,
                        autocorrect: false,
                        validators: [
                          FormBuilderValidators.minLength(
                            3,
                            errorText: AppLocalizations.of(context)
                                .tr("textCreatePage.riddleErrorMinLength"),
                          ),
                          FormBuilderValidators.max(
                            500,
                            errorText: AppLocalizations.of(context)
                                .tr("textCreatePage.riddleErrorMax"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FormBuilderTextField(
                        attribute: "answer",
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .tr("textCreatePage.answerLabelText"),
                          hintText: AppLocalizations.of(context)
                              .tr("textCreatePage.answerHitText"),
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
                        maxLength: 8,
                        validators: [
                          (val) {
                            RegExp regex = RegExp(r'^[0-9a-zA-Z ]+$');
                            if (!regex.hasMatch(val) &&
                                val.toString().isNotEmpty) {
                              return AppLocalizations.of(context)
                                  .tr("textCreatePage.answerErrorText");
                            }
                            return null;
                          },
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "description",
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .tr("textCreatePage.descriptionLabelText"),
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: AppLocalizations.of(context)
                              .tr("textCreatePage.descriptionHitText"),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(right: Radius.zero),
                          ),
                        ),
                        maxLength: 500,
                        maxLengthEnforced: true,
                        validators: [
                          FormBuilderValidators.max(500),
                        ],
                      ),
                      FormBuilderDropdown(
                        attribute: "category",
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .tr("textCreatePage.dropDown.labelText"),
                        ),
                        hint: Text(
                          AppLocalizations.of(context)
                              .tr("textCreatePage.dropDown.hintText"),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                            errorText: AppLocalizations.of(context)
                                .tr("textCreatePage.dropDown.hintText"),
                          )
                        ],
                        items: [
                          'sport',
                          'culture',
                          'animal',
                          'math',
                          'people',
                          'movieAndTv',
                          'scienceAndTechnology',
                          'others'
                        ]
                            .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(AppLocalizations.of(context)
                                    .tr("category.$category"))))
                            .toList(),
                      ),
                      SizedBox(
                        height: 25.0,
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
                                  AppLocalizations.of(context)
                                      .tr("textCreatePage.submitButton"),
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
                                    riddle['category'] = TextCreatePage._formKey
                                        .currentState.value['category'];

                                    var location =
                                        await Provider.of<LocationServices>(
                                                context)
                                            .getGeoPoint();
                                    await Provider.of<DatabaseServices>(context)
                                        .uploadRiddle(
                                            riddle: riddle, location: location);
                                    setState(
                                      () {
                                        isLoading = true;
                                      },
                                    );
                                    Navigator.pushReplacementNamed(
                                        context, 'homePage');
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
      ),
    );
  }
}
