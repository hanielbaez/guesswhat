import 'package:flutter/material.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:rxdart/rxdart.dart';

class DrawerViewModel extends ChangeNotifier {
  AuthenticationServices _authentication = AuthenticationServices();

  DrawerViewModel({@required AuthenticationServices authentication})
      : _authentication = authentication;

  Observable<User> get userProfile => _authentication.profile;

  //Signn with facebook
  void facebookLoging() async {
    await _authentication.loginWithFacebooK();
  }

  //SingOut firebase user
  void signOut() {
    _authentication.singOut();
  }
}
