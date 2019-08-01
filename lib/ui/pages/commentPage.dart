import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';

class CommentPage extends StatefulWidget {
  final CommentViewModel model;
  final Guess guess;

  CommentPage({this.model, this.guess});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  CommentViewModel model;

  @override
  void initState() {
    model = widget.model;
    Guess guess = widget.guess;
    print('ID ${guess.id}');
    model.getComments(guess.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments Section'),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      //backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: model.listComments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Text('${model.listComments[index].text}'),
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  child: Flexible(
                    child: FormBuilderTextField(
                      attribute: "comment",
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter a comment',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.horizontal(right: Radius.zero),
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1),
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
                  ),
                ),
                IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
