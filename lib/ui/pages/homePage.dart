//Flutter and Dart import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/viewModel/paginationViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customDrawer.dart';
import 'package:Tekel/ui/widgets/custom/customListRidlle.dart';
import 'package:provider/provider.dart';
import '../widgets/custom/buttonPress.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('menu')),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          Card(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow[600], Colors.orange[400]],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: IconButton(
                  icon: Icon(
                    SimpleLineIcons.getIconData('plus'),
                    color: Colors.black,
                    semanticLabel: 'Create a ridlle',
                  ),
                  onPressed: () => Provider.of<DatabaseServices>(context)
                          .getUser()
                          .then((userSnap) {
                        if (userSnap != null) {
                          onButtonPressed(
                              context: context,
                              user: userSnap); //Add multimedia
                        } else {
                          _scaffoldKey.currentState.openDrawer();
                        }
                      })),
            ),
          )
        ],
        title: Text(
          'Tekel',
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<PaginationViewModel>.value(
        value: PaginationViewModel(),
        child: Consumer<PaginationViewModel>(
          builder: (context, model, child) => CustomListRidlle(model: model),
        ),
      ),
    );
  }
}
