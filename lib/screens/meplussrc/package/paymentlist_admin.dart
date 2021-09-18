import 'package:intl/intl.dart';
import 'package:meplus/app_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/providers/add_money_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:nice_button/nice_button.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:meplus/screens/meplussrc/package/components/money_control.dart';

class Paymentlist extends StatefulWidget {
  @override
  _Paymentlist createState() => _Paymentlist();
}

class _Paymentlist extends State<Paymentlist> {
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
        // shape: CustomShapeBorder(),

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
          'ชำระเงินปันผลให้ลูกค้า',
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
  //DateTime serverdate = NTP.now() as DateTime;

  DateTime _now = DateTime.now();
  //DateTime dateToday =
  //    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String formatdate = DateFormat('ddMMyyyy').format(DateTime.now());
  //double convertdate = double.parse(formatdate);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('trademoney')
          //.where("date_query",
          //    isLessThanOrEqualTo: 8092021) //double.parse(formatdate))
          //.where("date_query", isLessThanOrEqualTo: double.parse(formatdate))
          .where("active", isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('No data...');
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
      //DateTime serverdate = NTP.now() as DateTime;

      // if (doc['server_date'] <= new DateTime.now()) {

      //DateTime dateCreatedx = doc["server_date"]?.toDate();
      //if (doc['server_date'] <= new DateTime.now()) {

      DateTime dateToday = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime dateCreatedx = doc["server_date"]?.toDate();

      children.add(
        ProjectsExpansionTile(
          name: doc['name'],
          projectKey: doc.documentID,
          amount: doc['amount'],
          calpayment: doc['calpayment'],
          //gettype: displayType,
          bankname: doc['bankname'],
          bankaccount: doc['bankaccount'],
          caldate: doc['caldate'],
          datequery: doc['date_query'],
          //picurl: doc['picurl'],
          getdocuments: doc,
          count: doc['tradecount'],
          desc: doc['desc'],
          firestore: firestore,
        ),
      );
      // }
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
  ProjectsExpansionTile({
    this.projectKey,
    this.name,
    this.amount,
    this.calpayment,
    this.bankname,
    this.bankaccount,
    this.caldate,
    this.datequery,
    // this.dateCreated,
    this.getdocuments,
    this.count,
    this.desc,
    this.firestore,
  });

  final String projectKey;
  final String name;
  final String bankname;
  final String bankaccount;
  final String caldate;
  final String desc;
  var datequery;
  var calpayment;
  var count;
  DateTime displaydate;
  //final String picurl;
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
    String formatdate = DateFormat('ddMMyyyy').format(DateTime.now());
    if (datequery <= double.parse(formatdate)) {
      return Card(
        child: ExpansionTile(
          key: _projectKey,
          title: Text(
            "รอบที่ : " + count.toString() + " \n ชื่อ : " + name + " \n ",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            " เงินลงทุน : " +
                amount.toString() +
                " \n ผลตอบแทนที่ได้รับ : " +
                calpayment.toString() +
                " \n วันที่ได้รับผลตอบแทน : " +
                caldate +
                " \n " +
                bankname +
                " / เลขบัญชี : " +
                bankaccount +
                " \n " +
                desc,
            style: TextStyle(fontSize: 15.0),
          ),
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

          /*
        children: <Widget>[
          ListTile(
            title: Text(
              bankname + " / เลขบัญชี : " + bankaccount,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            title: Text(
              "วันที่ได้รับผลตอบแทน : " + caldate,
              style: TextStyle(fontWeight: FontWeight.w700),
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

        */
        ),
      );
    } else {
      return Card();
    }
  }

  void handleSwitch(bool value, String docid, DocumentSnapshot documents,
      BuildContext context) {
    var attendanceCollection = Firestore.instance
        .collection('trademoney')
        .document(docid)
        .collection(docid);
    var documentId = docid.toString();
    //document["name"].toString().toLowerCase();
    var attendanceReference = attendanceCollection.document(documentId);
    //return FirestoreListView(documents: snapshot.data.documents);

    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documents.reference);
      await transaction.update(snapshot.reference, {"active": value});
      //await updateTotal(snapshot.data['uid']);
    });
    // --- insert data รายการ trade ---
    // generateData(context, docid, documents);
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

/*
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
*/
