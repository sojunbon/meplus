import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:ntp/ntp.dart';
import 'package:meplus/components/show_notification.dart';

// ----- Add moneytrans PACKAGE -------
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
  return Firestore.instance
      .collection("moneytrans")
      .document(autodoc)
      //.collection("users")
      //.document()
      //.document(autodoc)
      .setData(data)
      .then((returnData) {
    showMessageBox(context, "Success", "", actions: [dismissButton(context)]);
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}

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
  double percentcal;
  double calpay;
  bool paym;

  String phoneUserPrimaryn;
  String phoneUserRefern;
  String userid_refern;
  String bankname_refern;
  String bankacctn;
  String phoneUsern;
  String namexxn;

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
    percentcal = double.parse(percenta);
  } else if (getamount >= amountb && getamount < amountc) {
    percentcal = double.parse(percentb);
  } else if (getamount >= amountc && getamount < amountd) {
    percentcal = double.parse(percentc);
  } else if (getamount >= amountd) {
    percentcal = double.parse(percentd);
  }

  double txamt = getamount;
  //double.parse(getamount);
  //double fxamt = double.parse(percentcal);
  if (txamt != 0 && percentcal != 0) {
    calpay = (txamt * percentcal) / 100;
    //calpay = (getamount * fcount_refer) / 100;
  } else {
    calpay = 0;
  }

  //calpay = (getamount * percentcal) / 100;

  DateTime serverdate = await NTP.now();
  String getPhoneNewn = documents['mobile'];

  QuerySnapshot querySnapshotuser =
      await Firestore.instance.collection("referfriend").getDocuments();
  for (int i = 0; i < querySnapshotuser.documents.length; i++) {
    var userphongapn = querySnapshotuser.documents[i];
    phoneUserPrimaryn = userphongapn.data["mobile"].toString();

    if (phoneUserPrimaryn == getPhoneNewn) {
      phoneUsern = userphongapn.data["mobile"].toString();
      phoneUserRefern = userphongapn.data["mobile_refer"].toString();
      userid_refern = userphongapn.data["uid_refer"].toString();
      bankname_refern = userphongapn.data["bankname"].toString();
      bankacctn = userphongapn.data["bankaccount"].toString();
      namexxn = userphongapn.data["name"].toString();
    } else {
      phoneUsern = "";
    }
    print(userphongapn.documentID);
  }
  int count_con = int.parse(count);
  int perday_con = int.parse(perday);
  // --- คำนวณวัน ---
  for (int ii = 1; ii <= count_con; ii++) {
    var today = serverdate; // DateTime.now();
    int newdaycal = ii * perday_con; //perday;
    var fiftyDaysFromNow = today.add(Duration(days: newdaycal));

    var tooodayx = DateTime.now();
    var newdayx = tooodayx.add(Duration(days: ii));

    String formatdatex = DateFormat('dd/MM/yyyy').format(fiftyDaysFromNow);
    String formatdatexxx = DateFormat('ddMMyyyy').format(fiftyDaysFromNow);
    double convertdatex = double.parse(formatdatexxx);

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
          "caldate": formatdatex,
          "docid": docid,
          "sumtotal": 0,
          "tradecount": ii,
          "server_date": newdayx,
          "date_query": convertdatex, // for query date
          "mobile": documents['mobile'],
          "desc": "ลงทุน",
        },
        docid,
        ii);
  }
}

Future<void> generateReferFriend(BuildContext context, String docid,
    String userid, DocumentSnapshot documents) async {
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
  double percentcal;
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

  String phoneUserPrimary;
  String phoneUserRefer;
  String userid_refer;
  String bankname_refer;
  String bankacct;
  String phoneUser;
  String namexx;

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
    // นับครั้ง refer friend ครบกี่ครั้ง
    fcount = documentSnapshot.data['fcount'];
    // percent ที่ได้รับ ครบตามการ  count
    fcount_refer = documentSnapshot.data['fcount_refer'];
    // percent ที่ได้รับทุกการลงทุน
    fcount_percent = documentSnapshot.data['fcount_percent'];
  });

  String getPhoneNew =
      documents['mobile'].toString(); // user create new package

  QuerySnapshot querySnapshotuser =
      await Firestore.instance.collection("referfriend").getDocuments();
  for (int i = 0; i < querySnapshotuser.documents.length; i++) {
    var userphongap = querySnapshotuser.documents[i];
    phoneUserPrimary = userphongap.data["mobile"];

    if (phoneUserPrimary == getPhoneNew) {
      phoneUser = userphongap.data["mobile"].toString();
      phoneUserRefer = userphongap.data["mobile_refer"].toString();
      userid_refer = userphongap.data["uid_refer"].toString();
      bankname_refer = userphongap.data["bankname"].toString();
      bankacct = userphongap.data["bankaccount"].toString();
      namexx = userphongap.data["name"].toString();
    } else {
      phoneUser = "";
    }
    print(userphongap.documentID);
  }

  // count moneytrans
  int countReferFriend = 1;
  int ct = 0;
  QuerySnapshot querycount =
      await Firestore.instance.collection("moneytrans").getDocuments();
  for (int i = 1; i < querycount.documents.length; i++) {
    var getcount = querycount.documents[i];
    phoneUserPrimary = getcount.data["mobile"].toString();

    if (phoneUserPrimary == getPhoneNew) {
      ct++;
      countReferFriend = ct;
    } else {
      phoneUser = "";
    }
    print(getcount.documentID);
  }

  var getamount = documents['amount'];
  DateTime serverdate = await NTP.now();
  //var today = serverdate; // DateTime.now();
  //var fiftyDaysFromNow = today.add(Duration(days: i));
  int d = 1;
  var toooday = DateTime.now();
  var newday = toooday.add(Duration(days: d));

  String formatdate = DateFormat('dd/MM/yyyy').format(serverdate);
  String formatdatex = DateFormat('ddMMyyyy').format(serverdate);
  double convertdate = double.parse(formatdatex);

  double tamt = getamount; //double.parse(getamount);
  double famt = double.parse(fcount_refer);

  if (tamt != 0 && famt != 0) {
    calpay = (tamt * famt) / 100;
    //calpay = (getamount * fcount_refer) / 100;
  } else {
    calpay = 0;
  }

  if (userid != userid_refer && userid_refer != null) {
    if (countReferFriend <= fcount) {
      //calpay = (getamount * fcount_refer) / 100;

      int g = 0;
      g++;

      addPaymentItemRefer(
          context,
          {
            "name": namexx,
            "uid": userid_refer,
            "amount": documents['amount'],
            "calpayment": calpay,
            "bankname": documents['bankname'],
            "bankaccount": documents['bankaccount'],
            "paytype": 4, // referfriend
            "payment": false,
            "active": false,
            "createdate": FieldValue.serverTimestamp(),
            "caldate": formatdate,
            "docid": docid,
            "sumtotal": 0,
            "tradecount": g,
            "server_date": newday,
            "date_query": convertdate, // for query date
            "mobile": phoneUserRefer,
            "desc": "แนะนำเพื่อน",
          },
          docid,
          g);
    } else if (countReferFriend > fcount) {
      //calpay = (getamount * fcount_percent) / 100;
      int g = 0;
      g++;
      addPaymentItemRefer(
          context,
          {
            "name": namexx,
            "uid": userid_refer,
            "amount": documents['amount'],
            "calpayment": calpay,
            "bankname": documents['bankname'],
            "bankaccount": documents['bankaccount'],
            "paytype": 4, // referfriend
            "payment": false,
            "active": false,
            "createdate": FieldValue.serverTimestamp(),
            "caldate": formatdate,
            "docid": docid,
            "sumtotal": 0,
            "tradecount": g,
            "server_date": newday,
            "date_query": convertdate, // for query date
            "mobile": phoneUserRefer,
            "desc": "แนะนำเพื่อน",
          },
          docid,
          g);
    }
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

Future<void> addPaymentItemRefer(
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
  String autodoc = docid + 'docid' + countdoc.toString() + 'refer';

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
