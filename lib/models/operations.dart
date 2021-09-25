import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebasePluginPlatform;
import 'package:collection/collection.dart';

Future<void> uploadingData(
    String _name, String _bankname, String _bankaccount) async {
  await FirebaseFirestore.instance.collection("users").add({
    'name': _name,
    'bankname': _bankname,
    'bankaccount': _bankaccount,
  });
}

Future<void> editProduct(bool uid, String id) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({"uid": !uid});
}

Future<void> deleteProduct(DocumentSnapshot doc) async {
  await FirebaseFirestore.instance.collection("users").doc(doc.id).delete();
}
