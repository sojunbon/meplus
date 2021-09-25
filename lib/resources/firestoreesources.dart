import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreResources {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Stream<DocumentSnapshot> userFinanceDoc(String userUID) =>
  //    _firestore.collection("userFinance").document(userUID).snapshots();

  Stream<DocumentSnapshot> userDoc(String userUID) =>
      _firestore.collection("users").doc(userUID).snapshots();

  Future<void> setProfile(
          String userUID, String name, String bankname, String bankaccount) =>
      _firestore.collection("users").doc(userUID).set(
          {'name': name, 'bankname': bankname, 'bankaccount': bankaccount});

  Future<void> setUserBudget(String userUID, double budget) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .set({'budget': budget}, SetOptions(merge: true));

  Future<void> addNewExpense(String userUID, double expenseValue) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .collection("expenses")
      .doc()
      .set({'value': expenseValue, 'timestamp': FieldValue.serverTimestamp()});

  Stream<QuerySnapshot> expensesList(String userUID) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .collection("expenses")
      .orderBy('timestamp', descending: true)
      .snapshots();

  Stream<QuerySnapshot> lastExpense(String userUID) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .collection("expenses")
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots();
}
