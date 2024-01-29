import 'package:energy_tracker/firebase_options.dart';
import 'package:energy_tracker/pages/Login/login_page.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:energy_tracker/pages/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'pages/Login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "energy tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.blue,
        // appBarTheme: const AppBarTheme(
        //     backgroundColor: Color.fromARGB(0, 135, 167, 154)),
        // textTheme: const TextTheme(
        //     displayLarge:
        //         TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
        //     titleMedium:
        //         TextStyle(fontSize: 17, fontWeight: FontWeight.normal))
      ),
      home: SplashScreen(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    User? current = FirebaseAuth.instance.currentUser;
    print(current?.displayName);

    // if (!(current?.isAnonymous ?? true)) {
    if (current != null) {
      print(current);
      print("the user is not null");

      return Dashboard();
    } else {
      print("the user is null");

      return Scaffold(
        body: Container(
          // color: Colors.blue.shade50,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/landingpage4copy.png"),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  width: 270,
                  child: const Text(
                    "Welcome to Green Quotient",
                    style: TextStyle(
                        fontFamily: "Epilogue",
                        fontSize: 57,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 1, 57, 2)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                  // height: 800,
                ),
                Container(
                  width: 350,
                  decoration: const BoxDecoration(),
                  child: const Text(
                    "Empower, Measure, Thrive.",
                    style: TextStyle(
                        fontFamily: "Epilogue",
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 1, 57, 2)),
                  ),
                ),
                const SizedBox(
                  height: 130,
                  // height: 800,
                ),
                SizedBox(
                  width: 200,
                  height: 65,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //     backgroundColor: Color.fromARGB(
                    //         255, 46, 82, 46), //background color of button
                    //     side: BorderSide(
                    //         width: 3,
                    //         color: Color.fromARGB(
                    //             255, 80, 111, 81)), //border width and color
                    //     elevation: 3, //elevation of button
                    //     shape: RoundedRectangleBorder(
                    //         //to set border radius to button
                    //         borderRadius: BorderRadius.circular(11)),
                    //     padding: EdgeInsets.all(20),

                    //     ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          //<-- SEE HERE
                          return const Color.fromARGB(255, 46, 82,
                              46); // Defer to the widget's default.
                        }, //background color of button
                      ),
                      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                          (states) => TextStyle(
                              fontFamily: 'Epilogue')), //border width and color
                      elevation: MaterialStateProperty.resolveWith<double?>(
                        (Set<MaterialState> states) {
                          return 3; // Defer to the widget's default.
                        },
                      ), //elevation of button
                      shape: MaterialStateProperty.resolveWith<
                          RoundedRectangleBorder?>((Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11));
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
                      "Get Started",
                      style: TextStyle(
                          color: Color.fromARGB(255, 236, 236, 236),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const LoginPage()));
                    },
                  ),
                  // child: CupertinoButton(
                  //   // child: const Text('Open route'),

                  //   child: const Text(
                  //     "Get Started",
                  //     style: TextStyle(
                  //         color: Color.fromARGB(255, 236, 236, 236),
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w600),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //           builder: (context) => const LoginPage()),
                  //     );
                  //   },
                  // ),
                ),
                const SizedBox(
                  height: 90,
                  // height: 800,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
