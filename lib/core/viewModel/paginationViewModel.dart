//Flutter and Dart import
import 'package:Tekel/core/model/ridlle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationViewModel extends ChangeNotifier {
  //? Probably this pagination class can be improve by adding a stream

  Firestore firestore = Firestore.instance;

  List<Ridlle> ridlles = []; // stores fetched products

  bool isLoading = false; // track if products fetching

  bool hasMore = true; // flag for more products available or not

  int documentLimit = 20; // documents to be fetched per request

  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched

  getRidlles() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    Future.delayed(Duration.zero, () => notifyListeners());

    isLoading = true;

    QuerySnapshot querySnapshot;
    try {
      if (lastDocument == null) {
        querySnapshot = await firestore
            .collection('ridlles')
            .orderBy('creationDate', descending: true)
            .limit(documentLimit)
            .getDocuments();
      } else {
        querySnapshot = await firestore
            .collection('ridlles')
            .orderBy('creationDate', descending: true)
            .startAfterDocument(lastDocument)
            .limit(documentLimit)
            .getDocuments();
        print(1);
      }
    } catch (e) {
      print(e);
    }

    if (querySnapshot.documents.length < documentLimit) {
      hasMore = false;
      print('NO MORE DATA');
    } else {
      //! Error: RangeError (RangeError (index): Invalid value: Valid value range is empty: -1)
      lastDocument =
          querySnapshot?.documents[querySnapshot.documents.length - 1];
    }

    querySnapshot.documents.forEach((doc) {
      ridlles.add(Ridlle.fromFireStore(doc));
    });

    notifyListeners();
    isLoading = false;
  }
}

//? Code by: https://www.c-sharpcorner.com/article/pagination-in-flutter-using-firebase-cloud-firestore/
