import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
import 'package:meplus/screens/meplussrc/products/product_detail.dart';
import 'package:meplus/models/newproduct.dart';

class Meproducts extends StatefulWidget {
  final Newproduct newproduct;
  Meproducts({Key key, this.newproduct}) : super(key: key);
  @override
  _Meproducts createState() => _Meproducts(newproduct);
}

class _Meproducts extends State<Meproducts> {
  final Newproduct newproduct;

  _Meproducts(this.newproduct);
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

  var bankname_trans;
  var bankacct_trans;

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
      backgroundColor:
          Colors.white, //Color.fromRGBO(0, 0, 0, 128), //Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        // backgroundColor: Colors.white, // Colors.transparent,
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

    List<Widget> product = [];
    List<Newproduct> newproduct = [];
    //final Newproduct newproduct ;

    documents.forEach((doc) {
      newproduct
          .add(Newproduct(doc['picurl'], doc['productdesc'], doc['price']));
      children.add(
        ProjectsExpansionTile(
          name: doc['productdesc'],
          projectKey: doc.documentID,
          amount: doc['price'],
          picurl: doc['picurl'],
          getdocuments: doc,
          firestore: firestore,
          newproduct: newproduct,
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
      this.firestore,
      this.newproduct});

  final String projectKey;
  final String name;
  final List newproduct;
  //final Newproduct newproduct;
  //List<Newproduct> newproduct;

  final String picurl;
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
    String dockid = projectKey;
    String getpic;

    //  child: Image.asset('assets/icons/10 usd.png'),
    if (picurl == null) {
      getpic = Image.asset('assets/whitepaper.png') as String;
      //"assets/whitepaper.png";
    } else {
      getpic = picurl;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Product_detail(
                      dockid,
                      //newproduct: newproduct,
                    )));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(getpic)))),
          FractionalTranslation(
            translation: Offset(0, -0.5),
            child: Container(
              width: 160,
              height: 70,
              child: Center(
                  child: Text(
                amount.toString() + ' ฿',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 5, color: Colors.white)),
            ),
          ),
          FractionalTranslation(
            translation: Offset(0, -1),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
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
        .collection('moneytrans')
        .document(docid)
        .collection(docid);
    var documentId = docid.toString();
    //document["name"].toString().toLowerCase();
    var attendanceReference = attendanceCollection.document(documentId);
    //return FirestoreListView(documents: snapshot.data.documents);

    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documents.reference);
      await transaction.update(snapshot.reference, {"active": value});
      await updateTotal(snapshot.data['uid']);
    });
    // --- insert data รายการ trade ---

    generateData(context, docid, documents);
    generateReferFriend(context, docid, user.uid, documents);
    // genReferFriend(context, docid, user.uid, documents);
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

class BookList extends StatelessWidget {
  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<LoginProvider>().user);
    var gettype;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
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
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
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
