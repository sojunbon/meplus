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

class Bankpage extends StatefulWidget {
  final FirebaseUser user;

  @override
  _Bankpage createState() => _Bankpage();
  const Bankpage({Key key, this.user}) : super(key: key);
}

class _Bankpage extends State<Bankpage> {
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
  FirebaseUser curUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userID = user.uid;
      });
    });

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    //var card = new Card(child: new Column(children: <Widget>[]));
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("ธนาคาร"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('packagedesc')
            //.document(conf)
            //.where("uid", isEqualTo: userID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          Text("Loading . . . ");

          return FirestoreListView(documents: snapshot.data.documents);
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

        String bankname = documents[index].data['bankname'].toString();
        String bankaccount = documents[index].data['bankaccount'].toString();
        String namebank = documents[index].data['name'].toString();
        String line = documents[index].data['line'].toString();

        return ListTile(
          title: Container(
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                  initialValue: bankname,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.account_balance),
                    hintText: 'ชื่อธนาคาร',
                    labelText: 'ชื่อธนาคาร',
                  ),
                  onFieldSubmitted: (String bankname) {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      // getpercent = double.parse(percent);
                      await transaction
                          .update(snapshot.reference, {'bankname': bankname});
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: namebank,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.contact_page),
                    hintText: 'ชื่อบัญชี',
                    labelText: 'ชื่อบัญชี',
                  ),
                  onFieldSubmitted: (String namebank) {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      await transaction
                          .update(snapshot.reference, {'name': namebank});
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: bankaccount,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.code),
                    hintText: 'เลขบัญชี',
                    labelText: 'เลขบัญชี',
                  ),
                  onFieldSubmitted: (String bankaccount) {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      await transaction.update(
                          snapshot.reference, {'bankaccount': bankaccount});
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                new TextFormField(
                  initialValue: line,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.link_rounded),
                    hintText: 'Line',
                    labelText: 'Line',
                  ),
                  onFieldSubmitted: (String line) {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);

                      await transaction
                          .update(snapshot.reference, {'line': line});
                    });
                  },
                  //keyboardType: TextInputType.number,
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
