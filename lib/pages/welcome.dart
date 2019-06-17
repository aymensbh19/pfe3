import 'package:flutter/material.dart';
import 'logs/login.dart';
import 'logs/signup.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF8f7fa0),
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 8, left: 40, right: 40),
          color: Color(0xFF8f7fa0),
          padding: MediaQuery.of(context).padding,
          child: Column(
            //work with design later
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                            fontSize: 46,
                            color: Colors.white,
                            fontFamily: "Baloo"),
                      ),
                      Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:Color(0xFF8f7fa0),
                            border: Border.all(color: Colors.white)),
                        child: Material(
                          child: InkWell(
                              onTap: (){
                                showLoginSheet(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height / 16,
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Baloo")),
                              )),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF8f7fa0),
                            border: Border.all(color: Colors.white)),
                        child: Material(
                          child: InkWell(
                              onTap: (){
                                showSignupSheet(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height / 16,
                                child: Text("Signup",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Baloo")),
                              )),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}