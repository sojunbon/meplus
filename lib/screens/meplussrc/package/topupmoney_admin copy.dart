import 'package:meplus/app_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/providers/add_money_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:nice_button/nice_button.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:provider/provider.dart';

class Topupmoneyup extends StatefulWidget {
  @override
  _Topupmoneyup createState() => _Topupmoneyup();
}

class _Topupmoneyup extends State<Topupmoneyup> {
  FirebaseUser currentUser;
  String userID = "";
  bool isSwitch = false;
  bool dynamicSwitch;
  var sumtotal;
  var sumpayment;

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    //_active = TextEditingController(text: "");
    //_password = TextEditingController(text: "");
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userID = user.uid;
      });
    });
    queryValues();
    queryPayment();
  }

  handleSwitch(bool value, String docid, DocumentSnapshot documents) {
    setState(() {
      isSwitch = value;
      dynamicSwitch = value;

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
        await transaction.update(snapshot.reference, {"active": isSwitch});
        await updateTotal(snapshot.data['uid']);
      });
    });
  }

  queryValues() async {
    double tempTotal = 0;
    sumtotal = 0;
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

  queryPayment() async {
    double tempTotal = 0;
    sumpayment = 0;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('moneytrans')
        .where("uid", isEqualTo: user.uid)
        .where("active", isEqualTo: true)
        .where("payment", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal =
          snapshot.documents.fold(0, (tot, doc) => tot + doc.data['amount']);
      sumpayment = tempTotal.toString();

      return sumpayment;
    });
  }

  // update ยอด sumtotal และ sumpayment ไปที่ users table เพื่อแยกระหว่างยอด trade payment
  Future<void> updateTotal(String docid) async {
    var postRef = Firestore.instance.collection("users").document(docid);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.get(postRef).then((res) async {
        transaction.update(postRef, {
          'sumtotal': sumtotal,
          'paymentamt': sumpayment,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var gettype;
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการ ฝาก/ถอน"),
        backgroundColor: Colors.grey,
      ),
      //body: BookList(),

      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('moneytrans')
            .where("active", isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return new ListView(
                padding: EdgeInsets.only(bottom: 80),
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  if (document['paytype'] == 1) {
                    gettype = 'ฝากเงิน';
                  } else {
                    gettype = 'ถอนเงิน';
                  }
                  // List.generate(document.data.length, (index) {
                  var attendanceCollection = Firestore.instance
                      .collection('moneytrans')
                      .document(document.documentID)
                      .collection(document.documentID);
                  var documentId = document["name"].toString().toLowerCase();
                  var attendanceReference =
                      attendanceCollection.document(documentId);
                  //children: List.generate(document.data.length, (index) {
                  //String namedis = document[index].data['name'].toString();
                  dynamicSwitch = document["active"];
                  // snapshot.data.active;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("ชื่อ : " +
                                  document['name'].toString() +
                                  " " +
                                  gettype +
                                  " : " +
                                  document['amount'].toString()),
                            ),
                            Expanded(
                              //child: TextField(
                              child: Text("ชื่อธนาคาร : " +
                                  ' ' +
                                  document['bankname'] +
                                  ' ' +
                                  document['bankaccount']),
                            ),
                          ],
                        ),

                        /*
                        title: new Text("ชื่อ : " +
                            document['name'].toString() +
                            gettype +
                            " : " +
                            document['amount'].toString()),
                        subtitle: new Text("ชื่อธนาคาร : " +
                            ' ' +
                            document['bankname'] +
                            ' ' +
                            document['bankaccount']),
                        
                        trailing: new Switch(
                          activeTrackColor: Colors.green,
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          value: dynamicSwitch == null ? false : dynamicSwitch,
                          onChanged: (bool value) {
                            isSwitch = value;
                            handleSwitch(
                                isSwitch, document.documentID, document);
                          },
                        ),
                      */

                        trailing: IconButton(
                          icon: new Icon(Icons.chevron_right),
                          color: Colors.black26,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    // ),
                  );
                  //});
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
