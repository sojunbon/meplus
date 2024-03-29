import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:meplus/components/notification.dart';
import 'package:meplus/components/signin_button.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';

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
import 'package:provider/provider.dart';

import 'package:meplus/screens/meplussrc/package/package.dart';
import 'package:meplus/services/usermngmt.dart';
//----- ME PLUS Main page -----
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';

import 'package:meplus/screens/meplussrc/products/product_page.dart';

class Melink extends StatefulWidget {
  final User user;

  @override
  _Melink createState() => _Melink();

  const Melink({Key key, this.user}) : super(key: key);
}

class _Melink extends State<Melink> {
  IconData get icon => null;
  UserManagement userObj = new UserManagement();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String namedis;
  String userID = "";
  FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void initState() {
    // initLineSdk();
    super.initState();
    //FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    setState(() {
      userID = user.uid;
    });
    //});
    getUsername();
  }

  Future<dynamic> getUsername() async {
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      namedis = snapshot['name'];
      return namedis;
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
      'ME PLUS',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget productLink = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductPage())); //RegisterPage()));
        },
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          // width: MediaQuery.of(context).size.width / 2,
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Center(
              child: new Text("สินค้า",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xffFFCCFF), Color(0xffFFCC00),
                    //Color.fromRGBO(100, 80, 19, 20),
                    //Color.fromRGBO(200, 0, 3, 1),
                    //Color.fromRGBO(300, 0, 16, 1),
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
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );

    Widget packageLink = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Package(),
            // builder: (_) => Package(user: context.watch<LoginProvider>().user),
          ));
        },
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          //width: MediaQuery.of(context).size.width / 2,
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Center(
              child: new Text("การลงทุน",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
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
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );

    Widget signoutLink = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () async {
          //FirebaseAuth.instance.currentUser().then((firebaseUser) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User user = auth.currentUser;
          if (user == null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeBackPage()));
          } else {
            userObj.signOut();
            //Navigator.pushReplacement(
            //    context,
            //   MaterialPageRoute(
            //       builder: (BuildContext context) => HomePage()));
          }
          //});
        },
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          //width: MediaQuery.of(context).size.width / 2,
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Center(
              child: new Text("SIGN OUT",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
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
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );

    Widget showname = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () async {},
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          //width: MediaQuery.of(context).size.width / 2,
          width: MediaQuery.of(context).size.width,
          //decoration: BoxDecoration(
          //    image: DecorationImage(
          //        image: AssetImage('assets/card.jpg'), fit: BoxFit.cover)),

          height: 80,

          child: Center(
            child: Card(
              //color: Colors.transparent,
              // -- Card transparent --

              child: ListTile(
                // --- แสดงยอดเงิน ---
                title: new Text("คุณ : " + displayname),

                // subtitle: Text("ยอดเงินในบัญชี"),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,
            ),
          ),
          /*
          Padding(
            padding: EdgeInsets.all(30),
            child: Card(
              color: Colors.transparent, // -- Card transparent --
              child: ListTile(
                // --- แสดงยอดเงิน ---
                title: new Text("คุณ : " + displayname),
                // subtitle: Text("ยอดเงินในบัญชี"),
              ),
            ),
          ),
          */
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 2),
                welcomeBack,
                //Spacer(),
                //subTitle,
                showname,
                Spacer(flex: 1),
                productLink,
                Spacer(flex: 1),
                packageLink,
                signoutLink,
                Spacer(flex: 1),
                //forgotPassword
              ],
            ),
          )
        ],
      ),
    );
  }

/*
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }*/
}
