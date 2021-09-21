import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:meplus/app_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:meplus/components/notification.dart';
//import 'package:meplus/components/show_notification.dart';
import 'package:flutter/services.dart';
//import 'package:meplus/providers/add_money_service.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:nice_button/nice_button.dart';
import 'package:meplus/providers/login_provider.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:meplus/services/usermngmt.dart';
import 'package:meplus/models/useritem.dart';
import 'package:meplus/screens/authen/register_page.dart';
import 'package:meplus/screens/meplussrc/package/components/money_control.dart';
//import 'forgot_password_page.dart';

class Package extends StatefulWidget {
  //final String name;
  //final String email;
  FirebaseUser user;

  //Package({Key key, @required this.name, @required this.email})
  //     : super(key: key);

  //Package({Key key, this.user}) : super(key: key);
  Package({Key key}) : super(key: key);
  @override
  _Package createState() => _Package();

  //Package({Key key, this.user}) : super(key: key);
}

class _Package extends State<Package> {
  UserManagement userObj = new UserManagement();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File _imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  //TextEditingController email=TextEditingController(text: 'example@email.com');
  //TextEditingController password = TextEditingController(text: '12345678');
  //TextEditingController cmfPassword = TextEditingController(text: '12345678');

  TextEditingController tradeamount = TextEditingController();
  //TextEditingController password = TextEditingController();
  //TextEditingController cmfPassword = TextEditingController();
  String userID = "";

  String namedis;
  Firestore _db = Firestore.instance;
  TabController tabController;
  var percent;
  var count;
  var percenta;
  var percentb;
  var percentc;
  var percentd;
  var perday;

  var desca;
  var descb;
  var descc;
  var descd;

  String formatdate;

  var bankname_trans;
  var bankacct_trans;
  var nametrans;

  ClipboardData datab;
  bool isLoading = false;
  String imageUrl;
  Future pickImage(context) async {
    //Future pickImage() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);

    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    //.child('uploads/${Path.basename(_imageFile.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl = fileURL;
        isLoading = false;
      });
    });

    /*
    //Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    imageUrl = await taskSnapshot.ref.getDownloadURL();
    */

    //taskSnapshot.ref.getDownloadURL().then(
    //      (value) => imageUrl = value,
    //    );

    //StorageUploadTask uploadTask = ref.putFile(avatarImageFile);
    //StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    //String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  }

  dynamic data;
  Future<dynamic> getData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final DocumentReference document =
        Firestore.instance.collection("users").document(user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  Future<dynamic> getUsername() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .snapshots()
        .listen((snapshot) {
      namedis = snapshot.data['name'];
      return namedis;
    });
  }

/*
  dynamic datadesc;
  Future<dynamic> getDesc() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final DocumentReference document =
        Firestore.instance.collection("packagedesc").document('desc');

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        datadesc = snapshot.data;
      });
    });
  }
  */

  dynamic datadesc;
  Future getDescription() async {
    final DocumentReference getpackage =
        Firestore.instance.collection("packagedesc").document('desc');

    await getpackage.get().then<dynamic>((DocumentSnapshot getsnapshot) async {
      setState(() {
        datadesc = getsnapshot.data;
        desca = datadesc['desca'];
        descb = datadesc['descb'];
        descc = datadesc['descc'];
        descd = datadesc['descd'];
        bankname_trans = datadesc['bankname'].toString();
        bankacct_trans = datadesc['bankaccount'].toString();
        nametrans = datadesc['name'];

        //datab = ClipboardData(text: bankacct_trans.toString());
        //Clipboard.setData(datab);
      });
    });

    Future<void> _copyToClipboard() async {
      await Clipboard.setData(ClipboardData(text: bankacct_trans.toString()));
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(datab.toString()),
      ));
    }

    /*
    DocumentSnapshot ds = await Firestore.instance
        .collection('packagedesc')
        .document('desc')
        .get();
    final datadesc = ds.data; //do something with document snapshot

    return datadesc;
    
    DateTime serverdate = await NTP.now();
    DateTime.utc(
      serverdate.year,
      serverdate.month,
      serverdate.day,
    ).add(Duration(days: 1));

    formatdate = DateFormat('dd/MM/yyyy').format(serverdate);
    */
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userID = user.uid;
      });
    });

    getData();
    //getDesc();
    getCal();
    getDescription();
    // getUsername();
  }

  void getCal() async {
    final db = Firestore.instance;
    await db
        .collection('conftab')
        .document('conf')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      count = documentSnapshot.data['count'];
      percenta = documentSnapshot.data['percenta'];
      percentb = documentSnapshot.data['percentb'];
      percentc = documentSnapshot.data['percentc'];
      percentd = documentSnapshot.data['percentd'];
      perday = documentSnapshot.data['perday'];
    });
  }

  /*
  void getDesc() async {
    final db = Firestore.instance;
    await db
        .collection('packagedesc')
        .document('desc')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      desca = documentSnapshot.data['desca'];
      descb = documentSnapshot.data['descb'];
      descc = documentSnapshot.data['descc'];
      descd = documentSnapshot.data['descd'];
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    String displayname;
    String desc1;
    String desc2;
    String desc3;
    String desc4;

    if (namedis == null) {
      displayname = "-";
    } else {
      displayname = namedis;
    }

    if (desca == null) {
      desc1 = " ";
    } else {
      desc1 = desca;
    }

    if (descb == null) {
      desc2 = " ";
    } else {
      desc2 = descb;
    }

    if (descc == null) {
      desc3 = " ";
    } else {
      desc3 = descc;
    }

    if (descd == null) {
      desc4 = " ";
    } else {
      desc4 = descd;
    }

/*
    Widget title = Text(
      '\n' + '\nPACKAGE',
      style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );
*/

    Widget title = Positioned(
      //padding: const EdgeInsets.only(right: 56.0),
      //bottom: 0,
      height: 150,
      width: 380,
      top: 50,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FractionalTranslation(
              translation: Offset(0, -0.5),
              child: Container(
                width: 500,
                height: 100,
                child: Center(
                    child: Text(
                  '\n' + '\nPACKAGE',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );
/*
    Widget subTitle = Padding(
      padding: const EdgeInsets.only(right: 56.0),
      child: Text(
        //data['name'] +
        //' รายละเอียดการลงทุน \n ฝาก 100 ปันผล 3.5 บาท/วัน \n ฝาก 1,000 ปันผล 35 บาท/วัน \n ฝาก 10,000 ปันผล 350 บาท/วัน \n ฝาก 100,000 ปันผล 3,500 บาท/วัน '

        'รายละเอียดการลงทุน \n' +
            desc1 +
            '\n' +
            desc2 +
            '\n' +
            desc3 +
            '\n' +
            desc4,

        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
    */

    Widget subTitle = Positioned(
      //left: MediaQuery.of(context).size.width / 4,
      // padding: const EdgeInsets.only(right: 56.0),
      //bottom: 190,
      height: 500,
      width: 380,
      top: 120,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      child: InkWell(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FractionalTranslation(
              translation: Offset(0, -1),
              child: Text(
                '\n' + '\n' + '\n' + '\n' + '\n',
                style: TextStyle(
                    color: Colors.green,
                    //fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0, -1),
              child: Text(
                'รายละเอียดการลงทุน \n' +
                    desc1 +
                    '\n' +
                    desc2 +
                    '\n' +
                    desc3 +
                    '\n' +
                    desc4,
                style: TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );

/*
    Widget showbank = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'กรุณาโอนเข้าบัญชี \n' + bankname_trans + '\n' + bankacct_trans,
          style: TextStyle(
            color: Colors.teal,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ));
        */

    //datab = ClipboardData(text: bankacct_trans.toString());
    //Clipboard.setData(datab);
    Widget showbank = Positioned(
      //padding: const EdgeInsets.only(right: 56.0),
      //bottom: 0,
      height: 100,
      width: 380,
      top: 300,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      child: Stack(
        // child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FractionalTranslation(
            translation: Offset(0, -0.5),
            child: Container(
              width: 500,
              height: 100,
              child: Center(
                child: Text(
                  'กรุณาโอนเข้าบัญชี \n' +
                      bankname_trans.toString() +
                      '\n' +
                      'ชื่อบัญชี ' +
                      nametrans.toString() +
                      '\n' +
                      bankacct_trans.toString(),
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 5, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );

    Widget copyClipboard = Positioned(
      //left: MediaQuery.of(context).size.width / 4,
      left: 210,
      top: 245,
      //bottom: 0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.copy,
                size: 15.0,
              ),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: bankacct_trans.toString()));
                //  _scaffoldKey.currentState.showSnackBar(SnackBar(
                //   content: Text(datab.toString()),
                // ));
              },
            ),
          ),
        ],
      ),
    );

    Widget subTitlen = Positioned(
      //left: MediaQuery.of(context).size.width / 4,
      // padding: const EdgeInsets.only(right: 56.0),
      //bottom: 190,
      height: 500,
      width: 380,
      top: 610,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      child: InkWell(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FractionalTranslation(
              translation: Offset(0, -1),
              child: Text(
                '\n' + '\n' + '\n' + '\n' + '\n',
                style: TextStyle(
                    color: Colors.green,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0, -1),
              child: Text(
                'กรุณา upload สลิปโอนเงินก่อนบันทึกข้อมูล',
                style: TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );

    Widget picView = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 190,
      child: InkWell(
        //onTap: () => pickImage(context),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          //height: 80,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(''),
                    _imageFile != null
                        ? Image.file(
                            _imageFile,
                            // height: 150,
                            height: 150,
                            width: 150,
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                "",
                              ),
                            ),
                            height: 150,
                          ),
                  ],
                ),
                /*
                Column(
                  children: <Widget>[
                    Text(''),
                    imageUrl != null
                        ? Image.network(
                            imageUrl,
                            height: 150,
                            width: 150,
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                "",
                              ),
                            ),
                            height: 150,
                          ),
                  ],
                )
                */
              ],
            ),
          ),
        ),
      ),
    );

    Widget uploadButton = Positioned(
      //left: MediaQuery.of(context).size.width / 4,
      left: 10,
      top: 150,
      //bottom: 0,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.camera,
                size: 30.0,
              ),
              onPressed: () {
                pickImage(context);
              },
            ),
          ),
          Positioned(
            left: 5, //left: MediaQuery.of(context).size.width / 4,
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

      /*
      child: InkWell(
        // onTap: () => pickImage(context);

        onTap: () => pickImage(context),

        //onTap: () {
        //  Navigator.of(context)
        //   .push(MaterialPageRoute(builder: (_) => chooseFile));
        //},
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 90,
          child: Center(
              child: new Text("ส่งสลิปโอนเงิน",
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
      ),*/
    );

    Widget saveButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () async {
          //Navigator.of(context)
          //    .push(MaterialPageRoute(builder: (_) => RegisterPage()));
          //onPressed: () {

          if (data['bankaccount'] == "") {
            showMessageBox(
                context, "Error", "กรูณากรอกข้อมูลธนาคารให้เรียบร้อย",
                actions: [dismissButton(context)]);
            logger.e("bank account can't be null");
          } else if (tradeamount.text == null) {
            showMessageBox(context, "Error", "กรูณากรอกจำนวนเงิน",
                actions: [dismissButton(context)]);
            logger.e("amount can't be null");
          } else if (double.parse(tradeamount.text) < 100) {
            showMessageBox(context, "Error", "ลงทุนขั้นต่ำ 100 บาท",
                actions: [dismissButton(context)]);
            logger.e("amount over 100");
          } else if (imageUrl == null) {
            showMessageBox(context, "Error", "กรุณา upload สลิปโอนเงิน",
                actions: [dismissButton(context)]);
            logger.e("Transfer money slip");
          } else {
            //var myDouble = double.parse('amount');
            //amtval = myDouble;
            var myamt = double.parse(tradeamount.text);
            bool active = false;
            //String covertdate = getdate.toString();
            //var inputDate = outputDateFormat.parse(covertdate);
            DateTime now = DateTime.now();
            DateTime serverdate = await NTP.now();
            String formatdate = DateFormat('dd/MM/yyyy').format(serverdate);

            // if formatdate.compareTo(now);
            /*
            DateTime startDate = DateTime.parse(service_start_date);
            DateTime endDate = DateTime.parse(service_end_date);
            DateTime now = DateTime.now();
  
            print('now: $now');
            print('startDate: $startDate');
            print('endDate: $endDate');
            print(startDate.isBefore(now));
            print(endDate.isAfter(now));
            */

            addMoneyItem(
                context,
                {
                  "name": data['name'], //nametxt,
                  "amount": myamt, //amount.text,
                  "active": active, //"false",
                  "bankname": data['bankname'], //banknamedis,
                  "bankaccount": data['bankaccount'], //bankaccountdis,
                  "uid": userID,
                  "createdAt": FieldValue.serverTimestamp(),
                  "updatedAt": FieldValue.serverTimestamp(),
                  "paymentamt": 0,
                  "payment": false,
                  "sumtotal": myamt,
                  "datestamp": formatdate,
                  "dateint": formatdate,
                  "picurl": imageUrl,
                  "paytype": 1, // 1 = ฝาก , 2 = ถอน , 3 ลงทุน , 4 แนะนำเพื่อน
                  "mobile": data['mobile'],
                },
                userID);
            tradeamount.text = "";
            //--- Update total ----
            //updateTotal();

          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("แจ้งลงทุน",
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

    Widget registerForm = Positioned(
      height: 400,

      width: 380,
      top: 400,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      child: Stack(
        children: <Widget>[
          Container(
            height: 280,
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
                    controller: tradeamount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'กรอกยอดเงินโอน'),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),

                /*
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: password,
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: cmfPassword,
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
                */
              ],
            ),
          ),
          picView,
          uploadButton,
          saveButton,
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

    //return Scaffold(
    return Material(
      color: Colors.amber,
      // body: Container(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      // color: Colors.grey,
      child: SingleChildScrollView(
        child: Stack(
          // alignment: Alignment.center,
          children: <Widget>[
            /*
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover)),
              ),
            ),
            */
            Container(),
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 420.0),
              ),
            ),
            //title,
            subTitle,
            showbank,
            copyClipboard,
            subTitlen,
            registerForm,

            /*       
          Padding(
            //padding: EdgeInsets.only(
            //    bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 28.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title,
                  //subTitle,
                  showbank,
                  //registerForm,
                ],
              ),
            ),
          ),*/
            Positioned(
              top: 35,
              left: 5,
              child: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
