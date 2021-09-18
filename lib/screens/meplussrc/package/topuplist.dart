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

class Topuplist extends StatefulWidget {
  @override
  _Topuplist createState() => _Topuplist();
}

class _Topuplist extends State<Topuplist> {
  String userID = "";
  bool _value = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber, //Colors.transparent,
        shape: CustomShapeBorder(),

        elevation: 0.0,
        //leading: Icon(Icons.menu),
        iconTheme: IconThemeData(color: darkGrey),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/denied_wallet.png'),
            //onPressed: () => Navigator.of(context)
            //    .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
          )
        ],
        //title: Text("รายการ"),
        title: Text(
          'รายการฝากเงิน',
          style: TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: BookList(),
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

    /*
    path.lineTo(0, rect.height);
    path.quadraticBezierTo(rect.width / 2 - (innerCircleRadius / 2) - 30,
        rect.height + 15, rect.width / 2 - 75, rect.height + 50);
    path.cubicTo(
        rect.width / 2 - 40,
        rect.height + innerCircleRadius - 40,
        rect.width / 2 + 40,
        rect.height + innerCircleRadius - 40,
        rect.width / 2 + 75,
        rect.height + 50);
    path.quadraticBezierTo(rect.width / 2 + (innerCircleRadius / 2) + 30,
        rect.height + 15, rect.width, rect.height);
    path.lineTo(rect.width, 0.0);
    path.close();
    */
    return path;
  }
}

class BookList extends StatelessWidget {
  //final user = FirebaseAuth.instance.currentUser();
  //final user  = context.watch<LoginProvider>().user
  //final getuid = ;
  //String userID;

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
                        /*
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("View"),
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
                                        "OK",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ); 
                              
                            } 
                            
                            );
                            */
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
