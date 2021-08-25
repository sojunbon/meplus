import 'dart:io' show Platform;
import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:meplus/screens/authen/register_page.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meplus/components/notification.dart';
import 'package:meplus/components/signin_button.dart';
import 'package:meplus/screens/shopping/mainsrc/main_page.dart';
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
import 'package:provider/provider.dart';

import 'package:meplus/screens/meplussrc/package/package.dart';
import 'package:meplus/services/usermngmt.dart';
//----- ME PLUS Main page -----
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';

class Melink extends StatefulWidget {
  final FirebaseUser user;

  @override
  _Melink createState() => _Melink();

  const Melink({Key key, this.user}) : super(key: key);
}

class _Melink extends State<Melink> {
  IconData get icon => null;
  UserManagement userObj = new UserManagement();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // initLineSdk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));
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

/*
    Widget signoutLink = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pop();

          await auth.signOut();
          userObj.signOut();

          // builder: (_) => Package(user: context.watch<LoginProvider>().user),
          // ));
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
    */

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
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 2),
                welcomeBack,
                //Spacer(),
                //subTitle,
                Spacer(flex: 1),
                productLink,
                Spacer(flex: 1),
                packageLink,
                //  signoutLink,
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
