import 'package:meplus/app_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meplus/providers/logger_service.dart';
import 'package:nice_button/nice_button.dart';
import 'package:meplus/providers/login_provider.dart';
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

//import 'forgot_password_page.dart';

class Package extends StatefulWidget {
  //final String name;
  //final String email;
  FirebaseUser user;

  //Package({Key key, @required this.name, @required this.email})
  //     : super(key: key);

  Package({Key key, this.user}) : super(key: key);
  @override
  _Package createState() => _Package();

  //Package({Key key, this.user}) : super(key: key);
}

class _Package extends State<Package> {
  UserManagement userObj = new UserManagement();

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

  /*
  int _counter = 0;
  File _image;
  String _uploadedFileURL;
  bool isLoading = false;
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    String fileName = basename(_imageFile.path);
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        //.child('uploads/$fileName');
        .child('images/$fileName}');
    //.child('images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        isLoading = false;
      });
    });
  }
  */

  String imageUrl;
  Future pickImage(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

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
      });
    });
    /*
    DocumentSnapshot ds = await Firestore.instance
        .collection('packagedesc')
        .document('desc')
        .get();
    final datadesc = ds.data; //do something with document snapshot

    return datadesc;
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

    /*
    if (datadesc['desca'] == null) {
      desc1 = "ฝาก 100 ปันผล บาท/วัน";
    } else {
      desc1 = datadesc['desca'];
    }

    if (datadesc['descb'] == null) {
      desc2 = "ฝาก 1,000 ปันผล บาท/วัน";
    } else {
      desc2 = datadesc['descb'];
    }

    if (datadesc['descc'] == null) {
      desc3 = "ฝาก 10,000 ปันผล บาท/วัน";
    } else {
      desc3 = datadesc['descc'];
    }

    if (datadesc['descd'] == null) {
      desc4 = "ฝาก 100,000 ปันผล บาท/วัน";
    } else {
      desc4 = datadesc['descd'];
    }
    */

    if (desca == null) {
      desc1 = "ฝาก 100 ปันผล บาท/วัน";
    } else {
      desc1 = desca;
    }

    if (descb == null) {
      desc2 = "ฝาก 1,000 ปันผล บาท/วัน";
    } else {
      desc2 = descb;
    }

    if (descc == null) {
      desc3 = "ฝาก 10,000 ปันผล บาท/วัน";
    } else {
      desc3 = descc;
    }

    if (descd == null) {
      desc4 = "ฝาก 100,000 ปันผล บาท/วัน";
    } else {
      desc4 = descd;
    }

    Widget title = Text(
      'PACKAGE s',
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
        ));

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

    Widget saveButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 1,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));
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

    Widget registerForm = Container(
      height: 400,
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
  }
}

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
