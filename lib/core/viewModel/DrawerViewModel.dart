import 'package:flutter/material.dart';
import 'package:guess_what/core/services/auth.dart';

class DrawerViewModel extends ChangeNotifier {
  AuthenticationServices _authentication = AuthenticationServices();

  DrawerViewModel({@required AuthenticationServices authentication})
      : _authentication = authentication;

  //Observable<User> get userProfile => _authentication.getUserprofile().asBroadcastStream();

  //Signn with facebook
  void facebookLoging() async {
    await _authentication.loginWithFacebooK();
  }

  //SingOut firebase user
  void signOut() {
    _authentication.singOut();
  }
}
