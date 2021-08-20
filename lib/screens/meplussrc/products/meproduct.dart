import 'package:flutter/material.dart';
import 'package:meplus/app_properties.dart';

class Meproduct extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Meproduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Page'),
      ),
      body: Container(),
    );
  }
}
