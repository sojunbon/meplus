import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationResources {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChange => _firebaseAuth.authStateChanges();

  Future<String> getUserUID() async {
    final User user =
        _firebaseAuth.currentUser; //await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<int> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return 1;
    } on PlatformException catch (e) {
      print("Platform Exception: Authentication: " + e.toString());
      return -1;
    } catch (e) {
      print("Exception: Error: " + e.toString());
      return -2;
    }
  }

  Future<int> signUpWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await setUserDisplayName(authResult.user, displayName);
      return 1;
    } on PlatformException catch (e) {
      print("Platform Exception: Authentication: " + e.toString());
      return -1;
    } catch (e) {
      print("Exception: Authentication: " + e.toString());

      return -2;
    }
  }

  Future<void> setUserDisplayName(User user, String displayName) async {
    //UserUpdateInfo updateInfo = UserUpdateInfo();

    await user.updateProfile(displayName: displayName); //added this line
    //return _user(user);
    await user.reload();

    //updateInfo.displayName = displayName;
    //await user.updateProfile(updateInfo);
  }

  Future<void> get signOut async {
    _firebaseAuth.signOut();
//    _googleSignIn.signOut();
  }
}
