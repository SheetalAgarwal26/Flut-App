import 'package:bot_toast/bot_toast.dart';
import 'package:task5/helper/helperfunction.dart';
import 'package:task5/services/auth.dart';
import 'package:task5/services/database.dart';
import 'package:task5/views/Home.dart';
import 'package:task5/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:task5/widget/colors.dart';
import 'package:task5/widget/fadeanimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final Function toggle;
  LoginPage(this.toggle);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  Databasemethods databasemethods = new Databasemethods();
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  signMeIn() {
    if (formkey.currentState.validate()) {
      HelperFunction.saveuserEmailSharedPreference(emailController.text);

      databasemethods.getusersByEmail(emailController.text).then((value) {
        HelperFunction.saveuserNameSharedPreference(value);
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signinWithEmailAndPassword(
              emailController.text, passwController.text)
          .then((value) {
        if (value == 0) {
          setState(() {
            isLoading = false;
            BotToast.showText(text: "user not Found");
          });
        } else if (value == 1) {
          setState(() {
            isLoading = false;
            BotToast.showText(text: "Incorrect Password");
            passwController.text = null;
          });
        } else if (value != null) {
          HelperFunction.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  signinwithgoogle() {
    authMethods.signInWithGoogle().then((value) {
      if (value == 0) {
        setState(() {
          isLoading = false;
          BotToast.showText(text: "user not Found");
        });
      } else if (value == 1) {
        setState(() {
          isLoading = false;
          BotToast.showText(text: "Incorrect Password");
          passwController.text = null;
        });
      } else if (value != null) {
        print(value.additionalUserInfo.profile['name']);
        print(value.additionalUserInfo.profile['email']);
        HelperFunction.saveuserEmailSharedPreference(
            value.additionalUserInfo.profile['email']);
        Map<String, String> userInfoMap = {
          "name": value.additionalUserInfo.profile['name'],
          "email": value.additionalUserInfo.profile['email'],
        };
        databasemethods.uploaduserInfo(userInfoMap);

        HelperFunction.saveuserNameSharedPreference(
            value.additionalUserInfo.profile['name']);
        HelperFunction.saveuserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.menu,
                       color: Colors.white,
                       size: 36.0,),
                       actions: [
            IconButton(icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 36.0,
                        ),
                        onPressed:
                         null),],
        title: Text("Chat App",style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 23),),
      
      ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                        1.5,
                        Text("Welcome",
                            style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        1.5,
                        Image.asset(
                          'assets/gi.gif',
                          width: 100,
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: FadeAnimation(
                          1.5,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.transparent,
                                      blurRadius: 30,
                                      offset: Offset(1, 8))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  FadeAnimation(
                                    1.5,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0,
                                          left: 8,
                                          top: 2,
                                          bottom: 2),
                                      child: TextFormField(
                                        validator: (val) {
                                          if (!val.isEmpty) {
                                            if (val.length < 4) {
                                              return "Username Too short";
                                            }
                                          } else if (val.isEmpty) {
                                            return "Enter Username";
                                          }
                                        },
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            hintText: "Enter Username"),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    1.5,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0,
                                          left: 8,
                                          top: 2,
                                          bottom: 2),
                                      child: TextFormField(
                                        validator: (val) {
                                          if (!val.isEmpty) {
                                            if (RegExp(
                                                    r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                                .hasMatch(val)) {
                                              return null;
                                            } else {
                                              return "Enter Email correctly";
                                            }
                                          } else
                                            return "Enter Email";
                                        },
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            hintText: "Enter Email Address"),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    1.5,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0,
                                          left: 8,
                                          top: 2,
                                          bottom: 2),
                                      child: TextFormField(
                                        obscureText: true,
                                        validator: (val) {
                                          if (!val.isEmpty) {
                                            if (val.length < 4) {
                                              return "Password Too short";
                                            }
                                          } else if (val.isEmpty) {
                                            return "Enter Password";
                                          }
                                        },
                                        controller: passwController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            hintText: "Type your Password"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            "Forgot Password?",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Container(
                                  child: Text(
                                    " Sign Up",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            color: Colors.pink[900],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        1.6,
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, right: 40),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 0.8,
                            height: 50,
                            onPressed: () {
                              signMeIn();
                            },
                            color: Colors.pink[900],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ],
                            ),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.6,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Divider(
                                  thickness: 1.5,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
