import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadingData(
    String _name, String _bankname, String _bankaccount) async {
  await Firestore.instance.collection("users").add({
    'name': _name,
    'bankname': _bankname,
    'bankaccount': _bankaccount,
  });
}

Future<void> editProduct(bool uid, String id) async {
  await Firestore.instance
      .collection("users")
      .document(id)
      .updateData({"uid": !uid});
}

Future<void> deleteProduct(DocumentSnapshot doc) async {
  await Firestore.instance
      .collection("users")
      .document(doc.documentID)
      .delete();
}
