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

class Delete_product extends StatefulWidget {
  @override
  _Delete_product createState() => _Delete_product();
}

class _Delete_product extends State<Delete_product> {
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

  FirebaseUser currentUser;

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userID = user.uid;
      });
    });
    getCal();
  }

  void getCal() async {
    final db = Firestore.instance;
    await db
        .collection('conftab')
        .document('conf')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      count = documentSnapshot.data['count'];
      percenta = documentSnapshot.data['percenta'];
      percentb = documentSnapshot.data['percentb'];
      percentc = documentSnapshot.data['percentc'];
      percentd = documentSnapshot.data['percentd'];
      perday = documentSnapshot.data['perday'];
      fcount = documentSnapshot.data['fcount']; // จำนวนรอบ แนะนำเพื่อน
      fcount_refer =
          documentSnapshot.data['fcount_refer']; // percent ที่ได้รับในรอบนั้นๆ
      fcount_percent =
          documentSnapshot.data['fcount_percent']; // percent ที่ได้รับ
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
          'รายการสินค้า',
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
      stream: Firestore.instance
          .collection('products')
          .where("active", isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        //final int projectsCount = snapshot.data.documents.length;
        List<DocumentSnapshot> documents = snapshot.data.documents; //!.docs;
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
      /*
      if (doc['paytype'] == 1) {
        displayType = 'ฝากเงิน';
      } else {
        displayType = 'ถอนเงิน';
      }
      */
      children.add(
        ProjectsExpansionTile(
          name: doc['productdesc'],
          projectKey: doc.documentID,
          amount: doc['price'],
          picurl: doc['picurl'],
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
      this.amount,
      this.picurl,
      this.getdocuments,
      this.firestore});

  final String projectKey;
  final String name;
  //final String bankname;
  //final String bankaccount;
  final String picurl;
  var amount;
  //var gettype;
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

    return Card(
      child: ExpansionTile(
        key: _projectKey,
        title: Text(
          " รายละเอียดสินค้า : " + name,
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(
          " ราคา : " + amount.toString(),
          style: TextStyle(fontSize: 15.0),
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              "",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Ink.image(
              image: NetworkImage(picurl),
              // fit: BoxFit.cover,
              width: 350,
              height: 350,
            ),
          ),
          ListTile(
            trailing: new Switch(
              activeTrackColor: Colors.green,
              activeColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              value: dynamicSwitch == null ? true : dynamicSwitch,
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

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    var attendanceCollection = Firestore.instance
        .collection('products')
        .document(docid)
        .collection(docid);
    var documentId = docid.toString();
    //document["name"].toString().toLowerCase();
    var attendanceReference = attendanceCollection.document(documentId);
    //return FirestoreListView(documents: snapshot.data.documents);

    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documents.reference);
      await transaction.update(snapshot.reference, {"active": value});
    });
  }

  updateTotal(String docid) {
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
