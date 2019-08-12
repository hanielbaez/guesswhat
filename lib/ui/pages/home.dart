//Flutter and Dart import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/viewModel/DrawerViewModel.dart';
import 'package:guess_what/ui/widgets/custom/customDrawer.dart';
import 'package:guess_what/ui/widgets/custom/customListGuess.dart';
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
          IconButton(
            icon: Icon(SimpleLineIcons.getIconData('plus')),
            onPressed: () => onButtonPressed(context), //Add multimedia
          )
        ],
        title: Text(
          'Tekel',
          style: TextStyle(color: Colors.yellowAccent),
        ),
        centerTitle: true,
      ),
      drawer: ChangeNotifierProvider<DrawerViewModel>.value(
        value: DrawerViewModel(authentication: Provider.of(context)),
        child: Consumer<DrawerViewModel>(
          builder: (context, model, child) {
            return CustomDrawer(model: model);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(1, 191, 191, 191),
      body: CustomListGuess(),
    );
  }
}
