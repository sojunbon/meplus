import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
*/

class Dropdownlistxx extends StatefulWidget {
  @override
  _Dropdownlistxx createState() => _Dropdownlistxx();
}

class _Dropdownlistxx extends State<Dropdownlistxx> {
  var bankname;
  var nameen;
  bool setDefaultMakeModel = true;
  bool setDefaultMake = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('bankname: $bankname');
    //debugPrint('carMakeModel: $carMakeModel');
    return Scaffold(
      appBar: AppBar(
        title: Text("DropDown"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            //child: Center(
            child: Column(
              children: <Widget>[
                //child: StreamBuilder<QuerySnapshot>(
                new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('banktable')
                      // .orderBy('bankname')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    // Safety check to ensure that snapshot contains data
                    // without this safety check, StreamBuilder dirty state warnings will be thrown
                    if (!snapshot.hasData) return Container();
                    // Set this value for default,
                    // setDefault will change if an item was selected
                    // First item from the List will be displayed

                    if (setDefaultMake) {
                      bankname = snapshot.data.documents[0].data['bankname'];
                      debugPrint('setDefault make: $bankname');
                    }
                    return DropdownButton(
                      isExpanded: false,
                      value: bankname,
                      items: snapshot.data.documents.map((value) {
                        return DropdownMenuItem(
                          //value: value.get('bankname'),
                          value: "${bankname}",
                          child: Text(bankname),
                        );
                      }).toList(),
                      onChanged: (value) {
                        debugPrint('selected onchange: $value');
                        setState(
                          () {
                            debugPrint('make selected: $value');
                            // Selected value will be stored
                            bankname = value;
                            // Default dropdown value won't be displayed anymore
                            setDefaultMake = false;
                            // Set makeModel to true to display first car from list
                            setDefaultMakeModel = true;
                          },
                        );
                      },
                    );
                  },
                ),
                //   ),
              ],
            ),
            /*
          Expanded(
            flex: 1,
            child: Center(
              child: bankname != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('banktable')
                          // .where('bankname', isEqualTo: bankname)
                          // .orderBy("nameen")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          debugPrint('snapshot status: ${snapshot.error}');
                          return Container(
                            child: Text(
                                'snapshot empty carMake: $bankname makeModel: $nameen'),
                          );
                        }
                        if (setDefaultMakeModel) {
                          nameen = snapshot.data.documents[0].data['nameen'];
                          debugPrint('setDefault makeModel: $nameen');
                        }
                        return DropdownButton(
                          isExpanded: false,
                          value: nameen,
                          items: snapshot.data.documents.map((value) {
                            debugPrint('setDefault make: $nameen');
                            return DropdownMenuItem(
                              value: "${nameen}",
                              child: Text(
                                nameen,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            debugPrint('makeModel selected: $value');
                            setState(
                              () {
                                // Selected value will be stored
                                nameen = value;
                                // Default dropdown value won't be displayed anymore
                                setDefaultMakeModel = false;
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      child: Text(
                          'carMake null carMake: $bankname makeModel: $nameen'),
                    ),
            ),
          ), */
          ),
        ],
      ),
    );
    //}
  }
}
