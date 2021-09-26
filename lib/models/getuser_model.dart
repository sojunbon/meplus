import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
//import 'posts.dart';
import 'package:meplus/models/getuser_model.dart';

class GetuserModel {
  String uid;
  String name;
  String bankname;
  String bankaccount;
  String mobile;

  GetuserModel(
      {this.uid, this.name, this.bankname, this.bankaccount, this.mobile});

  factory GetuserModel.fromJson(Map<String, dynamic> data) {
    return GetuserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      bankname: data['bankname'] as String,
      bankaccount: data['bankaccount'] as String,
      mobile: data['mobile'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'bankname': bankname,
      'bankaccount': bankaccount,
      'mobile': mobile,
    };
  }

  factory GetuserModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();

    return GetuserModel(
      uid: data['uid'],
      name: data['name'],
      bankname: data['bankname'],
      bankaccount: data['bankaccount'],
      mobile: data['mobile'],
    );
  }
}
