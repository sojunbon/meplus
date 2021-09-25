import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:flutter/material.dart';

import 'logger_service.dart';

Future<void> addMoneyItem(
    BuildContext context, Map<String, dynamic> data, String documentName) {
  //var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");

  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('kk:mm:ss').format(now);
  String txttime = (now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString());
  String autodoc = documentName + txttime;
  return FirebaseFirestore.instance
      .collection("moneytrans")
      .doc(autodoc)
      //.collection("users")
      //.document()
      //.document(autodoc)
      .set(data)
      .then((returnData) {
    showMessageBox(context, "Success", "", actions: [dismissButton(context)]);
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}

Future<void> addReferFriend(
    //BuildContext context, Map<String, dynamic> data, String documentName) {
    Map<String, dynamic> data) {
  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('kk:mm:ss').format(now);
  String txttime = (now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString());
  // String autodoc = documentName + txttime;
  return FirebaseFirestore.instance
      .collection("referfriend")
      .doc()
      //.collection("users")
      //.document()
      //.document(autodoc)
      .set(data)
      .then((returnData) {
    //  showMessageBox(context, "Success", "", actions: [dismissButton(context)]);
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}

Future<void> addPayMoneyItem(
    BuildContext context, Map<String, dynamic> data, String documentName) {
  //var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");

  DateTime now = DateTime.now();
  String txttime = (now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString());
  String autodoc = documentName + txttime;

  return FirebaseFirestore.instance
      .collection("users")
      .doc(documentName)
      .collection("moneytrans")
      .doc()
      .set(data)
      .then((returnData) {
    showMessageBox(context, "Success", "", actions: [dismissButton(context)]);
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}
