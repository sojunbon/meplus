import 'package:meplus/startscreen/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider.instance())
    ],
    child: MyApp(),
  ));
}


/*
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: SplashScreen(),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'screens/signin_page.dart';

void main() {
  runApp(FIrebaseAuthentication());
}

class FIrebaseAuthentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SigninPage(),
    );
  }
}
*/
