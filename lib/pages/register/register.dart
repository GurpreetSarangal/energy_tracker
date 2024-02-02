import 'package:energy_tracker/loginMethods/facebook_login.dart';
import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:energy_tracker/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

// ignore: camel_case_types
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _password;
  late final TextEditingController _confmPassword;
  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _name = TextEditingController();
    _password = TextEditingController();
    _confmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _confmPassword.dispose();
    super.dispose();
  }

  // bool rememberMe = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot2) {
          if (snapshot2.hasError) {
            return Text(snapshot2.error.toString());
          }
          if (snapshot2.connectionState == ConnectionState.active ||
              snapshot2.connectionState == ConnectionState.done ||
              snapshot2.connectionState == ConnectionState.waiting) {
            if (snapshot2.data == null) {
              return Scaffold(
                body: Stack(
                  children: [
                    Image.asset(
                      'assets/images/login_background1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      // alignment: const Alignment(0, 1),
                      height: double.infinity,
                      width: double.infinity,
                      color:
                          Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),

                      child: SingleChildScrollView(
                        child: Container(
                          height: size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 40),
                                child: IconButton(
                                  color: Colors.black,
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
                              Container(
                                  // alignment: Alignment.center,
                                  // margin: EdgeInsets.only(top: 40),
                                  child: Text(
                                "Create Account",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                              )),

                              Container(
                                margin: EdgeInsets.all(5),
                                // decoration: BoxDecoration(border: Border.all()),
                                // height: 90,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        "CONTINUE WITH",
                                        textAlign: TextAlign.justify,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                                fontFamily: "Gotham",
                                                fontSize: 15),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: SignInButton(
                                            Buttons.Facebook,
                                            text: "",
                                            mini: true,
                                            padding: EdgeInsets.all(1),
                                            onPressed: () async {
                                              signInWithFacebook(context);
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 51,
                                          height: 50,
                                          child: SignInButton(
                                            Buttons.Google,
                                            text: "",
                                            mini: false,
                                            padding: EdgeInsets.only(left: 5),
                                            onPressed: () async {
                                              await CustomSignInWithGoogle();
                                            },
                                          ),
                                        ),
                                        // IconButton(
                                        //   onPressed: () {},
                                        //   style: ButtonStyle(
                                        //     padding:
                                        //         MaterialStateProperty
                                        //             .resolveWith(
                                        //                 (states) =>
                                        //                     EdgeInsets
                                        //                         .all(
                                        //                             12)),
                                        //     alignment:
                                        //         Alignment.center,
                                        //     iconSize:
                                        //         MaterialStateProperty
                                        //             .resolveWith(
                                        //                 (states) =>
                                        //                     30),
                                        //     backgroundColor:
                                        //         MaterialStateColor
                                        //             .resolveWith(
                                        //                 (states) => Colors
                                        //                     .black12),
                                        //   ),
                                        //   icon: const Icon(
                                        //       MyFlutterApp.apple),
                                        // ),
// https://iot-energy-tracking-app.firebaseapp.com/__/auth/handler
                                        // IconButton(
                                        //     style: ButtonStyle(
                                        //         padding: MaterialStateProperty
                                        //             .resolveWith((states) =>
                                        //                 EdgeInsets.all(
                                        //                     12)),
                                        //         alignment:
                                        //             Alignment.center,
                                        //         iconSize: MaterialStateProperty.resolveWith(
                                        //             (states) => 30),
                                        //         backgroundColor:
                                        //             MaterialStateColor.resolveWith(
                                        //                 (states) => Colors
                                        //                     .black12)),
                                        //     onPressed: () async {
                                        //       await CustomSignInWithGoogle();
                                        //     },
                                        //     icon: const Icon(
                                        //         MyFlutterApp.google)),
                                        // IconButton(
                                        //     style: ButtonStyle(
                                        //         padding: MaterialStateProperty
                                        //             .resolveWith((states) =>
                                        //                 EdgeInsets.all(
                                        //                     12)),
                                        //         alignment:
                                        //             Alignment.center,
                                        //         iconSize: MaterialStateProperty.resolveWith(
                                        //             (states) => 30),
                                        //         backgroundColor:
                                        //             MaterialStateColor.resolveWith(
                                        //                 (states) => Colors
                                        //                     .black12)),
                                        //     onPressed: () {},
                                        //     icon: const Icon(
                                        //         MyFlutterApp.textsms)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(
                              //   height: 11,
                              // ),
                              Form(
                                key: _registerFormKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // height: 400,
                                      // decoration: BoxDecoration(color: Colors.black),
                                      child: Text(
                                        "or use your email account",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 10,
                                          bottom: 0),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          fillColor: const Color.fromARGB(
                                              255, 161, 101, 101),
                                          border: InputBorder.none,
                                          //fillColor: Colors.green
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        // keyboardType: TextInputType.emailAddress,
                                        style: const TextStyle(
                                          fontFamily: "Epilogue",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 10,
                                          bottom: 0),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _name,
                                        decoration: InputDecoration(
                                          labelText: "Name",
                                          fillColor: const Color.fromARGB(
                                              255, 161, 101, 101),
                                          border: InputBorder.none,
                                          //fillColor: Colors.green
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.name,
                                        style: const TextStyle(
                                          fontFamily: "Epilogue",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 10,
                                          bottom: 0),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _password,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: "New Password",

                                          fillColor: const Color.fromARGB(
                                              255, 117, 112, 112),
                                          border: InputBorder.none,
                                          //fillColor: Colors.green
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email cannot be empty";
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
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 10,
                                          bottom: 0),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _confmPassword,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: "Confirm Password",

                                          fillColor: const Color.fromARGB(
                                              255, 117, 112, 112),
                                          border: InputBorder.none,
                                          //fillColor: Colors.green
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email cannot be empty";
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
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 85,
                                width: 300,
                                margin: EdgeInsets.only(
                                    bottom: 78, left: 20, right: 20),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        //<-- SEE HERE
                                        return const Color.fromARGB(255, 46, 82,
                                            46); // Defer to the widget's default.
                                      }, //background color of button
                                    ),
                                    textStyle: MaterialStateProperty.resolveWith<
                                            TextStyle?>(
                                        (states) => TextStyle(
                                            fontFamily:
                                                'Gotham')), //border width and color
                                    elevation: MaterialStateProperty
                                        .resolveWith<double?>(
                                      (Set<MaterialState> states) {
                                        return 3; // Defer to the widget's default.
                                      },
                                    ), //elevation of button
                                    shape: MaterialStateProperty.resolveWith<
                                            RoundedRectangleBorder?>(
                                        (Set<MaterialState> states) {
                                      return RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28));
                                    }),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return const Color.fromARGB(255, 100,
                                              157, 100); //<-- SEE HERE
                                        }
                                        return null; // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () async {
                                    await Firebase.initializeApp(
                                        options: DefaultFirebaseOptions
                                            .currentPlatform);
                                    final email = _email.text;
                                    final name = _name.text;
                                    final password = _password.text;
                                    final confrmPassword = _confmPassword.text;
                                    dynamic userCredential = "No user";
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    UserCredential result;

                                    if (password == confrmPassword &&
                                        password != '' &&
                                        email != '' &&
                                        name != '') {
                                      print("runned");

                                      try {
                                        result = await _auth
                                            .createUserWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                      } catch (e) {
                                        print(e);
                                        return;
                                      }
                                      User? user = result.user;
                                      user?.updateDisplayName(name);
                                      await Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return Dashboard();
                                      }));

                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //       builder: (context) => Dashboard()),
                                      // );
                                    } else {
                                      print(userCredential);
                                    }
                                  },
                                  child: const Text(
                                    "REGISTER",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 243, 243, 243),
                                        fontFamily: "Gotham",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Dashboard();
            }
          } else {
            return Scaffold(
              body: Container(
                color: Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),
                child: Center(
                    child: Text(
                  "Loading google login...",
                  style: TextStyle(fontSize: 30),
                )),
              ),
            );
          }
        });
  }

  // signInWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //     AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

  //     UserCredential user =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     print(user.user?.displayName);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
