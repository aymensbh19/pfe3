import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';

class Msg extends StatelessWidget {
  final DocumentSnapshot doc;

  const Msg({Key key, this.doc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          child: Row(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40)),
                  margin:
                      EdgeInsets.only(left: 12, right: 8, top: 4, bottom: 4),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: firestore
                        .collection("chat")
                        .document(doc.documentID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          backgroundColor: Colors.white24,
                          maxRadius: 32,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            snapshot.data["cimg"],
                          ),
                          // backgroundColor: KColors.primary,
                          maxRadius: 32,
                        );
                      }
                    },
                  )),
                  Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8, bottom: 2),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: firestore
                            .collection("chat")
                            .document(doc.documentID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Icon(
                              Icons.more_horiz,
                              size: 28,
                              color: Colors.black,
                            );
                          } else {
                            return Text(
                              snapshot.data["cname"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, top: 2),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection("chat")
                            .document(doc.documentID)
                            .collection("message")
                            .orderBy("mdate", descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Icon(
                              Icons.more_horiz,
                              size: 20,
                              color: Colors.grey,
                            );
                          } else {
                            return Text(
                              snapshot.data.documents[0].data["mctn"],
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              
              Container(
                margin: EdgeInsets.only(right: 18),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection("chat")
                      .document(doc.documentID)
                      .collection("message")
                      .orderBy("mdate", descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Icon(
                        Icons.more_horiz,
                        size: 16,
                        color: Colors.purpleAccent,
                      );
                    } else {
                      return Text(
                          DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["mdate"]).hour > 1
                              ? DateTime.fromMillisecondsSinceEpoch(
                                          DateTime.now().millisecondsSinceEpoch -
                                              snapshot.data.documents[0]
                                                  .data["mdate"])
                                      .hour
                                      .toString() +
                                  " h"
                              : (DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["mdate"]).minute > 1)
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                              DateTime.now()
                                                      .millisecondsSinceEpoch -
                                                  snapshot.data.documents[0]
                                                      .data["mdate"])
                                          .minute
                                          .toString() +
                                      " mins ago"
                                  : "Just now",
                          style: TextStyle(color: Colors.purpleAccent, fontSize: 12));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
