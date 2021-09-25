import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path/path.dart' as Path;

class Pictureadd extends StatefulWidget {
  // MyHomePage({Key key}) : super(key: key);
  @override
  _Pictureadd createState() => _Pictureadd();
}

class _Pictureadd extends State<Pictureadd> {
  File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();

  int _counter = 0;

  bool isLoading = false;

  Future chooseFile() async {
    // await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    // });
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref =
        storage.ref().child('images/${Path.basename(_image.path)}}');
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      //_uploadedFileURL = ref.getDownloadURL().toString();

      setState(() {
        _uploadedFileURL = ref.getDownloadURL().toString();
        isLoading = false;
      });
    }).catchError((onError) {
      print(onError);
    });
    return _uploadedFileURL;

    /*
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        isLoading = false;
      });
    });
    */
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Selected Image'),
                        _image != null
                            ? Image.file(
                                _image,
                                // height: 150,
                                height: 150,
                                width: 150,
                              )
                            : Container(
                                child: Center(
                                  child: Text(
                                    "No Image is Selected",
                                  ),
                                ),
                                height: 150,
                              ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Uploaded Image'),
                        _uploadedFileURL != null
                            ? Image.network(
                                _uploadedFileURL,
                                height: 150,
                                width: 150,
                              )
                            : Container(
                                child: Center(
                                  child: Text(
                                    "No Image is Selected",
                                  ),
                                ),
                                height: 150,
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _image != null
                ? isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text('Upload Image'),
                        onPressed: uploadFile,
                        color: Colors.red,
                      )
                : Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: chooseFile,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}


/*
class Pictureadd extends StatefulWidget {
  @override
  _Pictureadd createState() => _Pictureadd();
}

class _Pictureadd extends State<Pictureadd> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Edit Profile'),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image != null)
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xff476cfb),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Color(0xff476cfb),
                    onPressed: () {
                      uploadPic(context);
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
// https://github.com/flutter-devs/Flutter-Firebase-Storage/blob/master/lib/profilepage.dart
*/
