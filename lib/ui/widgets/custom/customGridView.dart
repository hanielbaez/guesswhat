//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

//Selft import
import 'package:Tekel/core/services/db.dart';

class CustomGridView extends StatelessWidget {
  final List list;

  CustomGridView({this.list});

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 6,
      itemCount: list.length,
      itemBuilder: (BuildContext contex, int index) => InkWell(
        onTap: () async {
          var guess = await Provider.of<DatabaseServices>(context)
              .getRiddle(riddleId: list[index]['riddleId']);

          Navigator.of(context).pushNamed('riddlePage', arguments: guess);
        },
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.all(2.0),
          child: Container(
            width: 100.0,
            height: 100.0,
            child: Center(
              child: list[index]['thumbnailUrl'] == null
                  ? Text("${list[index]['text']}")
                  : Image.network(
                      list[index]['thumbnailUrl'],
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext contex, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Image.asset(
                          'assets/images/noiseTv.gif',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (_) => StaggeredTile.fit(2),
    );
  }
}
