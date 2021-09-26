import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
//import 'posts.dart';
import 'package:meplus/models/getuser_model.dart';

//https://fireship.io/lessons/advanced-flutter-firebase/

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> getUser(String uid) {}

  /// Get a stream of a single document
  Stream<GetuserModel> streamPost(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => GetuserModel.fromFirestore(snap));
  }

  /// Query a subcollection
  Stream<List<GetuserModel>> streamPostList(String uid) {
    var ref = _db.collection('posts');

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => GetuserModel.fromFirestore(doc)).toList());
  }

  Future<void> createData(String id) {
    //return _db.collection('heroes').document(heroId).setData({ /* some data */ });
  }
}
