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

queryValues() async {
  double tempTotal = 0;
  String sumtotal;
  User user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance
      .collection('moneytrans')
      .where("uid", isEqualTo: user.uid)
      .where("active", isEqualTo: true)
      .where("payment", isEqualTo: false)
      .snapshots()
      .listen((snapshot) {
    tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + doc['amount']);
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
  User user = FirebaseAuth.instance.currentUser;

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

  final db = FirebaseFirestore.instance;
  await db
      .collection('conftab')
      .doc('conf')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    count = documentSnapshot['count'];
    amounta = documentSnapshot['amounta'];
    amountb = documentSnapshot['amountb'];
    amountc = documentSnapshot['amountc'];
    amountd = documentSnapshot['amountd'];
    percenta = documentSnapshot['percenta'];
    percentb = documentSnapshot['percentb'];
    percentc = documentSnapshot['percentc'];
    percentd = documentSnapshot['percentd'];
    perday = documentSnapshot['perday'];
    fcount = documentSnapshot['fcount'];
    fcount_refer = documentSnapshot['fcount_refer'];
    fcount_percent = documentSnapshot['fcount_percent'];
  });

  var getamount = documents['amount'];
  if (getamount >= double.parse(amounta) && getamount < double.parse(amountb)) {
    percentcal = double.parse(percenta);
  } else if (getamount >= double.parse(amountb) &&
      getamount < double.parse(amountc)) {
    percentcal = double.parse(percentb);
  } else if (getamount >= double.parse(amountc) &&
      getamount < double.parse(amountd)) {
    percentcal = double.parse(percentc);
  } else if (getamount >= double.parse(amountd)) {
    percentcal = double.parse(percentd);
  }

  double txamt = getamount;

  double getperday = double.parse(perday);
  //double.parse(getamount);
  //double fxamt = double.parse(percentcal);
  if (getamount != 0 && percentcal != 0) {
    calpay = ((txamt * percentcal) / 100) * getperday;
    //calpay = (getamount * fcount_refer) / 100;
  } else {
    calpay = 0;
  }

  //calpay = (getamount * percentcal) / 100;

  DateTime serverdate = await NTP.now();
  String getPhoneNewn = documents['mobile'];

  QuerySnapshot querySnapshotuser =
      await FirebaseFirestore.instance.collection("referfriend").get();
  for (int i = 0; i < querySnapshotuser.docs.length; i++) {
    var userphongapn = querySnapshotuser.docs[i];
    phoneUserPrimaryn = userphongapn["mobile"].toString();

    if (phoneUserPrimaryn == getPhoneNewn) {
      phoneUsern = userphongapn["mobile"].toString();
      phoneUserRefern = userphongapn["mobile_refer"].toString();
      userid_refern = userphongapn["uid_refer"].toString();
      bankname_refern = userphongapn["bankname"].toString();
      bankacctn = userphongapn["bankaccount"].toString();
      namexxn = userphongapn["name"].toString();
    } else {
      phoneUsern = "";
    }
    print(userphongapn.id);
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

    String genday = DateFormat('dd').format(fiftyDaysFromNow);
    String genmth = DateFormat('MM').format(fiftyDaysFromNow);
    String genyear = DateFormat('yyyy').format(fiftyDaysFromNow);

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
          "genday": genday,
          "genmth": genmth,
          "genyear": genyear,
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
  User user = FirebaseAuth.instance.currentUser;

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

  final db = FirebaseFirestore.instance;
  await db
      .collection('conftab')
      .doc('conf')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    count = documentSnapshot['count'];
    amounta = documentSnapshot['amounta'];
    amountb = documentSnapshot['amountb'];
    amountc = documentSnapshot['amountc'];
    amountd = documentSnapshot['amountd'];
    percenta = documentSnapshot['percenta'];
    percentb = documentSnapshot['percentb'];
    percentc = documentSnapshot['percentc'];
    percentd = documentSnapshot['percentd'];
    perday = documentSnapshot['perday'];
    // นับครั้ง refer friend ครบกี่ครั้ง
    fcount = documentSnapshot['fcount'];
    // percent ที่ได้รับ ครบตามการ  count
    fcount_refer = documentSnapshot['fcount_refer'];
    // percent ที่ได้รับทุกการลงทุน
    fcount_percent = documentSnapshot['fcount_percent'];
  });

  String getPhoneNew =
      documents['mobile'].toString(); // user create new package

  QuerySnapshot querySnapshotuser =
      await FirebaseFirestore.instance.collection("referfriend").get();
  for (int i = 0; i < querySnapshotuser.docs.length; i++) {
    var userphongap = querySnapshotuser.docs[i];
    phoneUserPrimary = userphongap["mobile"];

    if (phoneUserPrimary == getPhoneNew) {
      phoneUser = userphongap["mobile"].toString();
      phoneUserRefer = userphongap["mobile_refer"].toString();
      userid_refer = userphongap["uid_refer"].toString();
      bankname_refer = userphongap["bankname"].toString();
      bankacct = userphongap["bankaccount"].toString();
      namexx = userphongap["name"].toString();
    } else {
      phoneUser = "";
    }
    print(userphongap.id);
  }

  // count moneytrans
  int countReferFriend = 1;
  int ct = 0;
  QuerySnapshot querycount =
      await FirebaseFirestore.instance.collection("moneytrans").get();
  for (int i = 1; i < querycount.docs.length; i++) {
    var getcount = querycount.docs[i];
    phoneUserPrimary = getcount["mobile"].toString();

    if (phoneUserPrimary == getPhoneNew) {
      ct++;
      countReferFriend = ct;
    } else {
      phoneUser = "";
    }
    print(getcount.id);
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

  String genday = DateFormat('dd').format(serverdate);
  String genmth = DateFormat('MM').format(serverdate);
  String genyear = DateFormat('yyyy').format(serverdate);

  double tamt = getamount; //double.parse(getamount);
  double famt = double.parse(fcount_refer);

  if (tamt != 0 && famt != 0) {
    calpay = (tamt * famt) / 100;
    //calpay = (getamount * fcount_refer) / 100;
  } else {
    calpay = 0;
  }

  int con_fcount = int.parse(fcount);

  if (userid != userid_refer && userid_refer != null) {
    if (countReferFriend <= con_fcount) {
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
            "genday": genday,
            "genmth": genmth,
            "genyear": genyear,
          },
          docid,
          g);
    } else if (countReferFriend > con_fcount) {
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
            "genday": genday,
            "genmth": genmth,
            "genyear": genyear,
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

  return FirebaseFirestore.instance
      .collection("trademoney")
      .doc(autodoc)
      .set(data)
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

  return FirebaseFirestore.instance
      .collection("trademoney")
      .doc(autodoc)
      .set(data)
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
