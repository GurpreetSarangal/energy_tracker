import 'dart:ffi';

import 'package:energy_tracker/firebase_options.dart';
import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:energy_tracker/pages/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
// import 'package:flutter/services.dart';

import 'package:lottie/lottie.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';

// ignore: camel_case_types
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = true;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int flex_image = (size.width).round(),
        flex_content = (size.height - size.width).round();
    double content_height = 0.70;
    double bg_height = 0.65;

    // print(size.height);
    // print(size.width);
    // print(size.height / size.width);
    // print(16 / 9);
    if ((size.height / size.width).roundToDouble() ==
        (16 / 9).roundToDouble()) {
      content_height = 0.55;
      bg_height = 0.44;
    }
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          if (FirebaseAuth.instance.currentUser != null) {
            return Dashboard();
          }

          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        flex: flex_image,
                        child: Container(
                            // padding: EdgeInsets.only(left: 0, top: 0),
                            // color: Colors.white,
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            // decoration: const BoxDecoration(
                            //   image: DecorationImage(
                            //       image:
                            //           AssetImage("assets/images/loginpage2copy.png"),
                            //       fit: BoxFit.cover),
                            // ),
                            child: Image.asset(
                              "assets/animations/person_waving_crop.gif",
                              // height: size.height * 0.5,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                            // child: Padding(
                            //   padding: const EdgeInsets.only(left: 0, top: 30),
                            //   child: Column(
                            //     children: [
                            //       IconButton(
                            //         color: Colors.white,
                            //         icon: const Icon(
                            //           CupertinoIcons.back,
                            //           size: 35,
                            //           // color: Colors.white,
                            //         ),
                            //         onPressed: () {
                            //           Navigator.pop(context);
                            //         },
                            //       ),
                            //       Image.asset(
                            //         "assets/animations/persons_sitting_with_bg.gif",
                            //         height: 400,
                            //         width: double.infinity,
                            //         fit: BoxFit.fitHeight,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            )),
                    Expanded(
                        flex: flex_content,
                        child: Container(
                            color: const Color.fromARGB(255, 12, 69, 58))),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, 0.6),
                  child: Container(
                    width: size.width,
                    height: size.height * bg_height,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(40, 40)),
                        color: Color.fromARGB(193, 236, 235, 235)),
                    child: Container(
                      margin: const EdgeInsets.only(top: 13),
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'Login to your account',
                        style: TextStyle(
                            fontFamily: "Epilogue",
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 1.3),
                  child: Container(
                    width: size.width,
                    height: size.height * content_height,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Color.fromARGB(137, 120, 119, 119))
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(40, 40),
                            topRight: Radius.elliptical(40, 40)),
                        color: Colors.white),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 50,
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.black12)),
                                icon: const Icon(MyFlutterApp.apple),
                              ),
                              IconButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.black12)),
                                  onPressed: () {},
                                  icon: const Icon(MyFlutterApp.google)),
                              IconButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.black12)),
                                  onPressed: () {},
                                  icon: const Icon(MyFlutterApp.textsms)),
                            ],
                          ),
                        ),
                        const Text("or use your email account"),
                        // Expanded(
                        //   child: Container(
                        //     decoration: BoxDecoration(color: Colors.black),
                        //   ),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: _email,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      labelText: "Enter Email",
                                      fillColor: const Color.fromARGB(
                                          255, 161, 101, 101),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(),
                                      ),
                                      //fillColor: Colors.green
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty == false) {
                                        return "Email cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      fontFamily: "Epilogue",
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: _password,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      labelText: "Enter password",

                                      fillColor: const Color.fromARGB(
                                          255, 117, 112, 112),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(),
                                      ),
                                      //fillColor: Colors.green
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty == false) {
                                        return "passoword cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                      fontFamily: "Epilogue",
                                    ),
                                  ),
                                ),
                                // const Text("Remember me  Forgot Password?"),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Row(
                                          children: [
                                            FlutterSwitch(
                                              height: 17.0,
                                              width: 33.0,
                                              padding: 3.0,
                                              toggleSize: 15.0,
                                              borderRadius: 10.0,
                                              activeColor: Color.fromARGB(
                                                  255, 86, 162, 88),
                                              value: rememberMe,
                                              onToggle: (value) {
                                                setState(() {
                                                  rememberMe = value;
                                                });
                                              },
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 8, top: 2),
                                              child: Text('Remember me',
                                                  style: TextStyle(
                                                      fontFamily: "Epilogue",
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.only(top: 3),
                                            child: Text("Forgot Password?",
                                                style: TextStyle(
                                                    fontFamily: "Epilogue",
                                                    fontSize: 14,
                                                    color: const Color.fromARGB(
                                                        255, 46, 82, 46))),
                                          ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty
                                            .resolveWith<EdgeInsets?>(
                                          (states) => EdgeInsets.only(
                                              top: 15, bottom: 15),
                                        ),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            //<-- SEE HERE
                                            return const Color.fromARGB(
                                                255,
                                                46,
                                                82,
                                                46); // Defer to the widget's default.
                                          }, //background color of button
                                        ),
                                        textStyle: MaterialStateProperty
                                            .resolveWith<TextStyle?>((states) =>
                                                TextStyle(
                                                    fontFamily:
                                                        'Epilogue')), //border width and color
                                        elevation: MaterialStateProperty
                                            .resolveWith<double?>(
                                          (Set<MaterialState> states) {
                                            return 3; // Defer to the widget's default.
                                          },
                                        ), //elevation of button
                                        shape:
                                            MaterialStateProperty.resolveWith<
                                                    RoundedRectangleBorder?>(
                                                (Set<MaterialState> states) {
                                          return RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(21));
                                        }),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              return const Color.fromARGB(255,
                                                  100, 157, 100); //<-- SEE HERE
                                            }
                                            return null; // Defer to the widget's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () async {
                                        final email = _email.text;
                                        final password = _password.text;

                                        try {
                                          var user = FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          // Navigator.push(
                                          //   context,
                                          //   CupertinoPageRoute(
                                          //       builder: (context) =>
                                          //           Dashboard()),
                                          // );
                                          // Navigator.pushReplacement(context,
                                          //     MaterialPageRoute(builder:
                                          //         (BuildContext context) {
                                          //   return Dashboard();
                                          // }));
                                        } on FirebaseAuthException catch (e) {
                                          print(e);
                                          return;
                                        }
                                        Navigator.pushAndRemoveUntil(context,
                                            CupertinoPageRoute(builder:
                                                (BuildContext context) {
                                          return Dashboard();
                                        }), (r) {
                                          return false;
                                        });
                                      },
                                      child: const Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 243, 243, 243),
                                            fontFamily: "Gotham",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Don't have an account?  ",
                                        style:
                                            TextStyle(fontFamily: 'Epilogue'),
                                      ),
                                      InkWell(
                                        child: Text(
                                          "Register Here",
                                          style: TextStyle(
                                              fontFamily: 'Epilogue',
                                              color: const Color.fromARGB(
                                                  255, 46, 82, 46)),
                                        ),
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    const RegisterPage()),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-1, -0.9),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(
                      CupertinoIcons.back,
                      size: 35,
                      // color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
