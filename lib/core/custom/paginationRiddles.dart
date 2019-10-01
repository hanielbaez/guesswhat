//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Selft import
import 'package:Tekel/core/model/riddle.dart';

class PaginationViewModel extends ChangeNotifier {
  final String countryCode;
  PaginationViewModel({this.countryCode = 'US'}) {
    getRiddles();
  }

  Firestore firestore = Firestore.instance;

  List<Riddle> riddlesList = []; // stores fetched products

  bool isLoading = false; // track if products fetching

  bool hasMore = true; // flag for more products available or not

  int documentLimit = 10; // documents to be fetched per request

  String category; //The type of riddle to be fetch, default (All)

  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched
  QuerySnapshot querySnapshot;

  getRiddles() async {
    if (hasMore == false) {
      print('No more data to fetch');
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
            .where('location.countryCode', isEqualTo: countryCode)
            .where('isRiddle', isEqualTo: true)
            .where('category', isEqualTo: category)
            .orderBy('createdAt', descending: true)
            .limit(documentLimit)
            .getDocuments();
      } else {
        querySnapshot = await firestore
            .collection('riddles')
            .where('location.countryCode', isEqualTo: countryCode)
            .where('isRiddle', isEqualTo: true)
            .where('category', isEqualTo: category)
            .orderBy('createdAt', descending: true)
            .startAfterDocument(lastDocument)
            .limit(documentLimit)
            .getDocuments();
      }
    } catch (e) {
      print('getRiddles: $e');
    }
    if (querySnapshot != null) {
      if (querySnapshot.documents.isNotEmpty) {
        lastDocument =
            querySnapshot?.documents[querySnapshot.documents.length - 1];

        if (querySnapshot.documents.length < documentLimit) {
          hasMore = false;
        }
      } else {
        print('Pagination: No more data to fetch');
      }

      querySnapshot.documents.forEach(
        (doc) {
          riddlesList.add(Riddle.fromFireStore(doc));
        },
      );
      isLoading = false;
      notifyListeners();
    }
  }

  selectCategory({String selectedCategory}) {
    category = selectedCategory;
    //Reset values
    riddlesList = [];
    lastDocument = null;
    hasMore = true;

    getRiddles();
  }
}

//? Code by: https://www.c-sharpcorner.com/article/pagination-in-flutter-using-firebase-cloud-firestore/
