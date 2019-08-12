//Flutter Dart import
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';
import 'package:guess_what/ui/pages/home.dart';
import 'package:guess_what/ui/widgets/comment/commentForm.dart';
import 'package:guess_what/ui/widgets/custom/userBar.dart';

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
              child: StreamBuilder(
                  stream: model.getComments(guess.id),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasError)
                          return (Text('Error: ${snapshot.error}'));
                        if (snapshot.hasData)
                          return ListViewBuilder(
                              model: model, snapshot: snapshot);
                        break;
                      case ConnectionState.done:
                        print('Comments fetch');
                    }
                    return Container(); //unreachable
                  }),
            ),
            CommentForm(fbKey: _fbKey, model: model, guess: guess),
          ],
        ),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({
    Key key,
    @required this.model,
    @required this.snapshot,
  }) : super(key: key);

  final CommentViewModel model;
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: model.scrollController,
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        var userData = {
          'displayName': snapshot.data.documents[index]['user']['displayName'],
          'uid': snapshot.data.documents[index]['user']['uid'],
          'photoURL': snapshot.data.documents[index]['user']['photoURL'],
        };

        return Column(
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
                textAlign: TextAlign.justify,
                softWrap: true,
                maxLines: 3,
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
            Divider(
              color: Colors.white.withOpacity(0.5),
            )
          ],
        );
      },
    );
  }
}
