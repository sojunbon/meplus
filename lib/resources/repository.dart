import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/resources/authentication_resources.dart';
import 'package:meplus/resources/firestoreesources.dart';

class Repository {
  final _authResources = AuthenticationResources();
  final _userResources = FirestoreResources();

  /// Authentication

  Stream<FirebaseUser> get onAuthStateChange =>
      _authResources.onAuthStateChange;
  Future<int> loginWithEmailAndPassword(String email, String password) =>
      _authResources.loginWithEmailAndPassword(email, password);
  Future<int> signUpWithEmailAndPassword(
          String email, String password, String displayName) =>
      _authResources.signUpWithEmailAndPassword(email, password, displayName);
  Future<void> signOut() => _authResources.signOut;
  Future<String> getUserUID() => _authResources.getUserUID();

  // User Finance - Firestore
  Stream<DocumentSnapshot> userDoc(String userUID) =>
      _userResources.userDoc(userUID);
  Future<void> setProfile(
          String userUID, String name, String bankname, String bankaccount) =>
      _userResources.setProfile(userUID, name, bankname, bankaccount);

  /*
  Future<void> addNewExpense(String userUID, double expenseValue) =>
      _userFinanceResources.addNewExpense(userUID, expenseValue);
  Stream<QuerySnapshot> expensesList(String userUID) =>
      _userFinanceResources.expensesList(userUID);
  Stream<QuerySnapshot> lastExpense(String userUID) =>
      _userFinanceResources.lastExpense(userUID);
  */
}
