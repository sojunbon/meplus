import 'package:flutter/material.dart';

class Dropdownlist extends StatefulWidget {
  @override
  _Dropdownlist createState() => _Dropdownlist();
}

class _Dropdownlist extends State<Dropdownlist> {
  String _chosenValue;

  @override
  Widget build(BuildContext context) {
    //return new Container(
    //  decoration: new BoxDecoration(color: Colors.white),
    //  child: new Center(
    //    child: new Text("Hello, World!"),
    // ),

    return Scaffold(
      appBar: AppBar(
        title: Text('DropDown'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _chosenValue,
              isDense: true,
              isExpanded: true,
              //elevation: 5,
              style: TextStyle(color: Colors.black),

              items: <String>[
                'Android',
                'IOS',
                'Flutter',
                'Node',
                'Java',
                'Python',
                'PHP',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text(
                "Please choose a langauage",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onChanged: (String value) {
                setState(() {
                  _chosenValue = value;
                });
              },
            ),
          ),
        ),
      ),

      //);
    );
  }
}
