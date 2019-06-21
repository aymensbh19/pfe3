import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/home.dart';
import 'package:flutter_chat_app/util/backdrop.dart';
import 'package:flutter_chat_app/screens/friends.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  String title = "iChat";

  @override
  void initState() {
    _controller = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      iconPosition: BackdropIconPosition.action,
      title: Text(title, style: TextStyle(fontSize: 24)),
      backLayer: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection("user")
                      .document(firebaseUser.uid)
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
                        maxRadius: 90,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.white24.withOpacity(.4),
                          ),
                          onPressed: () {
                            _takePic(ImageSource.gallery);
                          },
                        ),
                        backgroundImage: NetworkImage(snapshot.data["userimg"]),
                      );
                    }
                  },
                )),
            Container(
                margin: EdgeInsets.only(top: 8, bottom: 2),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection("user")
                      .document(firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.none ||
                        snapshot.connectionState == ConnectionState.waiting) {
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
                      .document(firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.none ||
                        snapshot.connectionState == ConnectionState.waiting) {
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
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2),
              child: Text(
                "Bio",
                style: TextStyle(
                    fontSize: 16, color: Colors.white70.withOpacity(.4)),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                margin: EdgeInsets.only(bottom: 8),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection("user")
                      .document(firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.none ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "...",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70.withOpacity(.7)),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text(
                        snapshot.data["userbio"],
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70.withOpacity(.7)),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                )),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 8),
              child: FlatButton(
                child: Text(
                  "Signout",
                  style: TextStyle(
                      color: Colors.redAccent.withOpacity(.6), fontSize: 22),
                ),
                onPressed: () async {
                  //TODO: Signout
                  await firebaseAuth.signOut().then((onValue) {
                    
                    firestore.runTransaction((transactionHandler) {
                      firestore
                          .collection("user")
                          .document(firebaseUser.uid)
                          .updateData({"isconnected": false});
                    });
                  });
                },
              ),
            )
          ],
        ),
      )),
      frontLayer: Center(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: PageView(
          controller: _controller,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 2, left: 2),
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(35),
              //         topRight: Radius.circular(35))),
              child: Home(),
            ),
            Container(
              margin: EdgeInsets.only(right: 2, left: 2),
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(35),
              //         topRight: Radius.circular(35))),
              child: Friends(),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _takePic(ImageSource source) async {
    File image = await ImagePicker.pickImage(
        source: source, maxWidth: 500, maxHeight: 500);
    _savePic(image, storage_users.child(firebaseUser.uid)).then((onValue) {
      firestore
          .collection("user")
          .document(firebaseUser.uid)
          .updateData({"userimg": onValue});
    });
  }

  Future<String> _savePic(File file, StorageReference storage) async {
    StorageUploadTask task = storage.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
