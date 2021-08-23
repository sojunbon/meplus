import 'package:flutter/material.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:provider/provider.dart';
//import './screen/firstpage.dart';
//import './screen/adminpage.dart';
//import './screen/login_screen.dart';
//import './screen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/startscreen/splash_page.dart';

//import 'package:meplus/screens/main_page.dart';
import 'package:meplus/screens/shopping/mainsrc/main_page.dart';

import 'package:meplus/screens/authen/welcome_back_page.dart';
import 'package:meplus/models/user.dart';

//----- ME PLUS Main page -----
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';

class MyApp extends StatelessWidget {
  // UserManagement userObj = new UserManagement();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ME PLUS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.transparent,
        primarySwatch: Colors.blue,
        fontFamily: "Montserrat",
      ),
      home: _showScreen(context), //SplashScreen(),
      //home: userObj.handleAuth(),
    );
  }
}

Widget _showScreen(BuildContext context) {
  final usertab = (context.watch<LoginProvider>().user);

  String getusertype;
  String getuid;

  switch (context.watch<LoginProvider>().appState) {
    case AppState.authenticating:
    case AppState.unauthenticated:
      return WelcomeBackPage(); //LoginScreen();
    case AppState.initial:
      return SplashScreen();
    case AppState.authenticated:
      //  return MainPage(user: context.watch<LoginProvider>().user);
      return MemainPage(user: context.watch<LoginProvider>().user);

    //MyHomePage(user: context.watch<LoginProvider>().user);
  }
  return Container();
}
