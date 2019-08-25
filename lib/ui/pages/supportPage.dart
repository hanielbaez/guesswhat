//Flutter and dart import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/model/supportContact.dart';
import 'package:guess_what/core/services/db.dart';

class SupportPage extends StatefulWidget {
  final FirebaseUser user;
  static GlobalKey<FormBuilderState> _formCreateKey =
      GlobalKey<FormBuilderState>();

  SupportPage({this.user});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Widget selectedWidget;

  void initState() {
    selectedWidget = SupportForm(
        formCreateKey: SupportPage._formCreateKey,
        user: widget.user,
        function: activateSwitcher);
    super.initState();
  }

  void activateSwitcher() {
    setState(() {
      selectedWidget = textBuilder;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Support',
        ),
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              key: SupportPage._formCreateKey,
              autovalidate: true,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: selectedWidget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textBuilder = Text(
    'Message Send',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.black),
  );
}

class SupportForm extends StatelessWidget {
  const SupportForm({
    Key key,
    @required GlobalKey<FormBuilderState> formCreateKey,
    @required this.user,
    @required this.function,
  })  : _formCreateKey = formCreateKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formCreateKey;
  final FirebaseUser user;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'We are here to help you. You will receive a response if necessary through your email as soon as possible.',
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          height: 30.0,
        ),
        FormBuilderTextField(
          attribute: "message",
          maxLines: 10,
          decoration: InputDecoration(
            labelText: "Message",
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.zero),
              borderSide: BorderSide(color: Colors.black26, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.zero),
              borderSide: BorderSide(color: Colors.black26, width: 2.5),
            ),
          ),
          maxLength: 500,
          autocorrect: false,
          validators: [
            FormBuilderValidators.min(10),
            FormBuilderValidators.max(500),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        FlatButton(
          color: Colors.black,
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            SupportPage._formCreateKey.currentState.save();
            if (SupportPage._formCreateKey.currentState.validate()) {
              SupportContact support = SupportContact(
                  userId: user.uid,
                  userEmail: user.email,
                  description:
                      SupportPage._formCreateKey.currentState.value['message']);
              Provider.of<DatabaseServices>(context)
                  .supportContact(support: support);
              function();
            }
          },
        ),
      ],
    );
  }
}
