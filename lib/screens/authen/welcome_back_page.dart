import 'dart:io' show Platform;
import 'package:flushbar/flushbar.dart';
import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
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
import 'package:meplus/services/usermngmt.dart';
//----- ME PLUS Main page -----
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';

class WelcomeBackPage extends StatefulWidget {
  WelcomeBackPage({Key key}) : super(key: key);
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  IconData get icon => null;
  final _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // initLineSdk();
    //setState(() { userStatus = null; });
    super.initState();
  }

  TextEditingController email = TextEditingController(text: "");

  TextEditingController password = TextEditingController(text: "");
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement userObj = new UserManagement();

  bool isLoading = false;

  void _showLoadingIndicator() {
    print('isloading');
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        isLoading = false;
      });
      print(isLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      '\nME PLUS',
      style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            ),
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login to your account using email',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ));

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 190,
      key: _key,
      child: InkWell(
        /*
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));
        },
        */
        // -------- Me plus Login -------
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          if (!await context
              .read<LoginProvider>()
              .login(email.text.trim(), password.text.trim())) {
            _key.currentState;
            /*
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              message: "กรอก username/password ผิด'",
              duration: Duration(seconds: 3),
            ).show(context);
            */
            //_key.currentState.showSnackBar(
            //    SnackBar(content: Text('กรอก username/password ผิด')));
            //showAlertDialog(context);

            //showModalAlertDialog(context);

          }
          setState(() {
            isLoading = true;
          });
          /*
          FirebaseAuth.instance.currentUser().then((firebaseUser) async {
            if (firebaseUser == null) {
              userObj.signOut();
              if (!await context
                  .read<LoginProvider>()
                  .login(email.text.trim(), password.text.trim())) {
                _key.currentState;
                // .showSnackBar(SnackBar(content: Text('Unable to login.')));
              }
            } else {
              userObj.signOut();
              if (!await context
                  .read<LoginProvider>()
                  .login(email.text.trim(), password.text.trim())) {
                _key.currentState;
                // .showSnackBar(SnackBar(content: Text('Unable to login.')));
              }
            }
          });*/
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Log In",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
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
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget loader = Positioned(
      //left: MediaQuery.of(context).size.width / 4,
      //bottom: 0,

      child: Stack(
        children: <Widget>[
          Positioned(
            left: 165, //left: MediaQuery.of(context).size.width / 4,
            top: 10,
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    color: Colors.transparent, //.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    );

    Widget registerMember = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 100,
      child: InkWell(
        onTap: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => RegisterPage());
          Navigator.of(context).push(materialPageRoute);

          //Navigator.of(context)
          //   .push(MaterialPageRoute(builder: (_) => RegisterPage()));
        },
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Register",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(280, 90, 3, 1),
                    Color.fromRGBO(280, 90, 3, 1),
                    Color.fromRGBO(280, 90, 16, 1),
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
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget registerPhone = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 80,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));
        },
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Register",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(300, 230, 3, 1),
                    Color.fromRGBO(200, 230, 3, 1),
                    Color.fromRGBO(100, 78, 16, 1),
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
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget registerApple = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 10,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));
        },
        child: Container(
          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Apple ID",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(120, 60, 3, 1),
                    Color.fromRGBO(100, 60, 3, 1),
                    Color.fromRGBO(108, 78, 16, 1),
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
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget loginForm = Container(
      height: 400,
      child: Stack(
        children: <Widget>[
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Email'),
                    controller: email,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Password'),
                    controller: password,
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          loginButton,
          loader,
          registerMember,
          //registerPhone,
          registerApple,
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Reset password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.grey,
        child: Stack(
          // alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover)),
              ),
            ),
            Padding(
              //padding: EdgeInsets.only(
              //    bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: const EdgeInsets.only(left: 28.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    welcomeBack,
                    subTitle,
                    loginForm,
                    //forgotPassword
                  ],
                ),
              ),
            ),
            /*
            Positioned(
              //top: 5,
              //left: 0.0,
              child: Container(
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: transparentYellow,
                ),

                
              ),
            ),
            */
          ],
        ),
      ),
    );

    // ---- End Scaffold ----
  }

  /*
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
                Spacer(flex: 3),
                welcomeBack,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                loginForm,
                // Spacer(flex: 2),
                //registerMember,
                Spacer(flex: 2),
                forgotPassword
              ],
            ),
          )
        ],
      ),
    );
  */

  void showModalAlertDialog(BuildContext context) {
    showModalBottomSheet(
      enableDrag: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.amber,
      context: context,
      isDismissible: false, // ***** control Modal *****
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        onVerticalDragDown: (_) {}, // *** ไม่ให้ modal hide  control Modal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            SizedBox(
              height: 15.0, //8.0,
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Center(
                    child: Text('กรอก username/password ผิด',
                        style: const TextStyle(
                            color: const Color(0xfff36600),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0)))),
            SizedBox(height: 20),
            Container(
              height: 100,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(''),
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        FirebaseAuth.instance
                            .currentUser()
                            .then((firebaseUser) {
                          if (firebaseUser == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WelcomeBackPage()));
                          } else {
                            userObj.signOut();
                          }
                        });
                        /*
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WelcomeBackPage()));
                                    */
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        //Navigator.push(
        FirebaseAuth.instance.currentUser().then((firebaseUser) {
          if (firebaseUser == null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeBackPage()));
          } else {
            userObj.signOut();
          }
        });
      },
    );

    //BottomSheet BottomSheetalert = BottomSheet(
    //    builder: (context) => Container(
    //          color: Colors.red,
    //        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("แจ้งเตือน"),
      content: Text("กรอก username/password ผิด"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

/*
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
  */
}
