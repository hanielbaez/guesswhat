//Flutter and Dart import
import 'package:Tekel/core/viewModel/paginationViewModel.dart';
import 'package:flutter/material.dart';

//Self import

import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListRiddle extends StatefulWidget {
  final PaginationViewModel model;

  CustomListRiddle({Key key, this.model}) : super(key: key);

  @override
  _CustomListRiddleState createState() => _CustomListRiddleState();
}

class _CustomListRiddleState extends State<CustomListRiddle> {
  PaginationViewModel model;
  ScrollController _scrollController =
      ScrollController(); // listener for listview scrolling

  @override
  void initState() {
    model = widget.model;
    model.getRiddles();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        model.getRiddles();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.model.riddles.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            RiddleLayaout(riddle: model.riddles[index]),
            model.isLoading
                ? Center(
                    child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 50.0,
                    ),
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}
