import 'package:intl/intl.dart';
import 'package:meplus/app_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:meplus/components/notification.dart';
//import 'package:meplus/components/show_notification.dart';

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
//import 'package:meplus/screens/meplussrc/package/components/money_control.dart';
//import 'forgot_password_page.dart';

import 'package:meplus/screens/meplussrc/products/components/product_control.dart';

class Product_detail extends StatefulWidget {
  FirebaseUser user;
  final String dockey;

  //Product_detail({Key key, this.dockey}) : super(key: key);
  Product_detail(this.dockey);
  @override
  _Product_detail createState() => _Product_detail(dockey);
}

class _Product_detail extends State<Product_detail> {
  UserManagement userObj = new UserManagement();

  final String dockey;
  _Product_detail(this.dockey);

  File _imageFile;

  final picker = ImagePicker();

  //String docid =  "${widget.dockey}";

  TextEditingController tradeamount = TextEditingController();

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

  var price;
  var desc;
  var picurlitem;

  var bankname_trans;
  var bankacct_trans;

  String formatdate;

  String imageUrl;
  Future pickImage(context) async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => imageUrl = value,
        );
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
        bankname_trans = datadesc['bankname'];
        bankacct_trans = datadesc['bankaccount'];
      });
    });
  }

  dynamic picdat;
  Future getPicture() async {
    final DocumentReference getpack = Firestore.instance
        .collection("products") //.document(dockey.toString());
        .document(dockey);

    await getpack.get().then<dynamic>((DocumentSnapshot getsnapshot) async {
      setState(() {
        picdat = getsnapshot.data;

        picurlitem = picdat['picurl'];
        desc = picdat['productdesc'];
        price = picdat['price'];
      });
    });
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
    getPicture();
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

    String getpic;

    //  child: Image.asset('assets/icons/10 usd.png'),
    if (picurlitem == null) {
      getpic = "assets/whitepaper.png";
    } else {
      getpic = picurlitem;
    }

    /*
    Widget title = Text(
      '\n' + '\nสั่งซื้อสินค้า',
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
                  '\n' + '\nสั่งซื้อสินค้า',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );

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
            /*
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
            */
          ],
        ),
      ),
    );

    Widget picProduct = Positioned(
      height: 500,
      width: 380,
      top: 100,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      // left: MediaQuery.of(context).size.width / 4,

      //bottom: 190,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 32.0, right: 12.0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    //decoration: BoxDecoration(
                    //    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(getpic)))),
            FractionalTranslation(
              translation: Offset(0, -0.5),
              child: Container(
                width: 160,
                height: 70,
                child: Center(
                    child: Text(
                  price.toString() + ' ฿',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 5, color: Colors.white)),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0, -1),
              child: Text(
                "     ",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );

    Widget showbank = Positioned(
      //padding: const EdgeInsets.only(right: 56.0),
      height: 100,
      width: 380,
      top: 540,
      //left: MediaQuery.of(context).size.width / 4,
      left: 15,
      //left: MediaQuery.of(context).size.width / 4,
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
                  'สั่งซื้อสินค้า กรุณาโอนเข้าบัญชี \n' +
                      bankname_trans +
                      '\n' +
                      bankacct_trans,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 5, color: Colors.white)),
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
      child: Column(
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
        ],
      ),
    );

    /*
    Widget uploadButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 100,
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
      ),
    );
  */
    Widget saveButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () async {
          if (imageUrl == null) {
            showMessageBox(context, "Error", "กรุณา upload สลิปโอนเงิน",
                actions: [dismissButton(context)]);
            logger.e("Transfer money slip");
          } else if (data['address'] == null) {
            showMessageBox(context, "Error", "กรุณา กรอกที่อยู่ จัดส่งสินค้า",
                actions: [dismissButton(context)]);
            logger.e("Transfer product");
          } else {
            //var myDouble = double.parse('amount');
            //amtval = myDouble;
            //var myamt = double.parse(tradeamount.text);
            bool active = false;
            //String covertdate = getdate.toString();
            //var inputDate = outputDateFormat.parse(covertdate);
            DateTime now = DateTime.now();
            DateTime serverdate = await NTP.now();
            String formatdate = DateFormat('dd/MM/yyyy').format(serverdate);

            addProductItem(
                context,
                {
                  "name": data['name'], //nametxt,
                  "address": data['address'],
                  "amount": price,
                  "active": active, //"false",
                  "bankname": data['bankname'], //banknamedis,
                  "bankaccount": data['bankaccount'], //bankaccountdis,
                  "uid": userID,
                  "createdAt": FieldValue.serverTimestamp(),
                  "updatedAt": FieldValue.serverTimestamp(),
                  "productid": dockey,
                  "payment": false,
                  "datestamp": formatdate,
                  "dateint": formatdate,
                  "picurl": imageUrl,
                  "productpicurl": getpic,
                  "paytype":
                      5, // 1 = ฝาก , 2 = ถอน , 3 ลงทุน , 4 แนะนำเพื่อน , 5 สั่งซื้อสินค้า
                  "mobile": data['mobile'],
                },
                userID);
            //tradeamount.text = "";
            //--- Update total ----
            //updateTotal();

          }
        }, //},
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("สั่งสินค้า",
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
      top: 620,
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
                /*
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: tradeamount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'กรอกยอดเงินโอน'),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                */
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
                padding: EdgeInsets.symmetric(vertical: 550.0),
              ),
            ),
            title,
            subTitle,
            picProduct,
            showbank,
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

    /*
    return Scaffold(
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
                    title,
                    subTitle,
                    picProduct,
                    showbank,
                    registerForm,
                  ],
                ),
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
      ),
    );
    */
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
