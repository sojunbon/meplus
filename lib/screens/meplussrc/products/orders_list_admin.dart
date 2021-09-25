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
import 'package:styled_widget/styled_widget.dart';
import 'package:meplus/screens/meplussrc/package/components/money_control.dart';
//import 'package:meplus/screens/meplussrc/package/components/refer_control.dart';

class OrderlistAdmin extends StatefulWidget {
  @override
  _OrderlistAdmin createState() => _OrderlistAdmin();
}

class _OrderlistAdmin extends State<OrderlistAdmin> {
  String userID = "";
  //bool _value = false;
  bool isSwitch = false;
  //bool dynamicSwitch;
  var percent;
  var count;
  var percenta;
  var percentb;
  var percentc;
  var percentd;
  var perday;

  var desca;
  var descb;
  var descc;
  var descd;

  var fcount_percent;
  var fcount_refer;
  var fcount;

  User currentUser;

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    setState(() {
      userID = user.uid;
      // });
    });
    getCal();
  }

  void getCal() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('conftab')
        .doc('conf')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      count = documentSnapshot['count'];
      percenta = documentSnapshot['percenta'];
      percentb = documentSnapshot['percentb'];
      percentc = documentSnapshot['percentc'];
      percentd = documentSnapshot['percentd'];
      perday = documentSnapshot['perday'];
      fcount = documentSnapshot['fcount']; // จำนวนรอบ แนะนำเพื่อน
      fcount_refer =
          documentSnapshot['fcount_refer']; // percent ที่ได้รับในรอบนั้นๆ
      fcount_percent = documentSnapshot['fcount_percent']; // percent ที่ได้รับ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber, // Colors.transparent,
        shape: CustomShapeBorder(),

        elevation: 0.0,
        //leading: Icon(Icons.menu),
        iconTheme: IconThemeData(color: darkGrey),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/denied_wallet.png'),
            // onPressed: () => Navigator.of(context)
            // .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
          )
        ],
        //title: Text("รายการ"),
        title: Text(
          'รายการ สั่งซื้อสินค้า',
          style: TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      // ------ load widget ProjectList -------
      body: ProjectList(), // BookList(),
    );
  }
}

class ProjectList extends StatelessWidget {
  ProjectList();

  final FirebaseAuth firestore = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where("active", isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        //final int projectsCount = snapshot.data.documents.length;
        List<DocumentSnapshot> documents = snapshot.data.docs; //!.docs;
        return ExpansionTileList(
          documents: documents,
        );
      },
    );
  }
}

class ExpansionTileList extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  final FirebaseAuth firestore = FirebaseAuth.instance;

  var displayType;
  ExpansionTileList({this.documents});

  List<Widget> _getChildren() {
    List<Widget> children = [];
    documents.forEach((doc) {
      if (doc['paytype'] == 5) {
        displayType = 'สั่งสินค้า';
      } else {
        displayType = 'กำลังส่งสินค้า';
      }

      children.add(
        ProjectsExpansionTile(
          name: doc['name'],
          address: doc['address'],
          projectKey: doc.id,
          amount: doc['amount'],
          gettype: displayType,
          bankname: doc['bankname'],
          bankaccount: doc['bankaccount'],
          picurl: doc['picurl'],
          productpicurl: doc['productpicurl'],
          mobile: doc['mobile'],
          getdocuments: doc,
          firestore: firestore,
        ),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _getChildren(),
    );
  }
}

class ProjectsExpansionTile extends StatelessWidget {
  ProjectsExpansionTile(
      {this.projectKey,
      this.name,
      this.address,
      this.amount,
      this.gettype,
      this.bankname,
      this.bankaccount,
      this.picurl,
      this.productpicurl,
      this.mobile,
      this.getdocuments,
      this.firestore});

  final String projectKey;
  final String name;
  final String address;
  final String bankname;
  final String bankaccount;
  final String picurl;
  final String productpicurl;
  final String mobile;
  var amount;
  var gettype;
  final FirebaseAuth firestore;
  final DocumentSnapshot getdocuments;
  var sumtotal;
  var sumpayment;

  get isSwitch => null;

  @override
  Widget build(BuildContext context) {
    bool dynamicSwitch;

    PageStorageKey _projectKey = PageStorageKey('$projectKey');
    var getprjkey = _projectKey;

    String getpic;
    String productpic;

    //  child: Image.asset('assets/icons/10 usd.png'),
    if (picurl == null) {
      getpic = "assets/whitepaper.png";
    } else {
      getpic = picurl;
    }

    if (productpicurl == null) {
      productpic = "assets/whitepaper.png";
    } else {
      productpic = productpicurl;
    }

    return Card(
      child: ExpansionTile(
        key: _projectKey,
        title: Text(
          "ชื่อ : " + name,
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(
          gettype + " ราคา : " + amount.toString(),
          style: TextStyle(fontSize: 15.0),
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              "ที่อยู่ : " + address,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            title: Text(
              "เบอร์โทรศัพท์ : " + mobile,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Ink.image(
              image: NetworkImage(getpic),
              // fit: BoxFit.cover,
              width: 250,
              height: 250,
            ),
          ),
          ListTile(
            title: Text(
              "",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Ink.image(
              image: NetworkImage(productpic),
              // fit: BoxFit.cover,
              width: 250,
              height: 250,
            ),
          ),
          ListTile(
            trailing: new Switch(
              activeTrackColor: Colors.green,
              activeColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              value: dynamicSwitch == null ? false : dynamicSwitch,
              onChanged: (bool value) {
                var isSwitch = value;
                handleSwitch(isSwitch, projectKey, getdocuments, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleSwitch(bool value, String docid,
      DocumentSnapshot documents, BuildContext context) async {
    //setState(() {
    //isSwitch = value;
    //dynamicSwitch = value;

    User user = FirebaseAuth.instance.currentUser;

    var attendanceCollection = FirebaseFirestore.instance
        .collection('orders')
        .doc(docid)
        .collection(docid);
    var documentId = docid.toString();
    //document["name"].toString().toLowerCase();
    var attendanceReference = attendanceCollection.doc(documentId);
    //return FirestoreListView(documents: snapshot.data.documents);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documents.reference);
      transaction.update(snapshot.reference, {"active": value});
      //await updateTotal(snapshot.data['uid']);
    });
    // --- insert data รายการ trade ---

    //generateData(context, docid, documents);
    //generateReferFriend(context, docid, user.uid, documents);
    // genReferFriend(context, docid, user.uid, documents);
  }

  updateTotal(String docid) {
    var postRef = FirebaseFirestore.instance.collection("users").doc(docid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.get(postRef).then((res) async {
        transaction.update(postRef, {
          'sumtotal': sumtotal,
          'paymentamt': sumpayment,
        });
      });
    });
  }
}

class BookList extends StatelessWidget {
  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<LoginProvider>().user);
    var gettype;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('moneytrans')
          .where("uid", isEqualTo: user.uid)
          //  .where("active", isEqualTo: "true")
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
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                if (document['paytype'] == 1) {
                  gettype = 'ฝากเงิน';
                } else {
                  gettype = 'ถอนเงิน';
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Update Dilaog"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      document['amount'].toString(),
                                      // "amount: ",
                                      textAlign: TextAlign.start,
                                    ),
                                    TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        hintText: document['amount'].toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text("bankname: "),
                                    ),
                                    TextField(
                                      controller: authorController,
                                      decoration: InputDecoration(
                                        hintText: document['bankname'],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text("bankaccount: "),
                                    ),
                                    TextField(
                                      controller: authorController,
                                      decoration: InputDecoration(
                                        hintText: document['bankaccount'],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: RaisedButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Undo",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      title: new Text(
                          gettype + " : " + document['amount'].toString()),
                      subtitle: new Text("ชื่อธนาคาร : " +
                          ' ' +
                          document['bankname'] +
                          ' ' +
                          document['bankaccount']),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final double innerCircleRadius = 150.0;
    double height = rect.height;
    double width = rect.width;
    Path path = Path();

    path.lineTo(0, height - 9);
    path.quadraticBezierTo(width / 2, height, width, height - 9);
    path.lineTo(width, 0);
    path.close();

    return path;
  }
}
