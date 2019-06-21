import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';
import 'package:flutter_chat_app/widgets/msg.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
          children: <Widget>[
            Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 4,left: 12,bottom: 10),
      height: MediaQuery.of(context).size.width/10,
      child:Text(
      "Home",
      style: TextStyle(fontSize: 24,color: Colors.black),
            ),
            ),
             
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection("chat")
          .where("cparts", arrayContains: firebaseUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting ||snapshot.data.documents.length==0) {
              return Center(
                child: Text("No chats yet",
                    style: TextStyle(color: Colors.grey)));
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,position){
                  return Msg(
                  doc: snapshot.data.documents[position],
                );
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
