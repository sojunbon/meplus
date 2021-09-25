import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:flutter/material.dart';
import 'package:meplus/providers/logger_service.dart';

Future<void> addReferFriend(
    //BuildContext context, Map<String, dynamic> data, String documentName) {
    BuildContext context,
    Map<String, dynamic> data) async {
  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('kk:mm:ss').format(now);
  String txttime = (now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString());
  // String autodoc = documentName + txttime;

  String getmobilephone = data['mobile'];
  String checkmobile;
  String checkmobile_dis;

  // final db = Firestore.instance;
  //await db
  //   .collection('conftab')
  //   .document('conf')
  //   .get()
  //   .then((DocumentSnapshot documentSnapshot) {

  return FirebaseFirestore.instance
      .collection("referfriend")
      .doc(getmobilephone)
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

Future<void> checkPhoneExist(
    BuildContext context, Map<String, dynamic> data) async {
  DateTime now = DateTime.now();
  String txttime = (now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString());

  String getmobilephone = data['mobile'];
  String checkmobile;
  String checkmobile_dis;

  return FirebaseFirestore.instance
      .collection("phonecheck")
      .doc(getmobilephone)
      .set(data)
      .then((returnData) {
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}

/*
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

  return Firestore.instance
      .collection("users")
      .document(documentName)
      .collection("moneytrans")
      .document()
      .setData(data)
      .then((returnData) {
    showMessageBox(context, "Success", "", actions: [dismissButton(context)]);
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}
*/

/*
import 'package:intl/intl.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:ntp/ntp.dart';

Future<void> generateReferFriend(String getphone, String getrefer) async {
  // BuildContext context,
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

  String mobile_refer;
  String uid_refer;

  double tempTotal = 0;
  String sumtotal;
  //var getdocid = docid;
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

  // --- check mobile refer friend ---
  Firestore.instance
      .collection('users')
      .where("mobile", isEqualTo: getrefer)
      .snapshots()
      .listen((snapshot) {
    snapshot.documents.forEach((result) {
      mobile_refer = result.data['mobile'];
      uid_refer = result.data['uid'];
    });
  });

  if (mobile_refer != null) {
    DateTime serverdate = await NTP.now();
    // var today = serverdate; // DateTime.now();
    // var fiftyDaysFromNow = today.add(Duration(days: i));

    var toooday = DateTime.now();
    String formatdatex = DateFormat('ddMMyyyy').format(serverdate);
    double convertdate = double.parse(formatdatex);
    addRefer(
      //context,
      {
        //"uid": getuid,
        "mobile": getphone,
        "uid_rfer": uid_refer,
        "mobile_refer": getrefer,
        "paytype": 4, // แนะนำเพื่อน
        "payment": false,
        "active": false,
        "createdate": FieldValue.serverTimestamp(),
        "date_query": convertdate, // for query date
      },
    );
    // getuid);
  }
}

Future<void> addRefer(
  //BuildContext context,
  Map<String, dynamic> data,
  //String docid,
  //int countdoc,
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

  //String autodoc = docid + 'docid' + txttime;
  //countdoc.toString();

  return Firestore.instance
      .collection("referfriend")
      .document()
      .setData(data)
      .then((returnData) {
    logger.i("setData success");
  }).catchError((e) {
    logger.e(e);
  });
}
*/
/*
class Referfriend with ChangeNotifier {
  Future checkMobile(String mobile) async {
    //final FirebaseAuth _auth = FirebaseAuth.instance;
    String getmobile;

    Firestore.instance
        .collection('users')
        .where("mobile", isEqualTo: mobile)
        .snapshots()
        .listen((snapshot) {
      snapshot.documents.forEach((result) {
        //getmobile = result.data('mobile');
        getmobile = result.data['mobile'];
        return getmobile;
      });
    });
  }
}
*/

/*
class Referfriend_control {
  //void checkPhone(String mobile) {
  //checkPhone<String>(String mobile, void Function(String) callback) {
  checkPhone<String>(String mobile) {
    String getmobile;

    Firestore.instance
        .collection('users')
        .where("mobile", isEqualTo: mobile)
        .snapshots()
        .listen((snapshot) {
      snapshot.documents.forEach((result) {
        //getmobile = result.data('mobile');
        getmobile = result.data['mobile'];
        return getmobile;
      });
    });
  }
}
*/
