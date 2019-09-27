//Flutter and dart import
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/services/db.dart';

class SupportPage extends StatefulWidget {
  final User user;
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
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('supportPage.title'),
          ),
          leading: IconButton(
            icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
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
  final User user;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(AppLocalizations.of(context).tr('supportPage.description')),
        SizedBox(
          height: 30.0,
        ),
        FormBuilderTextField(
          attribute: "message",
          maxLines: 10,
          //autofocus: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)
                .tr('supportPage.label_message_text'),
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.zero),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.zero),
            ),
          ),
          maxLength: 500,
          autocorrect: false,
          validators: [
            FormBuilderValidators.minLength(25,
                errorText:
                    AppLocalizations.of(context).tr('supportPage.error_text')),
            FormBuilderValidators.max(500),
          ],
        ),
        SizedBox(
          height: 30.0,
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
          child: FlatButton(
            child: Text(
              AppLocalizations.of(context).tr('supportPage.submit_button'),
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              if (SupportPage._formCreateKey.currentState.saveAndValidate()) {
                Provider.of<DatabaseServices>(context).supportContact(
                    message: _formCreateKey.currentState.value['message']);
                function();
              }
            },
          ),
        ),
      ],
    );
  }
}
