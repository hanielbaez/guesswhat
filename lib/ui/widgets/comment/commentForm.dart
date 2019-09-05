//Flutter and Dart import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/model/comment.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/services/auth.dart';
import 'package:Tekel/core/services/db.dart';

class CommentForm extends StatelessWidget {
  const CommentForm({
    Key key,
    @required GlobalKey<FormBuilderState> fbKey,
    @required this.riddle,
  })  : _fbKey = fbKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _fbKey;
  final Riddle riddle;

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
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    hintText: 'Enter a comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(right: Radius.zero),
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(right: Radius.zero),
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                  ),
                  maxLengthEnforced: true,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Your comment cannot be empty'),
                    FormBuilderValidators.max(350),
                  ],
                ),
              ),
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
              margin: EdgeInsets.all(2.0),
              child: IconButton(
                icon: Icon(
                  SimpleLineIcons.getIconData('arrow-up'),
                  color: Colors.black,
                  size: 30.0,
                ),
                onPressed: () async {
                  var _user =
                      await Provider.of<DatabaseServices>(context).getUser();
                  if (_fbKey.currentState.saveAndValidate()) {
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
                    Provider.of<DatabaseServices>(context).uploadComment(
                        comment: newComment, riddleId: riddle.id);
                    FocusScope.of(context)
                        .requestFocus(new FocusNode()); //Hide the keyboard
                    _fbKey.currentState.reset();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
