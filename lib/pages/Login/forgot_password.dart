import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/pages/Login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _email;
  final _ForgotPasswordFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    _email = TextEditingController();
    // _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    // _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/login_background1.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 40),
                    child: IconButton(
                      color: Colors.black,
                      icon: const Icon(
                        CupertinoIcons.back,
                        size: 35,
                        // color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                  ),
                  Container(
                    // alignment: Alignment.topCenter,
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.all(5),
                  //   // decoration: BoxDecoration(border: Border.all()),
                  //   // height: 90,
                  //   width: 200,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.only(bottom: 8),
                  //         child: Text(
                  //           "CONTINUE WITH",
                  //           textAlign: TextAlign.justify,
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .displayLarge
                  //               ?.copyWith(fontFamily: "Gotham", fontSize: 15),
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Container(
                  //             width: 50,
                  //             height: 50,
                  //             child: SignInButton(
                  //               Buttons.Facebook,
                  //               text: "",
                  //               mini: false,
                  //               padding: EdgeInsets.all(1),
                  //               onPressed: () async {
                  //                 // signInWithFacebook(context);
                  //               },
                  //             ),
                  //           ),
                  //           Container(
                  //             width: 51,
                  //             height: 50,
                  //             child: SignInButton(
                  //               Buttons.Google,
                  //               text: "",
                  //               mini: false,
                  //               padding: EdgeInsets.only(left: 5),
                  //               onPressed: () async {
                  //                 // await CustomSignInWithGoogle();
                  //               },
                  //             ),
                  //           ),
                  //           // IconButton(
                  //           //   onPressed: () {},
                  //           //   style: ButtonStyle(
                  //           //     padding:
                  //           //         MaterialStateProperty
                  //           //             .resolveWith(
                  //           //                 (states) =>
                  //           //                     EdgeInsets
                  //           //                         .all(
                  //           //                             12)),
                  //           //     alignment: Alignment.center,
                  //           //     iconSize:
                  //           //         MaterialStateProperty
                  //           //             .resolveWith(
                  //           //                 (states) => 30),
                  //           //     backgroundColor:
                  //           //         MaterialStateColor
                  //           //             .resolveWith(
                  //           //                 (states) => Colors
                  //           //                     .black12),
                  //           //   ),
                  //           //   icon: const Icon(
                  //           //       MyFlutterApp.apple),
                  //           // ),
                  //           // IconButton(
                  //           //     style: ButtonStyle(
                  //           //         padding: MaterialStateProperty
                  //           //             .resolveWith((states) =>
                  //           //                 EdgeInsets.all(
                  //           //                     12)),
                  //           //         alignment:
                  //           //             Alignment.center,
                  //           //         iconSize: MaterialStateProperty
                  //           //             .resolveWith(
                  //           //                 (states) => 30),
                  //           //         backgroundColor:
                  //           //             MaterialStateColor.resolveWith(
                  //           //                 (states) =>
                  //           //                     Colors.black12)),
                  //           //     onPressed: () async {
                  //           //       await CustomSignInWithGoogle();
                  //           //     },
                  //           //     icon: const Icon(MyFlutterApp.google)),
                  //           // IconButton(
                  //           //     style: ButtonStyle(
                  //           //         padding:
                  //           //             MaterialStateProperty.resolveWith(
                  //           //                 (states) =>
                  //           //                     EdgeInsets.all(
                  //           //                         12)),
                  //           //         alignment:
                  //           //             Alignment.center,
                  //           //         iconSize:
                  //           //             MaterialStateProperty.resolveWith(
                  //           //                 (states) => 30),
                  //           //         backgroundColor:
                  //           //             MaterialStateColor.resolveWith(
                  //           //                 (states) => Colors
                  //           //                     .black12)),
                  //           //     onPressed: () {},
                  //           //     icon: const Icon(
                  //           //         MyFlutterApp.textsms)),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const Text("or use your email account"),
                  // Expanded(
                  //   child: Container(
                  //     decoration: BoxDecoration(color: Colors.black),
                  //   ),
                  // ),
                  Form(
                    key: _ForgotPasswordFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // height: 400,
                          // decoration: BoxDecoration(color: Colors.black),
                          child: Text(
                            "Please enter your email address".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontSize: 14),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: TextFormField(
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                labelText: "Enter Email",
                                fillColor: Color.fromARGB(255, 161, 101, 101),
                                // col
                                border: InputBorder.none
                                // border: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(8.0),
                                // borderSide: const BorderSide(),
                                // ),
                                //fillColor: Colors.green
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       left: 20, right: 20, top: 15),
                        //   padding: EdgeInsets.only(left: 10, right: 10),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     color: Colors.white.withOpacity(0.5),
                        //   ),
                        //   child: TextFormField(
                        //     // controller: _password,
                        //     obscureText: true,
                        //     enableSuggestions: false,
                        //     autocorrect: false,
                        //     decoration: InputDecoration(
                        //         labelText: "Enter password",
                        //         fillColor: Colors.white,
                        //         border: InputBorder.none
                        //         // border: OutlineInputBorder(
                        //         //   borderRadius: BorderRadius.circular(8.0),
                        //         //   borderSide: const BorderSide(),
                        //         // ),
                        //         //fillColor: Colors.green
                        //         ),
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return "passoword cannot be empty";
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     keyboardType: TextInputType.text,
                        //     style: const TextStyle(
                        //       fontFamily: "Epilogue",
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         // height: 10,
                        //         margin: EdgeInsets.only(right: 10),
                        //         child: Row(
                        //           children: [
                        //             // FlutterSwitch(
                        //             //   height: 17.0,
                        //             //   width: 33.0,
                        //             //   padding: 3.0,
                        //             //   toggleSize: 15.0,
                        //             //   borderRadius: 10.0,
                        //             //   activeColor:
                        //             //       Color.fromARGB(255, 46, 82, 46),
                        //             //   value: rememberMe,
                        //             //   onToggle: (value) {
                        //             //     setState(() {
                        //             //       rememberMe = value;
                        //             //     });
                        //             //   },
                        //             // ),
                        //             Container(
                        //               margin: EdgeInsets.only(left: 8, top: 2),
                        //               child: Text('Remember me',
                        //                   style: TextStyle(
                        //                       fontFamily: "Epilogue",
                        //                       fontSize: 14)),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       InkWell(
                        //           onTap: () {
                        //             // final email = _email.text;
                        //             // Future<bool> isUsed =
                        //             //     checkIfEmailInUse(email);
                        //             // if (isUsed == true) {}
                        //           },
                        //           child: Container(
                        //             margin: EdgeInsets.only(top: 3),
                        //             child: Text("Forgot Password?",
                        //                 style: TextStyle(
                        //                     fontFamily: "Epilogue",
                        //                     fontSize: 14,
                        //                     color: const Color.fromARGB(
                        //                         255, 46, 82, 46))),
                        //           ))
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 85,
                    margin: EdgeInsets.only(bottom: 78, left: 20, right: 20),
                    // decoration: BoxDecoration(border: Border.all()),
                    // width: double.infinity,
                    width: 300,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              //<-- SEE HERE
                              return const Color.fromARGB(255, 46, 82,
                                  46); // Defer to the widget's default.
                            }, //background color of button
                          ),
                          textStyle:
                              MaterialStateProperty.resolveWith<TextStyle?>(
                                  (states) => TextStyle(
                                      fontFamily:
                                          'Gotham')), //border width and color
                          elevation: MaterialStateProperty.resolveWith<double?>(
                            (Set<MaterialState> states) {
                              return 3; // Defer to the widget's default.
                            },
                          ), //elevation of button
                          shape: MaterialStateProperty.resolveWith<
                                  RoundedRectangleBorder?>(
                              (Set<MaterialState> states) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28));
                          }),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(
                                    255, 100, 157, 100); //<-- SEE HERE
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () async {
                          // FirebaseAuth.instance.ema
                          final email = _email.text.trim();
                          try {
                            // print(email);

                            // var isRegistered = checkIfEmailInUse(email);
                            // if (!(isRegistered == true)) {
                            //   throw FirebaseAuthException(
                            //       code: "email-not-registered",
                            //       message:
                            //           "This email is not registered on Green Quotient");
                            // }
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Password Reset Link Sent! Check your email')),
                            );
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  showCloseIcon: true,
                                  backgroundColor: Colors.redAccent,
                                  content: Text(e.message.toString())),
                            );
                          }
                          // final password = _password.text;
                          // // if () {
                          // // If the form is valid, display a snackbar. In the real world,
                          // // you'd often call a server or save the information in a database.

                          // // }
                          // if (_loginFormKey.currentState!.validate()) {
                          //   try {
                          //     var user = await FirebaseAuth.instance
                          //         .signInWithEmailAndPassword(
                          //             email: email, password: password);
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           content: Text('Processing Data')),
                          //     );
                          //     Navigator.pushAndRemoveUntil(context,
                          //         CupertinoPageRoute(
                          //             builder: (BuildContext context) {
                          //       return Dashboard();
                          //     }), (r) {
                          //       return false;
                          //     });
                          //   } on FirebaseAuthException catch (e) {
                          //     print(e.code);
                          //     if (e.code == 'invalid-email')
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         const SnackBar(
                          //             showCloseIcon: true,
                          //             backgroundColor: Colors.redAccent,
                          //             content: Text('Invalid Email')),
                          //       );

                          //     if (e.code == 'invalid-credential')
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         const SnackBar(
                          //             showCloseIcon: true,
                          //             backgroundColor: Colors.redAccent,
                          //             content: Text('Invalid Credentials')),
                          //       );
                          //     return;
                          //   }
                          // }
                        },
                        child: const Text(
                          "RESET PASSWORD",
                          //   style: TextStyle(
                          //       color: Color.fromARGB(255, 243, 243, 243),
                          //       fontFamily: "Gotham",
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w400),
                          // ),
                          style: TextStyle(
                              color: Color.fromARGB(255, 236, 236, 236),
                              fontSize: 20,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
