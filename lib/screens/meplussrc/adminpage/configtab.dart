import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/providers/add_money_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:nice_button/nice_button.dart';

import 'package:meplus/services/usermngmt.dart';
import 'package:provider/provider.dart';
import 'package:meplus/providers/login_provider.dart';

class Configtab extends StatefulWidget {
  final User user;

  @override
  _Configtab createState() => _Configtab();
  const Configtab({Key key, this.user}) : super(key: key);
}

class _Configtab extends State<Configtab> {
  UserManagement userObj = new UserManagement();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  PageController _pageController;
  String pddemail = "Please wait...";
  final getpercent = TextEditingController();

  String fullName;
  String getmail;
  String userID = "";

  bool showTextField = false;
  TextEditingController controller = TextEditingController();
  String collectionName = "Users";
  bool isEditing = false;
  User curUser;

  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    setState(() {
      userID = user.uid;
    });
    //});

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    //var card = new Card(child: new Column(children: <Widget>[]));
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("ตั้งค่าเงื่อนไข"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conftab')
            //.document(conf)
            //.where("uid", isEqualTo: userID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          Text("Loading . . . ");

          return FirestoreListView(documents: snapshot.data.docs);
        },
      ),
    );
  }
}

class FirestoreListView extends StatelessWidget {
  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
  final List<DocumentSnapshot> documents;
  final amount = TextEditingController();
  double amtval = 0;
  FirestoreListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 500.0,
      itemBuilder: (BuildContext context, int index) {
        //String name = documents[index].data['name'].toString();
        //String email = documents[index].data['email'].toString();
        //String uid = documents[index].data['uid'].toString();
        //String bankname = documents[index].data['bankname'].toString();
        //String bankaccount = documents[index].data['bankaccount'].toString();
        //int score = documents[index].data['score'];
        //bool active = documents[index].data['active'] ?? false;

        String perday = documents[index]['perday'].toString();
        String count = documents[index]['count'].toString();
        String amounta = documents[index]['amounta'].toString();
        String amountb = documents[index]['amountb'].toString();
        String amountc = documents[index]['amountc'].toString();
        String amountd = documents[index]['amountd'].toString();
        String percenta = documents[index]['percenta'].toString();
        String percentb = documents[index]['percentb'].toString();
        String percentc = documents[index]['percentc'].toString();
        String percentd = documents[index]['percentd'].toString();
        String fcount = documents[index]['fcount'].toString();
        String fcount_refer = documents[index]['fcount_refer'].toString();
        String fcount_percent = documents[index]['fcount_percent'].toString();

        return ListTile(
          title: Container(
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                  initialValue: perday,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.account_balance),
                    hintText: 'คำนวนตามวัน',
                    labelText: 'คำนวนตามวัน',
                  ),
                  onFieldSubmitted: (String getpercent) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      // getpercent = double.parse(percent);
                      transaction
                          .update(snapshot.reference, {'perday': getpercent});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: count,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.time_to_leave_rounded),
                    hintText: 'Count รอบการจ่ายเงิน กี่วัน',
                    labelText: 'Count payment',
                  ),
                  onFieldSubmitted: (String getcount) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'count': getcount});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: amounta,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.money),
                    hintText: 'ลงทุนตั้งแต่ 100',
                    labelText: 'ลงทุนตั้งแต่ 100',
                  ),
                  onFieldSubmitted: (String amounta) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'amounta': amounta});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: amountb,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.money),
                    hintText: 'ลงทุนตั้งแต่ 1,000',
                    labelText: 'ลงทุนตั้งแต่ 1,000',
                  ),
                  onFieldSubmitted: (String amountb) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'amountb': amountb});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: amountc,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.money),
                    hintText: 'ลงทุนตั้งแต่ 10,000',
                    labelText: 'ลงทุนตั้งแต่ 10,000',
                  ),
                  onFieldSubmitted: (String amountc) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'amountc': amountc});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: amountd,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.money),
                    hintText: 'ลงทุนตั้งแต่ 100,000',
                    labelText: 'ลงทุนตั้งแต่ 100,000',
                  ),
                  onFieldSubmitted: (String amountd) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'amountd': amountd});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: percenta,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.price_check_outlined),
                    hintText: 'Percent ลำดับที่ 1',
                    labelText: 'Percent ลำดับที่ 1',
                  ),
                  onFieldSubmitted: (String percenta) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'percenta': percenta});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: percentb,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.price_check_outlined),
                    hintText: 'Percent ลำดับที่ 2',
                    labelText: 'Percent ลำดับที่ 2',
                  ),
                  onFieldSubmitted: (String percenta) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'percentb': percentb});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: percentc,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.price_check_outlined),
                    hintText: 'Percent ลำดับที่ 3',
                    labelText: 'Percent ลำดับที่ 3',
                  ),
                  onFieldSubmitted: (String percentc) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'percentc': percentc});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: percentd,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.price_check_outlined),
                    hintText: 'Percent ลำดับที่ 4',
                    labelText: 'Percent ลำดับที่ 4',
                  ),
                  onFieldSubmitted: (String percentd) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'percentd': percentd});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: fcount,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.ac_unit_rounded),
                    hintText: 'Count รอบแนะนำเพื่อน',
                    labelText: 'Count รอบแนะนำเพื่อน',
                  ),
                  onFieldSubmitted: (String fcount) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction
                          .update(snapshot.reference, {'fcount': fcount});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: fcount_refer,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.access_alarm),
                    hintText: 'Percent แนะนำเพื่อน',
                    labelText: 'Percent แนะนำเพื่อน',
                  ),
                  onFieldSubmitted: (String fcount_refer) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction.update(
                          snapshot.reference, {'fcount_refer': fcount_refer});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: fcount_percent,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.access_alarm),
                    hintText: 'Percent /รอบแนะนำเพื่อน',
                    labelText: 'Percent /รอบแนะนำเพื่อน',
                  ),
                  onFieldSubmitted: (String fcount_percent) {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      transaction.update(snapshot.reference,
                          {'fcount_percent': fcount_percent});
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),

          /*
                onTap: () => Firestore.instance
                    .runTransaction((Transaction transaction) async {
                  DocumentSnapshot snapshot =
                      await transaction.get(documents[index].reference);

                  await transaction.update(
                      snapshot.reference, {"active": !snapshot["active"]});
                }
                ) 
          */
        );
      },
    );
  }
}
