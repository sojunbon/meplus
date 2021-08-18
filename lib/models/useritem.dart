import 'package:cloud_firestore/cloud_firestore.dart';
import './operations.dart';
import 'package:flutter/material.dart';

class UserItem extends StatefulWidget {
  final String name;
  final String bankname;
  final String bankaccount;
  //final bool isFavourite;
  //final String id;
  final DocumentSnapshot documentSnapshot;
  UserItem({
    @required this.name,
    @required this.bankname,
    @required this.bankaccount,
    @required this.documentSnapshot,
  });

  @override
  _UserItem createState() => _UserItem();
}

class _UserItem extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            /*
            Container(
              height: 100,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            */
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Rs. ${widget.productPrice}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      )*/
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  /*Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          editProduct(widget.isFavourite, widget.id);
                        },
                        icon: widget.isFavourite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.greenAccent,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.greenAccent,
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteProduct(widget.documentSnapshot);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  */
                ],
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
      ),
    );
  }
}
