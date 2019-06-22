import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';

void showProfile(BuildContext context, String cpartner) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          margin: EdgeInsets.only(left: 20, right: 20,),
          decoration: BoxDecoration(
            color: Color(0xFF383645),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color.fromRGBO(222, 222, 230, .6),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: firestore
                        .collection("user")
                        .document(cpartner)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          child: CircularProgressIndicator(),
                          maxRadius: 60,
                        );
                      } else {
                        return CircleAvatar(
                          maxRadius: 70,
                          backgroundImage:
                              NetworkImage(snapshot.data["userimg"]),
                        );
                      }
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 8, bottom: 2),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: firestore
                          .collection("user")
                          .document(cpartner)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Text(
                            "... ...",
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white70.withOpacity(.9)),
                          );
                        } else {
                          return Text(
                            snapshot.data["username"],
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white70.withOpacity(.9)),
                          );
                        }
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: firestore
                          .collection("user")
                          .document(cpartner)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Text(
                            "egs@domain.egs",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70.withOpacity(.7)),
                          );
                        } else {
                          return Text(
                            snapshot.data["useremail"],
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70.withOpacity(.7)),
                          );
                        }
                      },
                    )),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Bio",
                    style: TextStyle(
                        fontSize: 16, color: Colors.white70.withOpacity(.4)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
