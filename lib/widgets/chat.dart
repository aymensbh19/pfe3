import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';
import 'package:line_icons/line_icons.dart';

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
    return Material(
      elevation: 4,
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: StreamBuilder<DocumentSnapshot>(
              stream:
                  firestore.collection("user").document(cpartner).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Text("...");
                } else {
                  return Text(
                    snapshot.data["username"],
                  );
                }
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {},
              )
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection("chat")
                        .document(widget.doc.documentID)
                        .collection("message")
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
                            if (snapshot
                                    .data.documents[position].data["mfrom"] ==
                                firebaseUser.uid) {
                              return _msgSent(snapshot
                                  .data.documents[position].data["mctn"]);
                            } else {
                              return _msgRecived(
                                  snapshot
                                      .data.documents[position].data["mctn"],
                                  snapshot
                                      .data.documents[position].data["mctn"]);
                            }
                          },
                        );
                      }
                    },
                  )),
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: IconButton(
                          icon: Icon(
                            LineIcons.image,
                            color: Color(0xFF383645),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: _controller,
                            cursorWidth: 1,
                            cursorColor: Color(0xFF383645),
                            style: TextStyle(color: Colors.black
                                // fontFamily: 'product'
                                ),
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.all(
                                    10), //--------------------------------------------
                                hintText: 'Aa',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  // fontFamily: 'product'
                                ),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF383645), width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF383645), width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Color(0xFF383645),
                          ),
                          onPressed: () {
                            // scrolljump+=50;
                            // _scrollController.jumpTo(scrolljump);
                            String msg = _controller.text;
                            _controller.clear();
                            if (msg.isEmpty) {
                              return;
                            } else {
                              firestore
                                  .runTransaction((transactionHandler) async {
                                await firestore
                                    .collection("chat")
                                    .document(widget.doc.documentID)
                                    .collection("message")
                                    .add({
                                  "mfrom": firebaseUser.uid,
                                  "mctn": msg,
                                  "mdate": DateTime.now().millisecondsSinceEpoch
                                });
                                await firestore
                                    .collection("chat")
                                    .document(widget.doc.documentID)
                                    .updateData({
                                  "clastdate":
                                      DateTime.now().millisecondsSinceEpoch
                                });
                              });
                            }
                            _scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.bounceInOut);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _msgRecived(String mctn, String cimg) {
    return Container(
        margin: EdgeInsets.only(right: 100, left: 20),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(230, 235, 235, 1),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(14),
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(4))),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          child:
              Text(mctn, style: TextStyle(color: Colors.black.withOpacity(.6), fontSize: 16)),
        ));
  }

  Widget _msgSent(String mctn) {
    return Container(
        margin: EdgeInsets.only(left: 100, right: 20),
        alignment: Alignment.centerRight,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF383645).withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(4))),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(4),
                child: Text(mctn,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              // Container(
              //   child: Text(
              //     "sent"
              //     ,style: TextStyle(color: Colors.grey),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
