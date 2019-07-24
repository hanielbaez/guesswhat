import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:guess_what/core/viewModel/guessCreateModelView.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class GuessCreate extends StatefulWidget {
  final Map _multiMedia;
  GuessCreate({multiMedia}) : _multiMedia = multiMedia;

  @override
  _GuessCreateState createState() => _GuessCreateState();
}

class _GuessCreateState extends State<GuessCreate> {
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();
  static TextEditingController _wordController = TextEditingController();
  static TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    /* _wordController.dispose();
    _descriptionController.dispose(); */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _guess = {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a Guess',
          style: TextStyle(color: Colors.black),
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
                  widget._multiMedia['imageThumbnail'] ??
                      widget._multiMedia['videoThumbnail'],
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
                    controller: _wordController,
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
                    maxLength: 7,
                    validators: [
                      FormBuilderValidators.max(7),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FormBuilderTextField(
                    attribute: "description",
                    controller: _descriptionController,
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
                              var _file = widget._multiMedia['video'] ??
                                  widget._multiMedia['image'];

                              var url =
                                  await model.uploadFireStore(file: _file);

                              //Set the map with the form text value
                              _guess['word'] = _wordController.value.text;
                              _guess['description'] =
                                  _descriptionController.value.text;
                              _guess['userName'] = 'Haniel';

                              var listSplit =
                                  lookupMimeType(_file.path).split('/');

                              listSplit[0] == 'image'
                                  ? _guess['imageURL'] = url
                                  : _guess['videoURL'] = url;

                              model.uploadFireBase(guess: _guess);
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
