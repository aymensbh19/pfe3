import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';



class Chat extends StatefulWidget {
  final DocumentSnapshot doc;

  const Chat({Key key, this.doc}) : super(key: key);


  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String cpartner;

  @override
  void initState() {
    cpartner = widget.doc.data["cparts"][0] == firebaseUser.uid
        ? widget.doc.data["cparts"][1].toString()
        : widget.doc.data["cparts"][0].toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection("user").document(cpartner).snapshots(),
          builder: (context,snapshot){
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
              return Text("...");
            }
            
          },
        )
      ),
    );
  }
}