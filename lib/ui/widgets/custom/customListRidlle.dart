//Flutter and Dart import
import 'package:Tekel/core/viewModel/paginationViewModel.dart';
import 'package:flutter/material.dart';

//Self import

import 'package:Tekel/ui/widgets/ridlle/ridlle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListRidlle extends StatefulWidget {
  final PaginationViewModel model;

  CustomListRidlle({Key key, this.model}) : super(key: key);

  @override
  _CustomListRidlleState createState() => _CustomListRidlleState();
}

class _CustomListRidlleState extends State<CustomListRidlle> {
  PaginationViewModel model;
  ScrollController _scrollController =
      ScrollController(); // listener for listview scrolling

  @override
  void initState() {
    model = widget.model;
    model.getRidlles();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        model.getRidlles();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.model.ridlles.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            RidlleLayaout(ridlle: model.ridlles[index]),
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
