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
import 'package:meplus/screens/meplussrc/products/components/product_control.dart';
//import 'forgot_password_page.dart';

class Addproducts extends StatefulWidget {
  //final String name;
  //final String email;
  User user;

  //Package({Key key, @required this.name, @required this.email})
  //     : super(key: key);

  Addproducts({Key key, this.user}) : super(key: key);
  @override
  _Addproducts createState() => _Addproducts();

  //Package({Key key, this.user}) : super(key: key);
}

class _Addproducts extends State<Addproducts> {
  UserManagement userObj = new UserManagement();

  File _imageFile;

  final picker = ImagePicker();

  TextEditingController productdesc = TextEditingController();
  TextEditingController priceamount = TextEditingController();
  String userID = "";

  String namedis;
  FirebaseFirestore _db = FirebaseFirestore.instance;
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
  bool isLoading = false;
  String imageUrl;
  Future pickImage(context) async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

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
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child('products/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile);
    uploadTask.whenComplete(() {
      //_uploadedFileURL = ref.getDownloadURL().toString();
      ref.getDownloadURL().then((fileURL) {
        setState(() {
          imageUrl = fileURL;
          //ref.getDownloadURL().toString();
          isLoading = false;
        });
        //setState(() {
        //  imageUrl = ref.getDownloadURL().toString();
        //  isLoading = false;
        //});
      }).catchError((onError) {
        print(onError);
      });
      return imageUrl;
      /*
    String fileName = basename(_imageFile.path);
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('products/$fileName');
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
    */
    });
  }

  dynamic data;
  Future<dynamic> getData() async {
    User user = await FirebaseAuth.instance.currentUser;

    final DocumentReference document =
        FirebaseFirestore.instance.collection("users").doc(user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  Future<dynamic> getUsername() async {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      namedis = snapshot['name'];
      return namedis;
    });
  }

  dynamic datadesc;
  Future getDescription() async {
    final DocumentReference getpackage =
        FirebaseFirestore.instance.collection("packagedesc").doc('desc');

    await getpackage.get().then<dynamic>((DocumentSnapshot getsnapshot) async {
      setState(() {
        datadesc = getsnapshot.data;
        desca = datadesc['desca'];
        descb = datadesc['descb'];
        descc = datadesc['descc'];
        descd = datadesc['descd'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    setState(() {
      userID = user.uid;
      // });
    });

    getData();
    //getDesc();
    getCal();
    getDescription();
    // getUsername();
  }

  void getCal() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('conftab')
        .doc('conf')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      count = documentSnapshot['count'];
      percenta = documentSnapshot['percenta'];
      percentb = documentSnapshot['percentb'];
      percentc = documentSnapshot['percentc'];
      percentd = documentSnapshot['percentd'];
      perday = documentSnapshot['perday'];
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

    Widget title = Text(
      '\n' + '\nเพิ่มสินค้า',
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

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
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
            fontSize: 16.0,
          ),
        ));

    Widget picView = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 120,
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

    /*
    Widget uploadButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 60,
      child: InkWell(
        // onTap: () => pickImage(context);

        onTap: () => pickImage(context),

        //onTap: () {
        //  Navigator.of(context)
        //   .push(MaterialPageRoute(builder: (_) => chooseFile));
        //},
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Center(
              child: new Text("Upload Picture",
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
    );

    Widget saveButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () async {
          if (imageUrl == null) {
            showMessageBox(context, "Error", "กรุณา upload รูปสินค้า",
                actions: [dismissButton(context)]);
            logger.e("Transfer money slip");
          } else {
            //var myDouble = double.parse('amount');
            //amtval = myDouble;
            var myamt = double.parse(priceamount.text);
            //double.parse(tradeamount.text);
            bool active = true;
            //String covertdate = getdate.toString();
            //var inputDate = outputDateFormat.parse(covertdate);
            DateTime now = DateTime.now();
            DateTime serverdate = await NTP.now();
            String formatdate = DateFormat('dd/MM/yyyy').format(serverdate);

            addItem(
                context,
                {
                  "productdesc": productdesc.text,
                  "price": myamt,
                  "active": active, //"false",
                  "uid": userID,
                  "createdAt": FieldValue.serverTimestamp(),
                  "updatedAt": FieldValue.serverTimestamp(),
                  "datestamp": formatdate,
                  "dateint": formatdate,
                  "picurl": imageUrl,
                },
                userID);
            productdesc.text = "";
            priceamount.text = "";

            //tradeamount.text = "";
            //--- Update total ----
            //updateTotal();

          }
        }, //},
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Center(
              child: new Text("บันทึก",
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

    Widget registerForm = Container(
      height: 400,
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
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
                    controller: productdesc, //tradeamount,
                    //keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(hintText: 'กรอกรายละเอียดสินค้า'),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: priceamount, //tradeamount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'ราคา'),
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

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.amber, // Colors.transparent,
        //shape: CustomShapeBorder(),

        elevation: 0.0,
        //leading: Icon(Icons.menu),
        iconTheme: IconThemeData(color: darkGrey),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/denied_wallet.png'),
            // onPressed: () => Navigator.of(context)
            // .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
          )
        ],
        //title: Text("รายการ"),
        title: Text(
          '',
          style: TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.grey,
        child: Stack(
          // alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Container(
                  //decoration: BoxDecoration(
                  //    image: DecorationImage(
                  //        image: AssetImage('assets/background.jpg'),
                  //        fit: BoxFit.cover)),
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
                    //subTitle,
                    registerForm,
                  ],
                ),
              ),
            ),
            /*
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
            */
          ],
        ),
      ),
    );
  }
}

/*
return Scaffold(
      body: Stack(
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
                Spacer(flex: 5),
                //Spacer(flex: 1),
                title,
                Spacer(),
                subTitle,

                Spacer(flex: 2),
                registerForm,
                Spacer(flex: 2),
                // Padding(
                // padding: EdgeInsets.only(bottom: 20), child: socialRegister)
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

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}



/*
import 'package:flutter/material.dart';
import 'package:meplus/app_properties.dart';

class Package extends StatefulWidget {
  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Page'),
      ),
      body: Container(),
    );
  }
}
*/
