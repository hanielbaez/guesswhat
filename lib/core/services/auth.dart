//Flutter and Dart import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

//Self import
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/services/db.dart';

///User authentication from Firebase
class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseServices _dataBase;

  AuthenticationServices({DatabaseServices dataBase}) : _dataBase = dataBase;

  Observable<FirebaseUser> user() {
    return Observable(FirebaseAuth.instance.onAuthStateChanged);
  }

  AsObservableFuture<FirebaseUser> futureUser() {
    return Observable(FirebaseAuth.instance.onAuthStateChanged).single;
  }

  ///SignIn the user and set the firebase user
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
        requestingPermission();
        return user.user;
        break;
    }
    return null; //unreachable
  }

  ///Update user record at Firebase
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

  ///Getting the devices permission
  void requestingPermission() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.location,
      PermissionGroup.camera,
      PermissionGroup.mediaLibrary
    ]);
  }
}
