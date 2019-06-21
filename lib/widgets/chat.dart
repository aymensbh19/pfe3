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
      body: Column(
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
                        color: Colors.purple,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _controller,
                        cursorWidth: 1,
                        cursorColor: Colors.purple,
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
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 1),
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
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        // scrolljump+=50;
                        // _scrollController.jumpTo(scrolljump);
                        String msg = _controller.text;
                        _controller.clear();

                        firestore.runTransaction((transactionHandler) async {
                          await firestore
                              .collection("Chat")
                              .document(widget.doc.documentID)
                              .collection("Message")
                              .add({
                            "mfrom": firebaseUser.uid,
                            "mctn": msg,
                            "mdate": DateTime.now().millisecondsSinceEpoch
                          });
                          await firestore
                              .collection("Chat")
                              .document(widget.doc.documentID).updateData({"clastdate":DateTime.now().millisecondsSinceEpoch});
                        });
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
      )
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