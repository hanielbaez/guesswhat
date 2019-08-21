//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomGridView extends StatelessWidget {
  final List list;

  CustomGridView({this.list});

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: list.length,
      itemBuilder: (BuildContext contex, int index) => Card(
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
      staggeredTileBuilder: (_) => StaggeredTile.fit(2),
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
    );
  }
}
