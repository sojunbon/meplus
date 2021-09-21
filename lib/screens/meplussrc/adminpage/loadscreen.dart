/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

final themeColor = new Color(0xfff5a623);
final primaryColor = new Color(0xff203152);
final greyColor = new Color(0xffaeaeae);
final greyColor2 = new Color(0xffE8E8E8);

class LoadindScreen extends StatefulWidget {
  LoadindScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoadindScreen> {
  SharedPreferences prefs;

  bool isLoading = false;

  Future<Null> handleSignIn() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    var isLoadingFuture = Future.delayed(const Duration(seconds: 3), () {
      return false;
    });
    isLoadingFuture.then((response) {
      setState(() {
        isLoading = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ));
  }
}
*/
