import 'package:flutter/widgets.dart';
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/services/db.dart';

class CommentViewModel extends ChangeNotifier {
  DatabaseServices _databaseServices;
  List<Comment> listComments = [];
  ScrollController scrollController = ScrollController();

  CommentViewModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  void getComments(String guessID) async {
    listComments = await _databaseServices.getAllComments(guessID);
    notifyListeners();
  }

  Future uploadComment({Comment comment, String guessID}) async {
    await _databaseServices.uploadComment(comment: comment, guessID: guessID);
    getComments(guessID); //? This is not optimal
  }

  //Scroll to the last comment
  void scrollBotton() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
