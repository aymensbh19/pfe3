import 'package:flutter_chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

import 'package:flutter_chat_app/util/firebasehelper.dart';

class User extends StatefulWidget {
  final DocumentSnapshot doc;

  const User({Key key, this.doc}) : super(key: key);

  @override
  UserState createState() {
    return UserState();
  }
}

class UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    Random rnd = new Random();
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        border: Border(
            right: BorderSide(
                color: Color.fromRGBO(rnd.nextInt(130) + 100,
                    rnd.nextInt(100) + 100, rnd.nextInt(100) + 100, 1),
                width: 10)),
      ),
      margin: EdgeInsets.only(top: 6, left: 4, right: 8),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: _dialog,
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 8, left: 8),
                  child: Container(
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          widget.doc.data["userimg"]),
                      maxRadius: 30,
                    ),
                  )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        widget.doc.data["username"],
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        //     );
                        //   }
                        // },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        widget.doc.data["useremail"],
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        //     );
                        //   }
                        // },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 18),
                child: Text(widget.doc.data["isconnected"] ? "Active" : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.green, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dialog() {
    final formKey = GlobalKey<FormState>();
    String msg;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("New message", style: TextStyle(color: Colors.black)),
            content: Container(
              padding: EdgeInsets.all(8),
              child: Form(
                key: formKey,
                child: TextFormField(
                  onSaved: (input) {
                    msg = input;
                  },
                  validator: (input) {
                    if (input.isEmpty) {
                      return "type somthing";
                    }
                  },
                  cursorWidth: 1,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    fillColor: Colors.white12,
                    filled: true,
                    hintText: 'Aa',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text(
                  "Send",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    firestore.runTransaction((trs) async {
                      QuerySnapshot chat = await firestore
                          .collection("chat")
                          .where("cparts", arrayContains: [
                        firebaseUser.uid,
                        widget.doc.documentID
                      ]).getDocuments();
                      print(chat.documents.length);

                      if (chat.documents.isEmpty) {
                        await firestore.collection('chat').add({
                          "cparts": [firebaseUser.uid, widget.doc.documentID],
                          "cnames": [
                            widget.doc.data["username"],
                            userDocument.data["username"]
                          ],
                          "cimgs": [
                            widget.doc.data["userimg"],
                            userDocument.data["userimg"]
                          ],
                          "clastdate": DateTime.now().millisecondsSinceEpoch,
                        }).then((onValue) async {
                          await onValue.collection("message").add({
                            "mfrom": firebaseUser.uid,
                            "mctn": msg,
                            "mdate": DateTime.now().millisecondsSinceEpoch
                          });
                        });
                      } else {
                        await chat.documents[0].reference
                            .collection("message")
                            .add({
                          "mfrom": firebaseUser.uid,
                          "mctn": msg,
                          "mdate": DateTime.now().millisecondsSinceEpoch
                        });
                      }
                    }
                        // ).catchError((onError){
                        //   showBottomSheet(
                        //     context: context,
                        //     builder: (BuildContext context){
                        //       return Text(onError);
                        //     }
                        //   );
                        // }
                        ).catchError((onError) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text("Ops!"),
                              contentPadding: EdgeInsets.all(8),
                              titlePadding: EdgeInsets.all(8),
                              children: <Widget>[
                                Text(
                                    "Message Not Sent please check your network"),
                              ],
                            );
                          });
                    });
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  // Future<void> edit(GlobalKey<FormState> formKey) async {}
}
