import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:energy_tracker/firebase_options.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';

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

  bool rememberMe = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),

      builder: (context, snapshot) {
        if (FirebaseAuth.instance.currentUser != null) {
          return Dashboard();
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                              padding: EdgeInsets.zero,
                              // color: Colors.white,
                              width: double.infinity,
                              alignment: Alignment.topLeft,
                              // decoration: const BoxDecoration(
                              //   image: DecorationImage(
                              //       image:
                              //           AssetImage("assets/images/loginpage2copy.png"),
                              //       fit: BoxFit.cover),
                              // ),
                              child: Image.asset(
                                "assets/animations/person_sitting_smaller_crop.gif",
                                // height: size.height * 0.5,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ))),
                      Expanded(
                          flex: 2,
                          child: Container(
                              color: const Color.fromARGB(255, 12, 69, 58))),
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, 0.4),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.45,
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(40, 40)),
                          color: Color.fromARGB(193, 236, 235, 235)),
                      child: Container(
                        margin: const EdgeInsets.only(top: 13),
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'Create new account',
                          style: TextStyle(
                              fontFamily: "Epilogue",
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Container(
                        width: size.width,
                        height: size.height * 0.55,
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
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            const SizedBox(
                              height: 11,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 7, bottom: 0),
                                  height: 50,
                                  child: TextFormField(
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Email",
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
                                    // keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      fontFamily: "Epilogue",
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 7, bottom: 0),
                                  height: 50,
                                  child: TextFormField(
                                    controller: _name,
                                    decoration: InputDecoration(
                                      labelText: "Name",
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
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                      fontFamily: "Epilogue",
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 7, bottom: 0),
                                  height: 50,
                                  child: TextFormField(
                                    controller: _password,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "New Password",

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
                                      left: 10, right: 10, top: 7, bottom: 0),
                                  height: 50,
                                  child: TextFormField(
                                    controller: _confmPassword,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Confirm Password",

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
                            // const Text("Remember me  Forgot Password?"),
                            // Container(
                            //   margin: EdgeInsets.only(left: 20, right: 20),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Container(
                            //         // height: 10,
                            //         margin: EdgeInsets.only(right: 10),
                            //         child: Row(
                            //           children: [
                            //             FlutterSwitch(
                            //               height: 17.0,
                            //               width: 33.0,
                            //               padding: 3.0,
                            //               toggleSize: 15.0,
                            //               borderRadius: 10.0,
                            //               activeColor: Color.fromARGB(255, 86, 162, 88),
                            //               value: rememberMe,
                            //               onToggle: (value) {
                            //                 setState(() {
                            //                   rememberMe = value;
                            //                 });
                            //               },
                            //             ),
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
                            //           onTap: () {},
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.resolveWith<
                                        EdgeInsets?>(
                                      (states) =>
                                          EdgeInsets.only(top: 15, bottom: 15),
                                    ),
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
                                                'Epilogue')), //border width and color
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
                                              BorderRadius.circular(21));
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?  ",
                                  style: TextStyle(fontFamily: 'Epilogue'),
                                ),
                                InkWell(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        fontFamily: 'Epilogue',
                                        color: const Color.fromARGB(
                                            255, 46, 82, 46)),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ],
                        )),
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
          default:
            return Scaffold(
                body: Center(
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black38, fontSize: 30),
                  ),
                ),
              ),
            ));
        }
      },
      // child:
    );
  }
}
