import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:meplus/screens/authen/register_page.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meplus/components/notification.dart';
import 'package:meplus/components/signin_button.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';
import 'package:meplus/screens/meplussrc/mainpage/components/tab_view.dart';
import 'package:meplus/screens/shopping/mainsrc/main_page.dart';
import 'package:meplus/screens/shopping/product/product_page.dart';
import 'package:meplus/screens/signin_with_email/signin_with_email.dart';
import 'package:meplus/services/signin_with_apple_services/signin_with_apple_services.dart';
//import 'package:meplus/services/signin_with_custom_line_services/signin_with_custom_line_service.dart';
import 'package:meplus/services/signin_with_google_services/signin_with_google_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/material/button_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:meplus/components/notification.dart';
import 'package:meplus/screens/signin_with_email/register_with_email.dart';
import 'package:meplus/services/signin_with_email_method_services/signin_with_email_service.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:meplus/providers/register_provider.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';

import 'package:meplus/screens/meplussrc/package/package.dart';
import 'package:meplus/services/usermngmt.dart';
//----- ME PLUS Main page -----
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';
import 'package:meplus/screens/meplussrc/package/withdraw_money.dart';

import 'package:meplus/screens/meplussrc/package/topupmoney_admin.dart';
import 'package:meplus/screens/meplussrc/package/topuplist.dart';
import 'package:meplus/screens/meplussrc/package/paymentlist_admin.dart';
import 'package:meplus/screens/meplussrc/adminpage/configtab.dart';
import 'package:meplus/screens/meplussrc/products/add_products.dart';
import 'package:meplus/screens/meplussrc/products/orders_list_admin.dart';
import 'package:meplus/screens/meplussrc/adminpage/admin_mainpage.dart';

import 'package:meplus/screens/meplussrc/adminpage/adddescription.dart';
import 'package:meplus/screens/meplussrc/adminpage/bankpage.dart';
import 'package:meplus/screens/meplussrc/adminpage/alltopup.dart';
import 'package:meplus/screens/meplussrc/adminpage/pictureadd.dart';

var firstColor = Color(0xff9999FF), secondColor = Color(0xff9999FF);

class Admin_mainpage extends StatefulWidget {
  final FirebaseUser user;

  @override
  _Admin_mainpage createState() => _Admin_mainpage();

  const Admin_mainpage({Key key, this.user}) : super(key: key);
}

class _Admin_mainpage extends State<Admin_mainpage> {
  IconData get icon => null;
  UserManagement userObj = new UserManagement();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String namedis;
  String userID = "";
  Firestore _db = Firestore.instance;
  TabController tabController;
  var sumtotal;
  var sumpayment;
  var sumdibpayment;
  var sumdibpaymentn;
  @override
  void initState() {
    // initLineSdk();
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userID = user.uid;
      });
    });
    //getUsername();
    userNameGet();
    queryValues();
    queryPayment();
    queryDibPayment();
    //getSumtotalValue();
  }

  Future<dynamic> getUsername() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .snapshots()
        .listen((snapshot) {
      namedis = snapshot.data['name'];
      return namedis;
    });
  }

  dynamic userdesc;
  Future userNameGet() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentReference getpackage =
        Firestore.instance.collection("users").document(user.uid);

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
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentReference getpacksum =
        Firestore.instance.collection("moneytrans").document();

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

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('moneytrans')
        .where("uid", isEqualTo: user.uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal =
          snapshot.documents.fold(0, (tot, doc) => tot + doc.data['amount']);

      sumtotal = tempTotal.toString();

      return sumtotal;
    });
  }

  Future<dynamic> queryPayment() async {
    var getuid;

    double tempTotal = 0;
    double sumdib = 0;
    sumtotal = 0;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection('trademoney')
        .where("uid", isEqualTo: user.uid)
        //.where("active", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal = snapshot.documents
          .fold(0, (tot, doc) => tot + doc.data['calpayment']);

      sumdib = tempTotal;
      sumpayment = sumdib.toString(); //tempTotal.toString();

      return sumpayment;
    });
  }

  Future<dynamic> queryDibPayment() async {
    var getuid;

    double tempTotal = 0;
    sumtotal = 0;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('trademoney')
        .where("uid", isEqualTo: user.uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      tempTotal = snapshot.documents
          .fold(0, (tot, doc) => tot + doc.data['calpayment']);
      sumdibpayment = tempTotal.toString();

      return sumdibpayment;
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

    Widget showCard = Positioned(
      left: 15,
      height: 200,
      //right: 0,
      //bottom: 50,
      top: 150,
      child: InkWell(
        //will break to another line on overflow
        //direction: Axis.horizontal, //use vertical to show  on vertical axis
        child: Container(
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              //margin: const EdgeInsets.all(30.0),
              //padding: const EdgeInsets.all(10.0),
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/carts.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Addproducts())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'เพิ่มสินค้า',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/exchange.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Adddescription())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'การลงทุน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/checklist.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Alltopup())), //MainPage()
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
      left: 15,
      //right: 0,
      //bottom: 50,
      top: 280,
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/bank.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Bankpage())),
                          ),
                        ),
                        Text(
                          'บัญชีธนาคาร',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/checklist.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Pictureadd())), //MainPage()
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'ทดสอบรูป',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    /*
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/exchange.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Adddescription())),
                          ),

                          //Text(
                          //  'สินค้า',
                          //  style: TextStyle(
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                        ),
                        Text(
                          'รายละเอียดการลงทุน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
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
                          height: 80,
                          width: 80,
                          child: IconButton(
                            icon: Image.asset('assets/icons/checklist.png'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => MainPage())),
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
        child: Stack(
          //margin: const EdgeInsets.only(top: kToolbarHeight),
          //padding: EdgeInsets.symmetric(horizontal: 16.0),
          //child: Column(
          // mainAxisSize: MainAxisSize.min,

          children: <Widget>[
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 200.0),
                /*
                child: Text(
                  '  ADMIN',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                */
              ),
            ),

            Container(
              // padding: EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
            ),

            //showDesc,
            //Spacer(flex: 1),
            //SizedBox(height: 20),
            //packageLinkk,
            //packageLink,

            //SizedBox(height: 20),
            showCard,
            //SizedBox(height: 20),
            showCardtwo,

            //showname,
          ],
        ),
      ),
      // ),
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
