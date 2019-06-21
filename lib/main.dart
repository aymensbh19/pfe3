import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/homepage.dart';
import 'package:flutter_chat_app/pages/welcome.dart';
import 'package:flutter_chat_app/util/firebasehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Color(0xFF383645),
  ));

  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color =
{
50:Color.fromRGBO(56,54,69, .1),
100:Color.fromRGBO(56,54,69, .2),
200:Color.fromRGBO(56,54,69, .3),
300:Color.fromRGBO(56,54,69, .4),
400:Color.fromRGBO(56,54,69, .5),
500:Color.fromRGBO(56,54,69, .6),
600:Color.fromRGBO(56,54,69, .7),
700:Color.fromRGBO(56,54,69, .8),
800:Color.fromRGBO(56,54,69, .9),
900:Color.fromRGBO(56,54,69, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF383645, color);
    return MaterialApp(
      title: 'Flutter Demo',
      home: Router(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorCustom,
        canvasColor: Colors.transparent,
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Baloo'),
        ),
      ),
    );
  }
}

class Router extends StatefulWidget {
  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: firebaseAuth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return WelcomePage();
        } else {
          firebaseUser = snapshot.data;
          firestore.runTransaction((transactionHandler) async {
            await firestore
                .collection("user")
                .document(firebaseUser.uid)
                .updateData({"isconnected": true});

            userDocument = await firestore
                .collection("user")
                .document(firebaseUser.uid)
                .get();
          });
          return HomePage();
        }
      },
    );
  }
}
