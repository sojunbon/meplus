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

class Meproducts extends StatefulWidget {
  @override
  _Meproducts createState() => _Meproducts();
}

class _Meproducts extends State<Meproducts> {
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

/*
    return Padding(
      // padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 100,
        //child: GestureDetector(
        //onTap: () => Navigator.pushNamed(
        //  context,
        //  DetailsScreen.routeName,
        //  arguments: ProductDetailsArguments(product: product),
        //),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: EdgeInsets.all(100),
                decoration: BoxDecoration(
                  //  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Hero(
                  tag: name.toString(), // .id.toString(),
                  //child: Image.asset(product.images[0]),
                  child: Ink.image(
                    image: NetworkImage(picurl),

                    //width: 150,
                    //height: 150,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(color: Colors.black),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\บาท ${amount}",
                  style: TextStyle(
                    //fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w600,
                    //color: kPrimaryColor,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    //  padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                    //  height: getProportionateScreenWidth(28),
                    //  width: getProportionateScreenWidth(28),
                    decoration: BoxDecoration(
                      // color: product.isFavourite
                      //     ? kPrimaryColor.withOpacity(0.15)
                      //     : kSecondaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    //child: SvgPicture.asset(
                    //  "assets/icons/Heart Icon_2.svg",
                    //  color: product.isFavourite
                    //      ? Color(0xFFFF4848)
                    //      : Color(0xFFDBDEE4),
                    //),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
   */

    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                  width: 4,
                  color: mediumYellow,
                ),
              ),
              Center(
                  child: Text(
                'Recommended',
                style: TextStyle(
                    color: darkGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              )),
            ],
          ),
        ),
        Flexible(
          child: Container(
            //padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            // child: StaggeredGridView.countBuilder(
            // physics: NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.zero,
            // crossAxisCount: 4,
            // itemCount: name.length, //products.length,
            // itemBuilder: (BuildContext context, int index) => new ClipRRect(
            //  borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: InkWell(
              //  onTap: () => Navigator.of(context).push(MaterialPageRoute(
              //    builder: (_) => ProductPage(product: products[index]))),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: [Colors.grey[500], Colors.grey[700]],
                      center: Alignment(0, 0),
                      radius: 0.6,
                      focal: Alignment(0, 0),
                      focalRadius: 0.1),
                ),
                child: Hero(
                  tag: name, //products[index].image,
                  // child: Image.asset(products[index].image))),
                  //child: Ink.image(
                  //  image: NetworkImage(picurl),

                  //width: 150,
                  //height: 150,

                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: NetworkImage(picurl))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ),
              //   ),
              //staggeredTileBuilder: (int index) =>
              //    new StaggeredTile.count(2, index.isEven ? 3 : 2),
              //mainAxisSpacing: 4.0,
              //crossAxisSpacing: 4.0,
            ),
          ),
        ),
      ],
    );

/*
    return InkWell(
        //onTap: () => Navigator.of(context).push(
        //MaterialPageRoute(builder: (_) => ProductPage(product: product))),
        child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width / 2 - 29,
            //decoration: BoxDecoration(
            //    borderRadius: BorderRadius.all(Radius.circular(10)),
            //    color: Color(0xfffbd085).withOpacity(0.46)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width / 2 - 64,
                    height: MediaQuery.of(context).size.width / 2 - 64,
                    child: Ink.image(
                      image: NetworkImage(picurl),
                      //fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment(1, 0.5),
                    child: Container(
                        margin: const EdgeInsets.only(left: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Color(0xffe0450a).withOpacity(0.51),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Text(
                          name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        )),
                  ),
                )
              ],
            )));
            */

    /*
    return InkWell(
      //onTap: () => Navigator.of(context).push(
      //    MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      child: Ink.image(
        image: NetworkImage(picurl),
        //fit: BoxFit.cover,
        width: 150,
        height: 150,
      ),
    );
    */

    /*
    return Card(
      child: ExpansionTile(
        key: _projectKey,
        title: Text(
          "รายละเอียด : " + name,
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(
          " ราคา : " + amount.toString(),
          style: TextStyle(fontSize: 15.0),
        ),
        children: <Widget>[
          //ListTile(
          //  title: Text(
          //    bankname + " / เลขบัญชี : " + bankaccount,
          //    style: TextStyle(fontWeight: FontWeight.w700),
          //  ),
          //),
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
              value: dynamicSwitch == null ? false : dynamicSwitch,
              onChanged: (bool value) {
                var isSwitch = value;
                handleSwitch(isSwitch, projectKey, getdocuments, context);
              },
            ),
          ),
        ],
      ),
      
    );*/
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
