import 'package:energy_tracker/firebase_options.dart';
import 'package:energy_tracker/pages/Login/login_page.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:energy_tracker/pages/register/date_of_birth.dart';
import 'package:energy_tracker/pages/register/register.dart';
import 'package:energy_tracker/pages/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'pages/Login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "energy tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          canvasColor: Colors.blue,
          // appBarTheme: const AppBarTheme(
          //     backgroundColor: Color.fromARGB(0, 135, 167, 154)),
          textTheme: const TextTheme(
              displayLarge:
                  TextStyle(color: Color(0xff4E3317), fontFamily: "Epilogue"),
              titleMedium:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.normal))),
      home: SplashScreen(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    User? current = FirebaseAuth.instance.currentUser;
    print(current?.displayName ?? "No User in landing page");

    // // if (!(current?.isAnonymous ?? true)) {
    // if (current != null) {
    //   print(current);
    //   print("the user is not null");

    //   // return Dashboard();
    // } else {
    //   print("the user is null");

    return Scaffold(
      body: Container(
        // color: Colors.blue.shade50,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("assets/images/landingpage4copy.png"),
          //     fit: BoxFit.cover),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.8, 1],
              colors: [Color(0xffDACDBA), Color(0xffF4F1E9)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                // decoration: const BoxDecoration(),
                // width: 270,
                // alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 100),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background8_copy.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(400, 100),
                        bottomRight: Radius.elliptical(200, 50))
                    // gradient: LinearGradient(
                    //     begin: Alignment.topRight,
                    //     end: Alignment.bottomLeft,
                    //     colors: [Color(0xffDACDBA), Color(0xffF4F1E9)]),
                    ),
                child: const Text("Sustainability Made Easy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Epilogue",
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff4E3317),
                    )),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(),
                    child: const Text(
                      "Start your journey towards a better and more sustainable life",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Epilogue",
                          fontSize: 15.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4E3317)),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 65,
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
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color.fromARGB(
                                  255, 100, 157, 100); //<-- SEE HERE
                            }
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: Color.fromARGB(255, 236, 236, 236),
                            fontSize: 20,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 350,
                    margin: EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already Have an Account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Epilogue",
                              fontSize: 15.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4E3317)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                fontFamily: "Epilogue",
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                                // color: Color(0xff4E3317),
                                decoration: TextDecoration.underline),
                          ),
                          isSemanticButton: false,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                //<-- SEE HERE
                                return Colors
                                    .transparent; // Defer to the widget's default.
                              }, //background color of button
                            ),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.transparent; //<-- SEE HERE
                                }
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// }
