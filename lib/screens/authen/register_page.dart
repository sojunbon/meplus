import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meplus/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meplus/components/show_notification.dart';
import 'package:meplus/providers/logger_service.dart';

import 'package:meplus/screens/authen/welcome_back_page.dart';
import 'package:meplus/screens/meplussrc/category/melink.dart';
import 'package:meplus/screens/meplussrc/mainpage/memain_page.dart';
import 'package:meplus/my_app.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:meplus/services/usermngmt.dart';
import 'package:meplus/screens/authen/dropdownlist.dart';

import 'package:meplus/screens/authen/components/referfriend_control.dart';
//import 'package:meplus/providers/add_money_service.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'forgot_password_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailString = TextEditingController(text: '');
  TextEditingController nameString = TextEditingController(text: '');
  TextEditingController passwordString = TextEditingController(text: '');
  TextEditingController banknamestr = TextEditingController(text: '');
  TextEditingController bankacctstr = TextEditingController(text: '');
  TextEditingController mobilestr = TextEditingController(text: '');
  TextEditingController phonereferstr = TextEditingController(text: '');

  //TextEditingController cmfPassword = TextEditingController(text: '');
  //String nameString, emailString, passwordString, cmfPassword;
  //final formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  //final formKey = new GlobalKey();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement userObj = new UserManagement();
  String getmobile;
  String disname;
  String dismail;
  String dispass;
  String disbank;
  String disacct;
  String disphone;
  String disrefer;
  var selectbank, selectedType;
  DocumentSnapshot currentCategory;
  String categoryname;
  String selectbankname;
  String userID = "";
  String getMobile;
  DocumentSnapshot snapshotphone;
  String checkphoneExist;
  bool loading = false;
  bool isLoading = false;
  String cat_mob;
  String con_mob;
  FocusNode _titleFocus;

  var firstColor = Color(0xffCCCC00), secondColor = Color(0xffCCCC00);
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    final FirebaseAuth auth = FirebaseAuth.instance;
    //final User user = auth.currentUser;

    //final User user = Provider.of<User>(context);
    // print(user.uid);

    //FirebaseAuth.instance.currentUser().then((User user) {
    setState(() {
      //userID = user.uid;
      loading = false;
    });

    getData();
    checkPhoneSnap(mobilestr.text);
    //checkPhone();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();

    super.dispose();
  }

  Future<dynamic> checkPhoneSnap(String phone) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
    FirebaseFirestore.instance
        .collection("referfriend")
        .doc(phone)
        .snapshots()
        .listen((snapshot) {
      getMobile = snapshot['mobile'];
      return getMobile;
    });
  }

  getDataPhone(String phone) async {
    final phonesnap = await FirebaseFirestore.instance
        .collection('referfriend')
        .doc(phone)
        .get();

    //DocumentSnapshot snapshot = phonesnap.data['mobile'];
    snapshotphone = phonesnap['mobile'];

    print(snapshotphone);
    //return snapshotphone;
    return ListTile(
      title: Text("$snapshotphone"),
    );
  }

  dynamic data;
  Future<dynamic> getData() async {
    User user = FirebaseAuth.instance.currentUser;

    final DocumentReference document =
        FirebaseFirestore.instance.collection("users").doc(user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  dynamic datacheckmobi;
  Future<dynamic> checkPhone(String phone) async {
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final DocumentReference document =
        FirebaseFirestore.instance.collection("referfriend").doc(phone);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        datacheckmobi = snapshot.data;
      });
    });
  }

  Future<QuerySnapshot> getmobie(String _mobile) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('mobile', isEqualTo: _mobile)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      '  \nลงทะเบียนสมาชิก',
      style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
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
      bottom: 0,
      child: InkWell(
        onTap: () {
          //if (formKey.currentState.validate()) {
          //  formKey.currentState.save();
          print(
              'name = $nameString,namesirname = $nameString, email = $emailString, password = $passwordString , bankname = $selectbankname , bankaccount = $bankacctstr , phone = $mobilestr  , mobilerefer = $phonereferstr ');

          // --- convert TextEditingController ---
          disname = nameString.text;
          dismail = emailString.text;
          dispass = passwordString.text;
          disbank = selectbankname;
          //banknamestr.text;
          disacct = bankacctstr.text;
          disphone = mobilestr.text;
          disrefer = phonereferstr.text;

          registerThread(
              dismail, dispass, disname, disbank, disacct, disphone, disrefer);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Center(
              child: new Text("Register",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0))),
          /*
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
              */
        ),
      ),
    );

    Widget DropDown = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 80,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => Dropdownlist()));
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
                      fontSize: 16.0))),
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

    Widget registerForm = Container(
      height: 500,
      child: Stack(
        children: <Widget>[
          Container(
            height: 1000,
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
                    controller: mobilestr,
                    decoration: InputDecoration(hintText: 'เบอร์โทรศัพท์'),
                    style: TextStyle(fontSize: 14.0),
                    keyboardType: TextInputType.number,
                  ),
                ),
                /*
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: emailString,
                    decoration: InputDecoration(hintText: 'Email'),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                */
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: nameString,
                    decoration: InputDecoration(hintText: 'ชื่อ - นามสกุล'),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: passwordString,
                    decoration:
                        InputDecoration(hintText: 'รหัสผ่าน 6 ตัวอักษร'),
                    style: TextStyle(fontSize: 14.0),
                    obscureText: true,
                  ),
                ),
                /*
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: banknamestr,
                    decoration: InputDecoration(hintText: 'ธนาคาร'),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                */
                // ----------------- Dropdown select BANK ---------------------
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("banktable")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();

                      {
                        List<DropdownMenuItem> currencyItems = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data.docs[i];
                          var getbankname = snapshot.data.docs[i]['bankname'];

                          currencyItems.add(
                            DropdownMenuItem(
                              child: Text(
                                snapshot.data.docs[i]['bankname'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              value: "${getbankname}",
                            ),
                          );
                        }
                        return Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "ธนาคาร",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                //fontWeight: FontWeight.w600
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              //Icon(FontAwesomeIcons.building,
                              //    size: 25.0, color: Color(0xff5b86e5)),

                              //SizedBox(width: 200.0),
                              //padding: EdgeInsets.all(15),

                              child: DropdownButton(
                                value: selectbankname,
                                items: <String>[
                                  for (int i = 0;
                                      i < snapshot.data.docs.length;
                                      i++)
                                    snapshot.data.docs[i]['bankname'],
                                  /*
                                'ธนาคารกสิกรไทย',
                                'ธนาคารกรุงเทพ',
                                'ธนาคารกรุงไทย',s
                                'ธนาคารออมสิน',
                                'ธนาคารไทยพานิชย์',
                                'ธนาคารทหารไทย',
                                'ธนาคารกรุงศรีอยุธยา',
                                'ธนาคารธนชาติ',
                                'ธนาคารยูโอบี',
                                */
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                elevation: 8,
                                icon: Icon(Icons.arrow_drop_down_circle),
                                dropdownColor: Colors.amber,

                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                //isExpanded: true,
                                onChanged: (String value) {
                                  final snackBar = SnackBar(
                                    content: Text(
                                      'เลือกธนาคาร $value',
                                      style:
                                          TextStyle(color: Color(0xff5b86e5)),
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    selectbankname = value;
                                    //banknamestr =
                                    //    selectbankname as TextEditingController;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    }),

                // ------------------------------------------------------------

                // ซ่อน ข้อความ Text field
                Visibility(
                  // showing the child widget
                  visible: false,

                  child: TextFormField(
                    initialValue: selectbankname,
                    //controller: banknamestr,
                    enabled: false,

                    decoration: const InputDecoration(
                      icon: const Icon(Icons.comment_bank),
                      hintText: 'ธนาคาร',
                      labelText: 'ธนาคาร',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: bankacctstr,
                    decoration: InputDecoration(hintText: 'เลขบัญชี'),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                /*
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: mobilestr,
                    decoration: InputDecoration(hintText: 'เบอร์โทรศัพท์'),
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.number,
                  ),
                ),
                */
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: phonereferstr,
                    decoration:
                        InputDecoration(hintText: 'เบอร์โทรศัพท์ ผู้แนะนำ'),
                    style: TextStyle(fontSize: 14.0),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),

                NiceButton(
                  radius: 40,
                  padding: const EdgeInsets.all(8),
                  text: "บันทึก",
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    cat_mob = mobilestr.text;
                    con_mob = cat_mob + '@mail.com';
                    print(
                        'name = $nameString,namesirname = $nameString, email = $con_mob, password = $passwordString , bankname = $selectbankname , bankaccount = $bankacctstr , phone = $mobilestr  , mobilerefer = $phonereferstr ');

                    //print(
                    //    'name = $nameString,namesirname = $nameString, email = $emailString, password = $passwordString , bankname = $selectbankname , bankaccount = $bankacctstr , phone = $mobilestr  , mobilerefer = $phonereferstr ');

                    // --- convert TextEditingController ---

                    disname = nameString.text;
                    dismail = con_mob; // emailString.text;
                    dispass = passwordString.text;
                    disbank = selectbankname;
                    //banknamestr.text;
                    disacct = bankacctstr.text;
                    disphone = mobilestr.text;
                    disrefer = phonereferstr.text;

                    registerThread(dismail, dispass, disname, disbank, disacct,
                        disphone, disrefer);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 180,
            //left: MediaQuery.of(context).size.width / 6,
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
          // registerButton,
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
    // --- ปิดใช้งานหรือแทนที่ปุ่ม "ย้อนกลับ" ของ Android ---
    //return new WillPopScope(
    //  onWillPop: () async => false,
    // child: new Scaffold(
    // ปิดใช้งานหรือแทนที่ปุ่ม "ย้อนกลับ" ของ Android

    return Scaffold(
      key: formKey,
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
                    //Spacer(flex: 2),
                    title,
                    //Spacer(),
                    //subTitle,
                    //Spacer(flex: 2),
                    registerForm,
                    //socialRegister,
                    //registerButton,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // ---- End Scaffold ----
  }

  /*
return Scaffold(
      key: formKey,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
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
                Spacer(flex: 2),
                title,
                //Spacer(),
                //subTitle,
                //Spacer(flex: 2),
                registerForm,
                Spacer(flex: 1),
                registerButton,
                //DropDown,
                Spacer(),
                //Spacer(flex: 1),
                // Padding(
                //     padding: EdgeInsets.only(bottom: 20),
                //     child: socialRegister)
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
  */

  Future<void> registerThread(
      String getmail,
      String getpassword,
      String getname,
      String getbank,
      String getbankname,
      String getphone,
      String getrefer) async {
    //String getmail = emailString.toString();
    //String getpassword = passwordString.toString();

    String phoneExist = "";
    String phoneExistPrimary;
    bool checkstate;
    var documentdata;
    String phoneExistTxt = "";

    String phoneUserRefer;
    String phoneUserPrimary;
    String phoneUser;
    String userid_new;
    String userid_refer;

    String bankname_refer;
    String bankacct;
    String namexx;

    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshotuser =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshotuser.docs.length; i++) {
      var userphongap = querySnapshotuser.docs[i];
      phoneUserPrimary = userphongap["mobile"];

      if (phoneUserPrimary == getrefer) {
        phoneUserRefer = phoneUserPrimary;
        userid_refer = userphongap["uid"];
        bankname_refer = userphongap["bankname"];
        bankacct = userphongap["bankaccount"];
        namexx = userphongap["name"];
      } else {
        phoneUser = "";
      }
      print(userphongap.id);
    }

    /*
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("referfriend").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var phongap = querySnapshot.documents[i];
      checkphoneExist = phongap.data["mobile"];

      if (checkphoneExist == getphone) {
        phoneExistPrimary = checkphoneExist;
        checkstate = true;
      } else {
        phoneExist = "";
        checkstate = false;
      }
      print(phongap.documentID);
    }
    */

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var phongap = querySnapshot.docs[i];
      checkphoneExist = phongap["mobile"];

      if (checkphoneExist == getphone) {
        phoneExistPrimary = checkphoneExist;
        //userid_new = phongap.data["uid"];
        checkstate = true;
      } else {
        phoneExist = "";
        //userid_new = phongap.data["uid"];
        checkstate = false;
      }
      print(phongap.id);
    }

    if (phoneExistPrimary == getphone) {
      showAlertMobile(context);
    }

    if (phoneExistPrimary == null) {
      final User user =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: getmail, //emailString.toString(),
                  password: getpassword)) //passwordString.toString()))
              .user;

      /*
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: getmail, //emailString.toString(),
                  password: getpassword)) //passwordString.toString()))
              .user;
      */

      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "name": getname, //nameString,
        "namesirname": getname, //nameString,
        "email": getmail, //emailString,
        "password": getpassword, //passwordString,
        "usertype": "user",
        "uid": user.uid,
        "bankname": getbank,
        "bankaccount": getbankname,
        "phone": getphone,
        "active": true,
        "mobile": getphone,
        "mobilerefer": getrefer,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
        "sumtotal": 0,
        "sumpayment": 0,
        "sumwithdraw": 0,
        "address": "",
      }).catchError((response) {
        print('response = ${response.toString()}');
        String title = 'แจ้งเตือน';
        String message = 'เบอร์โทรนี้เคยลงทะเบียนแล้ว';
        myAlert(title, message);
      });
      showModalAlertDialog(context);
    }

    String checknewuid;
    QuerySnapshot querySnapshotNewUser =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshotNewUser.docs.length; i++) {
      var newusersnap = querySnapshotNewUser.docs[i];
      checknewuid = newusersnap["mobile"];

      if (checknewuid == getphone) {
        userid_new = newusersnap["uid"];
      } else {
        //userid_new = phongap.data["uid"];
      }
      print(newusersnap.id);
    }
    if (phoneUserRefer != null && phoneExistPrimary == null) {
      addReferFriend(
        context,
        {
          "uid": userid_new,
          "mobile": disphone,
          "uid_refer": userid_refer,
          "mobile_refer": disrefer,
          "bankname_refer": bankname_refer,
          "bankaccount_refer": bankacct,
          "name": namexx,
          "paytype": 4, // แนะนำเพื่อน
          "payment": false,
          "active": false,
          "createdate": FieldValue.serverTimestamp(),
        },
      );
    }

    setState(() {
      isLoading = false;
    });

    //String title = "Save";
    //String message = "Create user complete,please press back button.";

    // ---- Insert refer friend ----
    //generateReferFriend(context, getphone, getrefer, user.uid);

    //showModalAlertDialog(context);
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

  void showAlertMobile(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        //child: Text("OK"),

        onPressed: () => Navigator.of(context).pop(true),
        child: Text('OK'));
    //onPressed: () => Navigator.of(context)
    //    .push(MaterialPageRoute(builder: (_) => WelcomeBackPage())),

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("แจ้งเตือน"),
      content: Text("เบอร์โทรศัพท์นี้ลงทะเบียนบนระบบแล้ว"),
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

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            //Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MemainPage(user: context.watch<LoginProvider>().user)));
      },
    );

    //BottomSheet BottomSheetalert = BottomSheet(
    //    builder: (context) => Container(
    //          color: Colors.red,
    //        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("บันทึก"),
      content: Text("สร้างผู้ใช้เรียบร้อย"),
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

  void showModalAlertDialog(BuildContext context) {
    showModalBottomSheet(
      enableDrag: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.amber,
      context: context,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        //Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 18),
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
                    child: Text('บันทึกข้อมูลเรียบร้อย',
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
                        //FirebaseAuth.instance
                        //  .currentUser()
                        //  .then((firebaseUser)
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final User user = auth.currentUser;
                        // {
                        if (user == null) {
                          //userObj.signOut();
                          context.watch<LoginProvider>().signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WelcomeBackPage()));
                        } else {
                          Navigator.push(
                              //Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MemainPage(
                                      user: context
                                          .watch<LoginProvider>()
                                          .user)));
                        }
                        //}
                        //);
                        /*
                        Navigator.push(
                            //Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemainPage(
                                    user:
                                        context.watch<LoginProvider>().user)));
                        */

                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeBackPage()));
                        */
                        //Navigator.of(context).push(MaterialPageRoute(
                        //    builder: (_) => MemainPage(
                        //        user: context.watch<LoginProvider>().user)));
                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemainPage(
                                    user:
                                        context.watch<LoginProvider>().user)));
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
            /*
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(
                    //Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemainPage(
                            user: context.watch<LoginProvider>().user)));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  //padding: const EdgeInsets.only(left: 32.0, right: 12.0),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            )
            */
          ],
        ),
      ),
      isDismissible: false, // *************** control Modal *******************
      //isScrollControlled: true,
    );
  }

//------------------------------------------------------
  /*
  void checkPhoneNumber(String mobilenum, String other) => {
        //String getmobile;

        Firestore.instance
            .collection('users')
            .where("mobile", isEqualTo: mobilenum)
            .snapshots()
            .listen((snapshot) {
          snapshot.documents.forEach((result) {
            //getmobile = result.data('mobile');
            other = result.data['mobile'];
            return other;
          });
        })
      };

void foo() async {
  final getmob = await checkPhoneNumber(this.mobilestr.text);
}
  */

}
