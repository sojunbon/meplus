import 'package:flutter/material.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';
import 'package:meplus/screens/meplussrc/products/meproducts.dart';
import 'package:meplus/screens/meplussrc/package/package.dart';

//import 'package:happymoney/ui/auth/sign_in_screen.dart';
//import 'package:happymoney/ui/setting/setting_screen.dart';
//import 'package:happymoney/ui/splash/splash_screen.dart';
//import 'package:happymoney/ui/todo/create_edit_todo_screen.dart';
//import 'package:happymoney/ui/todo/todos_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  // static const String splash = '/splash';
  static const String meproduct = '/meproduct';
  static const String package = '/package';
  static const String login = '/login';
  // static const String home = '/home';
  //static const String setting = '/setting';
  //static const String create_edit_todo = '/create_edit_todo';

  static final routes = <String, WidgetBuilder>{
    //  splash: (BuildContext context) => SplashScreen(),
    meproduct: (BuildContext context) => Meproducts(),
    package: (BuildContext context) => Package(),
    login: (BuildContext context) => WelcomeBackPage(),
    //  home: (BuildContext context) => TodosScreen(),
    // setting: (BuildContext context) => SettingScreen(),
    //  create_edit_todo: (BuildContext context) => CreateEditTodoScreen(),
  };
}
