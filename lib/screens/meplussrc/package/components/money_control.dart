import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meplus/providers/logger_service.dart';

void generateData(
    BuildContext context, String docid, DocumentSnapshot documents) {
  var attendanceCollection = Firestore.instance
      .collection('moneytrans')
      .document(docid)
      .collection(docid);
  var documentId = docid.toString();
  //document["name"].toString().toLowerCase();
  var attendanceReference = attendanceCollection.document(documentId);
  //return FirestoreListView(documents: snapshot.data.documents);

  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(documents.reference);
    await transaction.update(snapshot.reference, {"active": context});
    //await updateTotal(snapshot.data['uid']);
  });
}

void showNotification(BuildContext context,
    {AlertDialog alertContent, Stack stackContent}) async {
  try {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertContent == null ? stackContent : alertContent;
        });
  } catch (e) {
    logger.e(e.toString());
    return null;
  }
}

void showMessageBox(BuildContext context, String titleText, String contentText,
    {List<Widget> actions}) async {
  try {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(titleText),
            content: Text(contentText),
            actions: actions,
          );
        });
  } catch (e) {
    logger.e(e.toString());
    return null;
  }
}

RaisedButton dismissButton(BuildContext context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text("OK"),
  );
}
