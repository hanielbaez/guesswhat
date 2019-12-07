//Flutter and Dart import
import 'package:Tekel/core/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/core/model/comment.dart';

//TODO: Complete the PaginationComment

class PaginationComment extends ChangeNotifier {
  final DatabaseServices database;
  final String riddleId;

  PaginationComment({this.database, this.riddleId});

  Firestore firestore = Firestore.instance;
  List<Comment> commentList = []; //list of comments
  bool isLoading = false; //track if comments fetching
  bool hasMore = true; //flag for more comments available
  int documentsLimit = 10; //documents to fetched per request

  DocumentSnapshot lastDocument;
  QuerySnapshot querySnapshot;

  gteComments() async {
    if (hasMore == false) {
      return null;
    }

    if (isLoading) {
      return null;
    }

    isLoading = true;

    try {
      if (lastDocument == null) {
        querySnapshot = await firestore
            .collection('riddles')
            .document(riddleId)
            .collection('comments')
            .orderBy('createdAt', descending: false)
            .limit(documentsLimit)
            .getDocuments();
      } else {
        querySnapshot = await firestore
            .collection('riddles')
            .document(riddleId)
            .collection('comments')
            .orderBy('createdAt', descending: false)
            .startAfterDocument(lastDocument)
            .limit(documentsLimit)
            .getDocuments();
      }
    } catch (e) {
      print('getComments error: $e');
    }

    if (querySnapshot != null) {
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];

      if (querySnapshot.documents.length < documentsLimit) {
        hasMore = false;
      }

      querySnapshot.documents.forEach(
        (doc) {
          commentList.add(Comment.fromFireStore(doc));
        },
      );
      isLoading = false;
      notifyListeners();
    }
  }
}
