//Flutter Dart import
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/core/model/ridlle.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/ui/widgets/comment/commentForm.dart';
import 'package:Tekel/ui/widgets/custom/userBar.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final Ridlle ridlle;

  CommentPage({this.ridlle});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Ridlle ridlle;

  @override
  void initState() {
    ridlle = widget.ridlle;
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Provider.of<DatabaseServices>(context)
                    .getAllComments(ridlle.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError)
                      return Text('Error: Please try later');
                    print('Snapshot data ${snapshot.hasData}');
                    if (snapshot.data.documents.length > 0) {
                      return ListViewBuilder(snapshot: snapshot);
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              SimpleLineIcons.getIconData('bubble'),
                              color: Colors.yellow,
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text('Make the first comment'),
                          ],
                        ),
                      );
                    }
                  }

                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CommentForm(fbKey: _fbKey, ridlle: ridlle),
            )
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
          //color: Colors.white12,
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
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                    '${snapshot.data.documents[index]['text']}',
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
