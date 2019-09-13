//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Selft import
import 'package:Tekel/core/model/riddle.dart';

class PaginationViewModel extends ChangeNotifier {
  //? Probably this pagination class can be improve by adding a stream

  Firestore firestore = Firestore.instance;

  List<Riddle> riddles = []; // stores fetched products

  bool isLoading = false; // track if products fetching

  bool hasMore = true; // flag for more products available or not

  int index = 0; // index for Swiper

  int documentLimit = 20; // documents to be fetched per request

  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched

  //TODO: Refactopr this function
  getRiddles() async {
    /* if (!hasMore) {
      print('null hasMore');
      return null;
    }
    if (isLoading) {
      print('null');
      return null;
    }
    Future.delayed(Duration.zero, () => notifyListeners()); */

    isLoading = true;

    QuerySnapshot querySnapshot;
    try {
      if (lastDocument == null) {
        querySnapshot = await firestore
            .collection('riddles')
            .where('location.countryCode', isEqualTo: 'DO')
            .orderBy('createdAt', descending: true)
            .limit(documentLimit)
            .getDocuments();
      } else {
        querySnapshot = await firestore
            .collection('riddles')
            .where('location.countryCode', isEqualTo: 'DO')
            .orderBy('createdAt', descending: true)
            .startAfterDocument(lastDocument)
            .limit(documentLimit)
            .getDocuments();
        index = riddles.length - 1;
      }
    } catch (e) {
      print(e);
    }
    if (querySnapshot != null) {
      if (querySnapshot.documents.length < documentLimit) {
        hasMore = false;
      } else {
        lastDocument =
            querySnapshot?.documents[querySnapshot.documents.length - 1];
      }

      querySnapshot.documents.forEach((doc) {
        riddles.add(Riddle.fromFireStore(doc));
      });
    }

    //notifyListeners();
    isLoading = false;
    return riddles;
  }
}

//? Code by: https://www.c-sharpcorner.com/article/pagination-in-flutter-using-firebase-cloud-firestore/
