import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';
import 'package:guess_what/ui/pages/home.dart';
import 'package:guess_what/ui/widgets/comment/commentForm.dart';
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
    model.getComments(guess.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
        leading: IconButton(
          //Costum Back Button
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          ),
        ),
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
                  return model.listComments.isEmpty
                      ? Center(
                          child: Text(
                            'Make the first comment',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Column(
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

