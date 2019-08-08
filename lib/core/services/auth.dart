import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseServices _dataBase;
  Observable<FirebaseUser> user; //Firebase user
  Observable<User> _profile; //User data in FireStore

  AuthenticationServices({DatabaseServices dataBase}) : _dataBase = dataBase {
    user = Observable(_auth.onAuthStateChanged);

    _profile = user.switchMap(
      (FirebaseUser user) {
        if (user != null) {
          print('User SINGIN');
          return _dataBase.getUser(user);
        } else {
          print('User SINGOUT');
          return null; //No user authenticated
        }
      },
    );
  }

  Observable<User> get profile => _profile;

  //SignIn the user and set the firebase user
  Future<FirebaseUser> loginWithFacebooK() async {
    var facebookLoging = FacebookLogin();
    var result = await facebookLoging
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print('Error: Facebook Login calcelled by user');
        break;
      case FacebookLoginStatus.error:
        print('Error: ${result.errorMessage}');
        break;
      case FacebookLoginStatus.loggedIn:
        print('Facebook Loging Succes');
        FacebookAccessToken myToken = result.accessToken;
        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: myToken.token);
        var user = await _auth.signInWithCredential(credential);

        updateUser(user.user);

        return user.user;
        break;
    }
    return null; //unreachable
  }

  //Update user record at Firebase
  void updateUser(FirebaseUser userData) {
    var user = User(
        uid: userData.uid,
        email: userData.email,
        displayName: userData.displayName,
        photoURL: userData.photoUrl,
        lastSeen: Timestamp.now());

    _dataBase.updateUserData(user);
  }

  void singOut() {
    _auth.signOut();
  }
}
