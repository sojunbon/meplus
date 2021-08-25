import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/providers/login_provider.dart';
//import 'package:meplus/screen/login_screen.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';
//import 'package:meplus/screen/firstpage.dart';
import 'package:meplus/screens/shopping/mainsrc/main_page.dart';
//import '../loginpage.dart';
//import '../dashboard.dart';
import 'package:meplus/screens/adminpage/dashboard.dart';
//import '../adminonly.dart';
/*
import 'package:meplus/screen/configapps.dart';
import 'package:meplus/screen/picqr.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:meplus/providers/logger_service.dart';
*/

class UserManagement {
  BehaviorSubject currentUser = BehaviorSubject<String>.seeded('user');

  Widget handleAuth() {
    return new StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.uid);
          currentUser.add(snapshot.data.uid);
          return WelcomeBackPage();
          //DashboardPage(); //DashboardPage();
        }
        return WelcomeBackPage();
        //LoginPage(); //LoginPage();
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  /*
  authorizeAdmin(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        if (docs.documents[0].exists) {
          // if (docs.documents[0].data['role'] == 'admin') {
          if (docs.documents[0].data['usertype'] == 'admin') {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new AdminPage()));
          } else {
            //print('Not Authorized');
            showMessageBox(context, "มีสิทธิ์เข้าใช้งานเฉพาะ Admin", "",
                actions: [dismissButton(context)]);
            logger.i("Warning");
          }
        }
      });
    });
  }

  authorizePic(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        if (docs.documents[0].exists) {
          if (docs.documents[0].data['usertype'] == 'admin') {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new Picqr()));
          } else {
            //print('Not Authorized');
            showMessageBox(context, "มีสิทธิ์เข้าใช้งานเฉพาะ Admin", "",
                actions: [dismissButton(context)]);
            logger.i("Warning");
            //}).catchError((e) {
            //logger.e(e);
            //});

            //Navigator.push(
            //    context,
            //    new MaterialPageRoute(
            //        builder: (BuildContext context) => new MyHomePage()));
          }
        }
      });
    });
  }

  authorizeConf(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        if (docs.documents[0].exists) {
          if (docs.documents[0].data['usertype'] == 'admin') {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new Configapps()));
          } else {
            showMessageBox(context, "มีสิทธิ์เข้าใช้งานเฉพาะ Admin", "",
                actions: [dismissButton(context)]);
            logger.i("Warning");
          }
        }
      });
    });
  }
  */

}
