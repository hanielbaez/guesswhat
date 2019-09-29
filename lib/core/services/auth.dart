//Flutter and Dart import
import 'package:Tekel/core/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

//Self import
import 'package:Tekel/core/custom/customGetToken.dart';

///User authentication from Firebase
class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Observable<FirebaseUser> firebaseUser; // firebase user
  Stream<User> profile; // custom user data in Firestore
  final Firestore _db = Firestore.instance;

  AuthenticationServices() {
    firebaseUser = Observable(_auth.onAuthStateChanged).asBroadcastStream();

    profile = firebaseUser.switchMap(
      (FirebaseUser u) {
        if (u != null) {
          return _db
              .collection('users')
              .document(u.uid)
              .snapshots()
              .asBroadcastStream()
              .map(
                (snap) => snap.data != null ? User.fromFireStore(snap) : null,
              );
        } else {
          return Observable.just(null);
        }
      },
    );
  }

  Observable<FirebaseUser> user() {
    return Observable(FirebaseAuth.instance.onAuthStateChanged);
  }

  AsObservableFuture<FirebaseUser> futureUser() {
    return Observable(FirebaseAuth.instance.onAuthStateChanged).single;
  }

  ///SignIn the user with Facebook and set the firebase user
  Future<bool> loginWithFacebook() async {
    try {
      var facebookLoging = FacebookLogin();
      var result = await facebookLoging
          .logInWithReadPermissions(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.cancelledByUser:
          print('Error: Facebook Login calcelled by user');
          return false;
          break;
        case FacebookLoginStatus.error:
          print('Error: ${result.errorMessage}');
          return false;
          break;
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken myToken = result.accessToken;
          AuthCredential credential =
              FacebookAuthProvider.getCredential(accessToken: myToken.token);
          await _auth.signInWithCredential(credential);
          requestingPermission();
          return true;
          break;
      }
    } catch (e) {
      print('loginWithFacebook: $e');
      return false;
    }
    return false; //unreachable
  }

  Future<bool> sigInWithGoogle() async {
    try {
      GoogleSignIn _googleSingIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await _googleSingIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);

      await requestingPermission();
      return true;
    } catch (e) {
      print('sigInWithGoogle $e');
      return false;
    }
  }

  Future<bool> singOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('singOut: $e');
      return false;
    }
  }

  ///Getting the devices permission and save thse device token
  Future requestingPermission() async {
    List _permissionToAsk = [];
    List _permissionList = [
      PermissionGroup.location,
      PermissionGroup.camera,
      PermissionGroup.storage
    ];

    //Getting the device Toke
    saveDeviceToken();

    //Check all permission status
    _permissionList.forEach((permission) async {
      var status = await PermissionHandler().checkPermissionStatus(permission);
      if (status != PermissionStatus.granted) {
        _permissionToAsk.add(permission);
      }
    });

    if (_permissionToAsk.isNotEmpty)
      await PermissionHandler().requestPermissions(_permissionList);
  }
}
