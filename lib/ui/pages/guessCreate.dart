import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:guess_what/core/viewModel/guessCreateModelView.dart';
import 'package:guess_what/ui/pages/home.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class GuessCreate extends StatelessWidget {
  final Map _multiMedia;
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();
  GuessCreate({multiMedia}) : _multiMedia = multiMedia;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _guess = {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a Guess',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          //Costum Back Button
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => navigateHome(context),
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
                child: Image.file(
                  _multiMedia['imageThumbnail'] ??
                      _multiMedia['videoThumbnail'],
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
                    attribute: "word",
                    decoration: InputDecoration(
                      labelText: "Word",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Word to be guess',
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
                        //Todo permitir enviar valores vacios a FireBase
                        //Todo Detectar si la palabra secreta esta compuesta por numeros, letras o una combinacion de ambos
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
                          'You can write something funny about your guess',
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
                  ChangeNotifierProvider<GuessCreateViewModel>.value(
                    value: GuessCreateViewModel(
                        databaseServices: Provider.of(context)),
                    child: Consumer<GuessCreateViewModel>(
                      builder: (context, model, child) {
                        return FlatButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            _formCreateKey.currentState.save();
                            if (_formCreateKey.currentState.validate()) {
                              var _file =
                                  _multiMedia['video'] ?? _multiMedia['image'];
                              var _fileThumbnail =
                                  _multiMedia['imageThumbnail'] ??
                                      _multiMedia['videoThumbnail'];

                              var _url = await model.uploadFireStore(
                                  file: _file, context: context);
                              var _urlThumbnail = await model.uploadFireStore(
                                  file: _fileThumbnail, context: context);

                              //Set the map with the form text value
                              _guess['word'] =
                                  _formCreateKey.currentState.value['word'];
                              _guess['description'] = _formCreateKey
                                  .currentState.value['description'];
                              _guess['userName'] = 'Haniel';
                              _guess['thumbnail'] = _urlThumbnail;
                              _guess['creationDate'] = DateTime.now();

                              var listSplit =
                                  lookupMimeType(_file.path).split('/');

                              listSplit[0] == 'image'
                                  ? _guess['imageURL'] = _url
                                  : _guess['videoURL'] = _url;

                              model.uploadFireBase(guess: _guess);

                              navigateHome(context);
                            }
                          },
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

void navigateHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => HomePage(),
    ),
  );
}
