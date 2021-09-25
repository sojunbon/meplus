import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:meplus/screens/authen/register_page.dart';

import 'package:meplus/components/notification.dart';
import 'package:meplus/components/signin_button.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';
import 'package:meplus/screens/meplussrc/mainpage/components/tab_view.dart';

//import 'package:meplus/services/signin_with_apple_services/signin_with_apple_services.dart';
//import 'package:meplus/services/signin_with_custom_line_services/signin_with_custom_line_service.dart';
//import 'package:meplus/services/signin_with_google_services/signin_with_google_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/material/button_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:meplus/components/notification.dart';

//import 'package:meplus/services/signin_with_email_method_services/signin_with_email_service.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:meplus/providers/register_provider.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';

import 'package:meplus/screens/meplussrc/package/package.dart';
import 'package:meplus/services/usermngmt.dart';
//----- ME PLUS Main page -----
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';
import 'package:meplus/screens/meplussrc/package/topuplist.dart';
import 'package:meplus/screens/meplussrc/package/withdraw_money.dart';
import 'package:meplus/screens/meplussrc/products/meproducts.dart';
import 'package:meplus/screens/meplussrc/package/topuplist.dart';
import 'package:url_launcher/url_launcher.dart';

var firstColor = Color(0xff9999FF), secondColor = Color(0xff9999FF);

class Meplusmain extends StatefulWidget {
  final User user;

  @override
  _Meplusmain createState() => _Meplusmain();

  const Meplusmain({Key key, this.user}) : super(key: key);
}

class _Meplusmain extends State<Meplusmain> {
  IconData get icon => null;
  UserManagement userObj = new UserManagement();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String namedis;
  String userID = "";
  FirebaseFirestore _db = FirebaseFirestore.instance;
  TabController tabController;
  String linead;
  var sumtotal;
  var sumpayment;
  var sumdibpayment;
  var sumdibpaymentn;
  @override
  void initState() {
    // initLineSdk();
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    setState(() {
      userID = user.uid;
      //});
    });
    //getUsername();
    userNameGet();
    queryValues();
    queryPayment();
    queryDibPayment();
    getDescription();
    //getSumtotalValue();
  }

  Future<dynamic> getUsername() async {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      namedis = snapshot['name'];
      return namedis;
    });
  }

  _launchURL() async {
    String url = linead; //'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch('https://lin.ee/Q2YqPcy');

      // throw 'Could not launch $url';
    }
  }

  Future<void> lineurl() async {
    String url = linead; //'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch('https://lin.ee/Q2YqPcy');

      // throw 'Could not launch $url';
    }
  }

  dynamic userdesc;
  Future userNameGet() async {
    User user = FirebaseAuth.instance.currentUser;
    final DocumentReference getpackage =
        FirebaseFirestore.instance.collection("users").doc(user.uid);

    await getpackage.get().then<dynamic>((DocumentSnapshot getsnapshot) async {
      setState(() {
        userdesc = getsnapshot.data;
        namedis = userdesc['name'];
      });
    });
  }

  dynamic getsumtotal;
  Future getSumtotalValue() async {
    bool gettype;
    double tempTotal = 0;
    User user = FirebaseAuth.instance.currentUser;
    final DocumentReference getpacksum =
        FirebaseFirestore.instance.collection("moneytrans").doc();

    await getpacksum
        .get()
        .then<dynamic>((DocumentSnapshot getsnapshotsum) async {
      setState(() {
        getsumtotal = getsnapshotsum.data;
        sumtotal = getsumtotal['amount'];
        gettype = getsumtotal['active'];

        //for (int i = 1; i <= getsumtotal['uid'].lenght; i++) {
        //  sumtotal += getsumtotal['amount'][i]; // + sumtotal;
        //}

        // gettype = getsumtotal['active'];
        // if (gettype == true) {
      });
    });
  }

  Future<dynamic> queryValues() async {
    var getuid;

    double tempTotal = 0;
    sumtotal = 0;

    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('moneytrans')
        .where("uid", isEqualTo: user.uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + doc['amount']);

      sumtotal = tempTotal.toString();

      return sumtotal;
    });
  }

  Future<dynamic> queryPayment() async {
    var getuid;

    double tempTotal = 0;
    double sumdib = 0;
    sumtotal = 0;
    User user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('trademoney')
        .where("uid", isEqualTo: user.uid)
        //.where("active", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + doc['calpayment']);

      sumdib = tempTotal;
      sumpayment = sumdib.toString(); //tempTotal.toString();

      return sumpayment;
    });
  }

  Future<dynamic> queryDibPayment() async {
    var getuid;

    double tempTotal = 0;
    sumtotal = 0;
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('trademoney')
        .where("uid", isEqualTo: user.uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + doc['calpayment']);
      sumdibpayment = tempTotal.toString();

      return sumdibpayment;
    });
  }

  dynamic datadesc;
  Future getDescription() async {
    final DocumentReference getpackage =
        FirebaseFirestore.instance.collection("packagedesc").doc('desc');

    await getpackage.get().then<dynamic>((DocumentSnapshot getsnapshot) async {
      setState(() {
        datadesc = getsnapshot.data;
        linead = datadesc['line'].toString();

        //datab = ClipboardData(text: bankacct_trans.toString());
        //Clipboard.setData(datab);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayname;
    if (namedis == null) {
      displayname = "-";
    } else {
      displayname = namedis;
    }
    Widget welcomeBack = Text(
      ' ',
      style: TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        /*
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          
          ] */
      ),
    );

    Widget showname = Positioned(
      //left: MediaQuery.of(context).size.width / 4,
      //bottom: 1,
      child: InkWell(
        onTap: () async {},
        child: Container(
          //width: MediaQuery.of(context).size.width,
          width: 380,
          height: 200,
          //decoration: BoxDecoration(
          //    image: DecorationImage(
          //        image: AssetImage('assets/card.jpg'), fit: BoxFit.fill)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(
                      'assets/card.jpg'), //NetworkImage("https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                  fit: BoxFit.cover)),
          child: Center(
              child: Card(
            color: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            //shadowColor: Colors.lightBlue,
            //child: Text('Heyyyy')
            child: ListTile(
              // --- แสดงยอดเงิน ---
              title: new Text("คุณ : " + displayname),
              // subtitle: Text("ยอดเงินในบัญชี"),
            ),
          )),

          /*
          height: 80,
          child: Center(
            child: Card(
              //color: Colors.transparent, // -- Card transparent --
              child: ListTile(
                // --- แสดงยอดเงิน ---
                title: new Text("คุณ : " + displayname),
                // subtitle: Text("ยอดเงินในบัญชี"),
              ),
            ),
          ), */
        ),
      ),
    );

    Widget showDesc = Positioned(
        height: 200,
        width: 370,
        left: 15,
        //right: 0,
        //bottom: 50,
        top: 70,
        child: new Container(
          alignment: AlignmentDirectional.center,
          child: Container(
            width: 370,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: AssetImage(
                        'assets/card.jpg'), //NetworkImage("https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                    fit: BoxFit.fill)),
            child: ListView(children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("   คุณ : " +
                          displayname +
                          "  ยอดเงินลงทุน : " +
                          sumtotal.toString()),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("   "),
                    ),
                    //Align(
                    //  alignment: Alignment.topLeft,
                    //  child: Text("   "),
                    //),
                    //Align(
                    //  alignment: Alignment.topLeft,
                    //  child: Text("   ยอดเงินลงทุน"),
                    //),
                    //Align(
                    //  alignment: Alignment.topLeft,
                    //  child: Text("     " + sumtotal.toString()),
                    //),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("   "),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("   ยอดเงินที่จะได้รับ"),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "       " + sumpayment.toString(),
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.pinkAccent)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("   ยอดเงินที่โอนแล้ว"),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "       " + sumdibpayment.toString(),
                        style: (TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.cyan)),
                      ),
                    ),
                  ])
            ]),
          ),
        ));

    Widget packageLinkk = Positioned(
      child: InkWell(
        //will break to another line on overflow
        //direction: Axis.horizontal, //use vertical to show  on vertical axis
        child: Container(
          child: Column(children: <Widget>[
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
                          width: MediaQuery.of(context).size.width / 5,
                          //width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Center(
                              child: new Text("เติมเงิน",
                                  style: const TextStyle(
                                      color: const Color(0xfffefefe),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0))),

                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff9999FF), Color(0xff9999FF),
                                    //Color.fromRGBO(246, 60, 3, 1),
                                    //Color.fromRGBO(200, 60, 3, 1),
                                    //Color.fromRGBO(180, 78, 16, 1),
                                  ],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0,
                                )
                              ],
                              //borderRadius: BorderRadius.circular(9.0)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
                          width: MediaQuery.of(context).size.width / 5,
                          //width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Center(
                              child: new Text("รายได้",
                                  style: const TextStyle(
                                      color: const Color(0xfffefefe),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0))),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff9999FF), Color(0xff9999FF),
                                    //Color.fromRGBO(246, 60, 3, 1),
                                    //Color.fromRGBO(200, 60, 3, 1),
                                    //Color.fromRGBO(180, 78, 16, 1),
                                  ],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0,
                                )
                              ],
                              //borderRadius: BorderRadius.circular(9.0)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ), // button third
    );
    Widget packageLink = Positioned(
      //height: 200,
      //width: 380,
      left: 30,
      //right: 0,
      //bottom: 50,
      top: 280,
      child: InkWell(
        //will break to another line on overflow
        //direction: Axis.horizontal, //use vertical to show  on vertical axis
        child: Container(
          child: Column(children: <Widget>[
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        NiceButton(
                          radius: 20,
                          width: MediaQuery.of(context).size.width / 3,
                          //padding: const EdgeInsets.all(8),
                          text: "เติมเงิน",
                          gradientColors: [secondColor, firstColor],

                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => Package())),
                          background: null,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        NiceButton(
                          radius: 20,
                          width: MediaQuery.of(context).size.width / 3,
                          //padding: const EdgeInsets.all(8),
                          text: "รายได้",
                          gradientColors: [secondColor, firstColor],

                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => Withdraw_money())),
                          background: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ), // button third
    );

    Widget showCard = Positioned(
      //height: 200,
      //width: 380,
      left: 15,
      //right: 0,
      //bottom: 50,
      top: 350,
      child: InkWell(
        //will break to another line on overflow
        //direction: Axis.horizontal, //use vertical to show  on vertical axis
        child: Container(
          child: Column(children: <Widget>[
            Container(
              //margin: const EdgeInsets.all(30.0),
              padding: const EdgeInsets.all(10.0),
              //decoration: myBoxDecoration(),
              /*
              margin: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: transparentYellow,
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(0, 1))
                  ]),
              height: 150,
              */
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: transparentYellow,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          height: 80,
                          //width: 80,
                          child: IconButton(
                            //padding: EdgeInsets.zero,
                            //padding: const EdgeInsets.all(16.0),
                            icon: Image.asset('assets/icons/carts.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Meproducts())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'สินค้า',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: transparentYellow,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          height: 80,
                          //width: 80,
                          child: IconButton(
                            //padding: EdgeInsets.zero,
                            //padding: const EdgeInsets.all(16.0),
                            icon: Image.asset('assets/icons/exchange.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Package())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'ลงทุน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: transparentYellow,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          height: 80,

                          //width: 80,
                          child: IconButton(
                            //padding: EdgeInsets.zero,
                            //padding: const EdgeInsets.all(16.0),
                            icon: Image.asset('assets/icons/checklist.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Topuplist())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );

    Widget showCardtwo = Positioned(
      //height: 200,
      //width: 380,
      left: 15,
      //right: 0,
      //bottom: 50,
      top: 470,
      child: InkWell(
        //will break to another line on overflow
        //direction: Axis.horizontal, //use vertical to show  on vertical axis
        child: Container(
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: transparentYellow,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          height: 80,
                          //width: 80,
                          child: IconButton(
                            //padding: EdgeInsets.zero,
                            //padding: const EdgeInsets.all(16.0),
                            icon: Image.asset('assets/icons/line.png'),

                            onPressed: () {
                              //_launchURL();
                              lineurl();
                            },
                            //onPressed: () => Navigator.of(context).push(
                            //    MaterialPageRoute(
                            //        builder: (_) => Meproducts())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'ติดต่อเรา',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    /*
                    SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: transparentYellow,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          height: 80,
                          //width: 80,
                          child: IconButton(
                            //padding: EdgeInsets.zero,
                            //padding: const EdgeInsets.all(16.0),
                            icon: Image.asset('assets/icons/exchange.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Package())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'ลงทุน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: transparentYellow,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          height: 80,

                          //width: 80,
                          child: IconButton(
                            //padding: EdgeInsets.zero,
                            //padding: const EdgeInsets.all(16.0),
                            icon: Image.asset('assets/icons/checklist.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Topuplist())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    */
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );

    return Material(
      color: Color(0xffF9F9F9),
      // กำหนด --scroll view ทั้งหน้า  SingleChildScrollView
      child: SingleChildScrollView(
        //padding: EdgeInsets.all(10),
        child: Stack(
          // margin: const EdgeInsets.only(top: kToolbarHeight),
          // padding: EdgeInsets.symmetric(horizontal: 16.0),
          // child: Column(
          //  mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                //margin: const EdgeInsets.only(top: kToolbarHeight),
                //padding: EdgeInsets.symmetric(horizontal: 16.0),
                //Column(
                // mainAxisSize: MainAxisSize.min
                ),
            /*
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 350.0),
                //padding: EdgeInsets.all(10),
                child: Text(
                  '\n' + ' ME PLUS',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            */
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 350.0),
              ),
            ),
            /*
            Container(
              //margin: const EdgeInsets.only(top: kToolbarHeight),
              //padding: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
            ),
            */
            //Spacer(flex: 2),
            //SizedBox(height: 20),
            showDesc,
            //Spacer(flex: 1),
            //SizedBox(height: 20),
            packageLink,

            //SizedBox(height: 20),
            showCard,

            showCardtwo,

            //showname,
          ],
        ),
        //  ),
      ),
    );
    /*
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 1),
                //Spacer(),
                welcomeBack,
                //Spacer(),
                //subTitle,
                showname,
                //Spacer(flex: 1),
              ],
            ),
          )
        ],
      ),
    );
    */
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 3.0),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }
}
