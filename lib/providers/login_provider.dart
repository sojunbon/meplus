import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/resources/repository.dart';

enum AppState { initial, authenticated, authenticating, unauthenticated }

class LoginProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  FirebaseUser _usertype;
  AppState _appState = AppState.initial;
  Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _repository = Repository();
  //final _financeValue = BehaviorSubject<String>();
  Future<String> getUserUID() => _repository.getUserUID();

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  AppState get appState => _appState;
  FirebaseUser get user => _user;
  FirebaseUser get usertype => _usertype;

  LoginProvider.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser == null) {
        _appState = AppState.unauthenticated;
      } else {
        _user = firebaseUser;
        _appState = AppState.authenticated;
      }

      notifyListeners();
    });
  }

  getData() async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    return Firestore.instance.collection('users').document(userId);
  }

  Future<bool> login(String email, String password) async {
    try {
      _appState = AppState.authenticating; //set current state to loading state.
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _appState = AppState.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Stream<DocumentSnapshot> userDoc(String userUID) =>
      _repository.userDoc(userUID);

  /*
  Future<void> setProfile(
      String name, String bankname, String bankaccount) async {
    String userUID = await getUserUID();

    return _repository.setProfile(userUID, name, bankname, bankaccount);
  }
  */

  Future<String> setUsertype() async {
    String usertype;
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .setData({'usertype': usertype});
    return usertype;
  }

  Future logout() async {
    await _auth.signOut();
    _appState = AppState.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

//------------------------------- ADD ON --------------------------------------
// GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  /*
  getProfileImage() {
    if (_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL,
          height: 100, width: 100);
    } else {
      return Icon(Icons.account_circle, size: 100);
    }
  }
  */

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  // Sign Out
  signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future convertUserWithEmail(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();

    final credential =
        EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  Future convertWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  }

  // GOOGLE
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

  // APPLE
  Future signInWithApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential _auth = result.credential;
        final OAuthProvider oAuthProvider =
            new OAuthProvider(providerId: "apple.com");

        final AuthCredential credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(_auth.identityToken),
          accessToken: String.fromCharCodes(_auth.authorizationCode),
        );

        await _firebaseAuth.signInWithCredential(credential);

        // update the user information
        if (_auth.fullName != null) {
          _firebaseAuth.currentUser().then((value) async {
            UserUpdateInfo user = UserUpdateInfo();
            user.displayName =
                "${_auth.fullName.givenName} ${_auth.fullName.familyName}";
            await value.updateProfile(user);
          });
        }

        break;

      case AuthorizationStatus.error:
        print("Sign In Failed ${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
        print("User Cancled");
        break;
    }
  }

  Future createUserWithPhone(String phone, BuildContext context) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _firebaseAuth
              .signInWithCredential(authCredential)
              .then((AuthResult result) {
            Navigator.of(context).pop(); // to pop the dialog box
            Navigator.of(context).pushReplacementNamed('/home');
          }).catchError((e) {
            return "error";
          });
        },
        verificationFailed: (AuthException exception) {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          final _codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("Enter Verification Code From Text Message"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[TextField(controller: _codeController)],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("submit"),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    var _credential = PhoneAuthProvider.getCredential(
                        verificationId: verificationId,
                        smsCode: _codeController.text.trim());
                    _firebaseAuth
                        .signInWithCredential(_credential)
                        .then((AuthResult result) {
                      Navigator.of(context).pop(); // to pop the dialog box
                      Navigator.of(context).pushReplacementNamed('/home');
                    }).catchError((e) {
                      return "error";
                    });
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
