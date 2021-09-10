import 'package:intl/intl.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:ntp/ntp.dart';

queryValues() async {
  double tempTotal = 0;
  String sumtotal;
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  Firestore.instance
      .collection('moneytrans')
      .where("uid", isEqualTo: user.uid)
      .where("active", isEqualTo: true)
      .where("payment", isEqualTo: false)
      .snapshots()
      .listen((snapshot) {
    tempTotal =
        snapshot.documents.fold(0, (tot, doc) => tot + doc.data['amount']);
    sumtotal = tempTotal.toString();

    return sumtotal;
  });
}

Future<void> generateData(
    BuildContext context, String docid, DocumentSnapshot documents) async {
  var count;
  var amounta;
  var amountb;
  var amountc;
  var amountd;
  var percenta;
  var percentb;
  var percentc;
  var percentd;
  var perday;
  var fcount;
  var fcount_refer;
  var fcount_percent;
  bool recount;
  var percentcal;
  double calpay;
  bool paym;

  double tempTotal = 0;
  String sumtotal;
  var getdocid = docid;
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  count = 0;
  amounta = 0;
  amountb = 0;
  amountc = 0;
  amountd = 0;
  percenta = 0;
  percentb = 0;
  percentc = 0;
  percentd = 0;
  perday = 0;
  fcount = 0;
  fcount_refer = 0;
  fcount_percent = 0;
  calpay = 0;
  percentcal = 0;

  final db = Firestore.instance;
  await db
      .collection('conftab')
      .document('conf')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    count = documentSnapshot.data['count'];
    amounta = documentSnapshot.data['amounta'];
    amountb = documentSnapshot.data['amountb'];
    amountc = documentSnapshot.data['amountc'];
    amountd = documentSnapshot.data['amountd'];
    percenta = documentSnapshot.data['percenta'];
    percentb = documentSnapshot.data['percentb'];
    percentc = documentSnapshot.data['percentc'];
    percentd = documentSnapshot.data['percentd'];
    perday = documentSnapshot.data['perday'];
    fcount = documentSnapshot.data['fcount'];
    fcount_refer = documentSnapshot.data['fcount_refer'];
    fcount_percent = documentSnapshot.data['fcount_percent'];
  });

  var getamount = documents['amount'];
  if (getamount >= amounta && getamount < amountb) {
    percentcal = percenta;
  } else if (getamount >= amountb && getamount < amountc) {
    percentcal = percentb;
  } else if (getamount >= amountc && getamount < amountd) {
    percentcal = percentc;
  } else if (getamount >= amountd) {
    percentcal = percentd;
  }

  calpay = (getamount * percentcal) / 100;

  DateTime serverdate = await NTP.now();

  // --- คำนวณวัน ---
  for (int i = 1; i <= count; i++) {
    var today = serverdate; // DateTime.now();
    var fiftyDaysFromNow = today.add(Duration(days: i));

    var toooday = DateTime.now();
    var newday = toooday.add(Duration(days: i));

    String formatdate = DateFormat('dd/MM/yyyy').format(fiftyDaysFromNow);
    String formatdatex = DateFormat('ddMMyyyy').format(fiftyDaysFromNow);
    double convertdate = double.parse(formatdatex);

    //DateTime getnewday = DateTime(newday.year, newday.month, newday.day);
    addPaymentItem(
        context,
        {
          "name": documents['name'],
          "uid": documents['uid'],
          "amount": documents['amount'],
          "calpayment": calpay,
          "bankname": documents['bankname'],
          "bankaccount": documents['bankaccount'],
          "paytype": 3, // ลงทุน
          "payment": false,
          "active": false,
          "createdate": FieldValue.serverTimestamp(),
          "caldate": formatdate,
          "docid": docid,
          "sumtotal": 0,
          "tradecount": i,
          "server_date": newday,
          "date_query": convertdate, // for query date
        },
        docid,
        i);
  }
}

Future<void> addPaymentItem(
  BuildContext context,
  Map<String, dynamic> data,
  String docid,
  int countdoc,
  //BuildContext context,
  //Map<String, dynamic> data,
  //String documentName,
) {
  DateTime now = DateTime.now();
  String txttime = (now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString());
  //String autodoc = docid + txttime + countdoc.toString();
  String autodoc = docid + 'docid' + countdoc.toString();

  //double getcount = double.parse(count);
  //for (int i = 0; i < getcount; i++) {

  return Firestore.instance
      .collection("trademoney")
      .document(autodoc)
      .setData(data)
      .then((returnData) {
    //updateTotal(data['uid']);

    //showMessageBox(context, "Success", "", actions: [dismissButton(context)]);
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
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
