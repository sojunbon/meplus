import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';
import 'package:meplus/my_app.dart';
import 'package:provider/provider.dart';

//import 'forgot_password_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailString = TextEditingController(text: '');
  TextEditingController nameString = TextEditingController(text: '');
  TextEditingController passwordString = TextEditingController(text: '');
  //TextEditingController cmfPassword = TextEditingController(text: '');
  //String nameString, emailString, passwordString, cmfPassword;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String disname;
  String dismail;
  String dispass;

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Register / ลงทะเบียนสมาชิก',
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

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Create user name / สร้างสมาชิก',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 10,
      child: InkWell(
        onTap: () {
          // if (formKey.currentState.validate()) {
          // formKey.currentState.save();
          print(
              'name = $nameString,namesirname = $nameString, email = $emailString, password = $passwordString');

          // --- convert TextEditingController ---
          disname = nameString.text;
          dismail = emailString.text;
          dispass = passwordString.text;
          registerThread(dismail, dispass, disname);

          //MemainPage();
          // }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Register",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
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

    Widget registerForm = Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          Container(
            height: 230,
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
                    controller: emailString,
                    decoration: InputDecoration(hintText: 'Email'),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: nameString,
                    decoration: InputDecoration(hintText: 'ชื่อ - นามสกุล'),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: passwordString,
                    decoration: InputDecoration(hintText: 'รหัสผ่าน'),
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),

                /*
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: cmfPassword,
                    decoration:
                        InputDecoration(hintText: 'กรอกรหัสผ่านอีกครั้ง'),
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
                */
              ],
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.find_replace),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.white),
          ],
        )
      ],
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
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                title,
                //Spacer(),
                //subTitle,
                Spacer(flex: 2),
                registerForm,
                Spacer(flex: 2),
                Padding(
                    padding: EdgeInsets.only(bottom: 20), child: socialRegister)
              ],
            ),
          ),
          Positioned(
            top: 35,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> registerThread(
      String getmail, String getpassword, String getname) async {
    //String getmail = emailString.toString();
    //String getpassword = passwordString.toString();
    final FirebaseUser user =
        (await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: getmail, //emailString.toString(),
                password: getpassword)) //passwordString.toString()))
            .user;
    await Firestore.instance.collection("users").document(user.uid).setData({
      "name": getname, //nameString,
      "namesirname": getname, //nameString,
      "email": getmail, //emailString,
      "password": getpassword, //passwordString,
      "usertype": "user",
      "uid": user.uid,
      "bankname": "",
      "bankaccount": "",
      "phone": "",
      "active": true,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp()
    }).catchError((response) {
      print('response = ${response.toString()}');
      String title = response.code;
      String message = response.message;
      myAlert(title, message);
    });
    //String title = "Save";
    //String message = "Create user complete,please press back button.";
    //showAlertDialog(context);
  }

  void myAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MemainPage(user: context.watch<LoginProvider>().user)));

        //MaterialPageRoute materialPageRoute = MaterialPageRoute(
        //    builder: (BuildContext context) =>
        //       MemainPage(user: context.watch<LoginProvider>().user));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("บันทึก"),
      content: Text("สร้างผู้ใช้เรียบร้อย กรุณากดปุ่ม Back"),
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
//------------------------------------------------------

}
