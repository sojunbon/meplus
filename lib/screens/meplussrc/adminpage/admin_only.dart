import 'package:meplus/screens/meplussrc/adminpage/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:meplus/screens/meplussrc/package/topupmoney_admin.dart';
import 'package:meplus/screens/meplussrc/package/topuplist.dart';
import 'package:meplus/screens/meplussrc/package/paymentlist_admin.dart';
import 'package:meplus/screens/meplussrc/adminpage/configtab.dart';
import 'package:meplus/screens/meplussrc/products/add_products.dart';
import 'package:meplus/screens/meplussrc/products/orders_list_admin.dart';
import 'package:meplus/screens/meplussrc/adminpage/admin_mainpage.dart';

class AdminPage extends StatefulWidget {
  //final FirebaseUser user;
  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  int _currentIndex = 0;
  PageController _pageController;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      //appBar: AppBar(title: Text("Admin menu")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Admin_mainpage(), //Topupmoney(),
            Topupmoney(),
            Paymentlist(),
            //Addproducts(), //Topupmoney(),
            OrderlistAdmin(), //Topupmoney(),
            Configtab(),

            //Historyadmin(),
            //Payment(),
            //Paymenthistory(),
            //Newsadd(),

            //Home(),
            //History(),
            //Newsupdate(),
            //Profile(),
            //Profile(user: context.watch<LoginProvider>().user),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('เมนู'), icon: Icon(Icons.menu)),
          BottomNavyBarItem(
              title: Text('เติมเงิน'),
              icon: Icon(Icons.account_balance_wallet)),
          BottomNavyBarItem(
              title: Text('จ่ายเงิน'), icon: Icon(Icons.assessment)),
          BottomNavyBarItem(
              title: Text('คำสั่งซื้อ'), icon: Icon(Icons.accessibility)),
          BottomNavyBarItem(
              title: Text('เงื่อนไข'),
              icon: Icon(Icons.business_center_rounded)),
          //BottomNavyBarItem(
          //    title: Text('ข่าวสาร'), icon: Icon(Icons.chat_bubble)),
          //BottomNavyBarItem(
          //    title: Text('โปรไฟล์'), icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }
}
