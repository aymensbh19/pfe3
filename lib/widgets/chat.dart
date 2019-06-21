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
  TextEditingController _controller;
  ScrollController _scrollController;

  @override
  void initState() {
    cpartner = widget.doc.data["cparts"][0] == firebaseUser.uid
        ? widget.doc.data["cparts"][1].toString()
        : widget.doc.data["cparts"][0].toString();
        
    _controller = new TextEditingController();
    _scrollController = new ScrollController();

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
            }else{
              return Text(
                snapshot.data["username"],
              );
            }
          },
        )
      ),
      body: Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("Chat")
                    .document(widget.doc.documentID)
                    .collection("Message")
                    .orderBy("mdate", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, position) {
                        if (snapshot.data.documents[position].data["mfrom"] ==
                            firebaseUser.uid) {
                          return _msgSent(
                              snapshot.data.documents[position].data["mctn"]);
                        } else {
                          return _msgRecived(
                              snapshot.data.documents[position].data["mctn"],
                              snapshot.data.documents[position].data["mctn"]);
                        }
                      },
                    );
                  }
                },
              )),
    );
  }

  
  Widget _msgRecived(String mctn, String cimg) {
    return Container(
        margin: EdgeInsets.only(right: 100, left: 20),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 5,
                    color: Color.fromRGBO(20, 20, 20, 1),
                    offset: Offset(0, 2)),
              ],
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4))),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          child:
              Text(mctn, style: TextStyle(color: Colors.black, fontSize: 16)),
        ));
  }

  Widget _msgSent(String mctn) {
    return Container(
        margin: EdgeInsets.only(left: 100, right: 20),
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 5,
                    color: Color.fromRGBO(20, 20, 20, 1),
                    offset: Offset(0, 2)),
              ],
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(4))),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          child:
              Text(mctn, style: TextStyle(color: Colors.purple, fontSize: 16)),
        ));
  }
}