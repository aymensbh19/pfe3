import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';
import 'package:flutter_chat_app/widgets/user.dart';
import 'package:line_icons/line_icons.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 4, left: 12, bottom: 10),
            height: MediaQuery.of(context).size.width / 10,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Contacts",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  Icon(LineIcons.users ,color:Colors.purple,size:32),
                ],
              ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("user").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data.documents.length == 0) {
                  return Center(
                      child: Text("No users",
                          style: TextStyle(color: Colors.grey)));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, position) {
                      if (snapshot.data.documents[position].documentID ==
                          firebaseUser.uid) {
                        return Container();
                      } else {
                        return User(
                          doc: snapshot.data.documents[position],
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
