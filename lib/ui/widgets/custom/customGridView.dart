//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:provider/provider.dart';

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
              .getGuess(guessId: list[index]['guessId']);

          Navigator.of(context).pushNamed('guessPage', arguments: guess);
        },
        child: Hero(
          tag: list[index]['guessId'],
          child: Card(
            color: Colors.black,
            margin: EdgeInsets.all(1.0),
            child: Container(
              width: 100.0,
              height: 100.0,
              child: Image.network(
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
