import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';
import 'package:guess_what/ui/widgets/costum/userBar.dart';

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
  Guess guess;

  @override
  void initState() {
    model = widget.model;
    guess = widget.guess;
    print('ID ${guess.id}');
    model.getComments(guess.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: model.listComments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      UserBar(),
                      SizedBox(height: 10.0),
                      ExpandablePanel(
                        collapsed: Text(
                          '${model.listComments[index].text}',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        expanded: Text(
                          '${model.listComments[index].text}',
                          style: TextStyle(color: Colors.white),
                          softWrap: true,
                        ),
                        tapHeaderToExpand: true,
                        tapBodyToCollapse: true,
                        hasIcon: false,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.5),
                      )
                    ],
                  );
                },
              ),
            ),
            CommentForm(fbKey: _fbKey, model: model, guess: guess),
          ],
        ),
      ),
    );
  }
}

class CommentForm extends StatelessWidget {
  const CommentForm({
    Key key,
    @required GlobalKey<FormBuilderState> fbKey,
    @required this.model,
    @required this.guess,
  })  : _fbKey = fbKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _fbKey;
  final CommentViewModel model;
  final Guess guess;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          child: Flexible(
            child: FormBuilderTextField(
              attribute: "comment",
              maxLines: 1,
              autofocus: true,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                hintText: 'Enter a comment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.zero),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.zero),
                  borderSide: BorderSide(color: Colors.white, width: 2.5),
                ),
              ),
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              maxLength: 350,
              maxLengthEnforced: true,
              validators: [
                FormBuilderValidators.required(
                    errorText: 'Your comment cannot be empty'),
                FormBuilderValidators.max(350),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () {
            _fbKey.currentState.save();
            if (_fbKey.currentState.validate()) {
              Comment newComment = Comment(
                text: _fbKey.currentState.value['comment'],
                creationDate: Timestamp.now(),
              );

              model.uploadComment(comment: newComment, guessID: guess.id);
            }
          },
        ),
      ],
    );
  }
}
