import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/app_properties.dart';
import 'package:meplus/custom_background.dart';
import 'package:meplus/screens/authen/welcome_back_page.dart';

import 'package:flutter/material.dart';

import 'change_language_page.dart';
import 'package:meplus/services/usermngmt.dart';
import 'package:provider/provider.dart';
import 'package:meplus/providers/login_provider.dart';

import 'package:meplus/screens/meplussrc/profilepage/address_name.dart';

class SettingsPage extends StatefulWidget {
  // StatelessWidget {
  UserManagement userObj = new UserManagement();

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  String userID = "";
  User _user;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    //  setState(() {
    //    userID = user.uid;
    //  });
    //});
    _checkUser();
  }

  Future<void> _checkUser() async {
    _user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  Future logout() async {
    setState(() {
      isLoading = true;
    });
    await context.read<LoginProvider>().signOut().signOut().then(
        (value) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeBackPage()),
            (route) => false), setState(() {
      isLoading = true;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          title: Text(
            'Settings',
            style: TextStyle(color: darkGrey),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
              builder: (builder, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            /*Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'General',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('Language A / का'),
                              leading: Image.asset('assets/icons/language.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeLanguagePage())),
                            ),
                            ListTile(
                              title: Text('Change Country'),
                              leading: Image.asset('assets/icons/country.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeCountryPage())),
                            ),
                            ListTile(
                              title: Text('Notifications'),
                              leading:
                                  Image.asset('assets/icons/notifications.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          NotificationSettingsPage())),
                            ),
                            ListTile(
                              title: Text('Legal & About'),
                              leading: Image.asset('assets/icons/legal.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => LegalAboutPage())),
                            ),
                            ListTile(
                              title: Text('About Us'),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {},
                            ),
                            */
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'Account',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('ที่อยู่'),
                              leading: Image.asset('assets/icons/address.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => Address_name())),
                            ),
                            /*
                            ListTile(
                              title: Text('Change Password'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangePasswordPage())),
                            ),
                            */
                            ListTile(
                              title: Text('Sign out'),
                              leading: Image.asset('assets/icons/sign-out.png'),
                              onTap: () {
                                Navigator.of(context).pop();

                                //context.read<LoginProvider>().logout();
                                //userObj.signOut();
                                logout();
                                /*
                                if (_user == null) {
                                  return context
                                      .read<LoginProvider>()
                                      .signOut();
                                } else {
                                  return context
                                      .read<LoginProvider>()
                                      .signOut();
                                }
                                */
                              },
                              /* onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => WelcomeBackPage())), */
                            ),
                            Padding(
                              //left: MediaQuery.of(context).size.width / 4,
                              // top: 150,
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: isLoading
                                  ? Container(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                      ),
                                      color: Colors
                                          .transparent, //.withOpacity(0.8),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
