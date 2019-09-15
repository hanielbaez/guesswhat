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
  Observable<FirebaseUser> userT; // firebase user
  Stream<User> profile; // custom user data in Firestore
  final Firestore _db = Firestore.instance;

  AuthenticationServices() {
    userT = Observable(_auth.onAuthStateChanged);

    profile = userT.switchMap(
      (FirebaseUser u) {
        if (u != null) {
          return _db
              .collection('users')
              .document(u.uid)
              .snapshots()
              .asBroadcastStream()
              .map(
                (snap) => User.fromFireStore(snap),
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
  Future<String> loginWithFacebook() async {
    try {
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
          FacebookAccessToken myToken = result.accessToken;
          AuthCredential credential =
              FacebookAuthProvider.getCredential(accessToken: myToken.token);
          await _auth.signInWithCredential(credential);

          requestingPermission();
          return 'Signed in Successfully';
          break;
      }
    } catch (e) {
      print(e.toString());
      return e.message.toString();
    }
    return null; //unreachable
  }

  Future<String> sigInWithGoogle() async {
    try {
      GoogleSignIn _googleSingIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await _googleSingIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);

      requestingPermission();
      return 'Signed in Successfully';
    } catch (e) {
      return e.message;
    }
  }

  void singOut() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  ///Getting the devices permission and save thse device token
  void requestingPermission() async {
    //Getting the device Toke
    saveDeviceToken();

    await PermissionHandler().requestPermissions([
      PermissionGroup.location,
      PermissionGroup.camera,
      PermissionGroup.storage
    ]);
  }
}
