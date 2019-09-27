//Flutter and dart import
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//Self import
import 'package:Tekel/core/viewModel/riddleCreateModelView.dart';

class ImageCreatePage extends StatelessWidget {
  final Map _multiMedia;
  final BuildContext _context;
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();
  ImageCreatePage({multiMedia, context})
      : _multiMedia = multiMedia,
        _context = context;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr("imageCreatePage.title"),
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
                        labelText: AppLocalizations.of(context)
                            .tr("imageCreatePage.answerLabelText"),
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: AppLocalizations.of(context)
                            .tr("imageCreatePage.answerHitText"),
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
                            return AppLocalizations.of(context)
                                .tr("imageCreatePage.answerErrorText");
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
                        labelText: AppLocalizations.of(context)
                                .tr("imageCreatePage.descriptionLabelText"),
                        labelStyle: TextStyle(color: Colors.black),
                        hintText:AppLocalizations.of(context)
                                .tr("imageCreatePage.descriptionHitText"),
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
                                      AppLocalizations.of(context)
                                .tr("imageCreatePage.submitButton"),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      if (_formCreateKey.currentState
                                          .saveAndValidate()) {
                                        model.getFile(_multiMedia['video'],
                                            _multiMedia['image']);

                                        if (_formCreateKey
                                                .currentState.value['answer'] !=
                                            '') {
                                          model.riddle['answer'] =
                                              _formCreateKey
                                                  .currentState.value['answer'];
                                        }

                                        if (_formCreateKey.currentState
                                                .value['description'] !=
                                            '') {
                                          model.riddle['description'] =
                                              _formCreateKey.currentState
                                                  .value['description'];
                                        }

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
      ),
    );
  }
}
