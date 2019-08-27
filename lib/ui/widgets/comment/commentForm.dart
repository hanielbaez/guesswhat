//Flutter and Dart import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/model/ridlle.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/services/db.dart';

class CommentForm extends StatelessWidget {
  const CommentForm({
    Key key,
    @required GlobalKey<FormBuilderState> fbKey,
    @required this.ridlle,
  })  : _fbKey = fbKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _fbKey;
  final Ridlle ridlle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: Provider.of<AuthenticationServices>(context).user(),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                SimpleLineIcons.getIconData('arrow-up'),
                color: Colors.yellow,
                size: 30.0,
              ),
              onPressed: () async {
                _fbKey.currentState.save();
                var _user = await Provider.of<DatabaseServices>(context)
                    .getUser(snapshot.data);
                if (_fbKey.currentState.validate()) {
                  Comment newComment = Comment(
                    text: _fbKey.currentState.value['comment'],
                    user: {
                      'displayName': snapshot.data.displayName,
                      'uid': snapshot.data.uid,
                      'photoURL': _user.photoURL,
                    },
                    creationDate: Timestamp.now(),
                  );

                  //Save the new comment at the database
                  Provider.of<DatabaseServices>(context)
                      .uploadComment(comment: newComment, ridlleId: ridlle.id);
                  FocusScope.of(context)
                      .requestFocus(new FocusNode()); //Hide the keyboard
                  _fbKey.currentState.reset();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
