//Flutter Dart import
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:guess_what/ui/widgets/comment/commentForm.dart';
import 'package:guess_what/ui/widgets/custom/userBar.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final Guess guess;

  CommentPage({this.guess});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Guess guess;

  @override
  void initState() {
    guess = widget.guess;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
        leading: IconButton(
          //Custom Back Button
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Provider.of<DatabaseServices>(context)
                    .getAllComments(guess.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError)
                      return Text('Error: Please try later');
                    return ListViewBuilder(snapshot: snapshot);
                  }
                  return Container();
                },
              ),
            ),
            Card(
                color: Colors.white10,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CommentForm(fbKey: _fbKey, guess: guess),
                )),
          ],
        ),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({
    Key key,
    //@required this.model,
    @required this.snapshot,
  }) : super(key: key);

  //final CommentViewModel model;
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //controller: model.scrollController,
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        var userData = {
          'displayName': snapshot.data.documents[index]['user']['displayName'],
          'uid': snapshot.data.documents[index]['user']['uid'],
          'photoURL': snapshot.data.documents[index]['user']['photoURL'],
        };

        return Card(
          color: Colors.white12,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UserBar(
                  userData: userData,
                  timeStamp: snapshot.data.documents[index]['creationDate'],
                ),
                SizedBox(height: 10.0),
                ExpandablePanel(
                  collapsed: Text(
                    '${snapshot.data.documents[index]['text']}',
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                    '${snapshot.data.documents[index]['text']}',
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                  tapHeaderToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
