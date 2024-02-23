// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import "dart:math";

import 'package:get/get.dart';

GlobalKey globalKey = GlobalKey();

class AppColors {
  static const Color mainGridLineColor = Colors.white10;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  final Color barColor = Color.fromARGB(200, 20, 77, 90);
  final Color touchedBarColor = Color.fromARGB(255, 200, 200, 42);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int touchedIndex = -1;
  dynamic value = 0;
  TextEditingController? units;

  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  bool isPlaying = false;
  final Duration animDuration = const Duration(milliseconds: 50);

  late final TextEditingController steps;
  late final TextEditingController rank;
  late final TextEditingController score;

  String dropdownValueBill = "Monthly";
  String dropdownValueSteps = "Monthly";
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  @override
  void initState() {
    // TODO: implement initState
    units = TextEditingController();
    steps = TextEditingController();
    rank = TextEditingController();
    score = TextEditingController();

    // event = await ref.once();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    units?.dispose();
    steps!.dispose();
    super.dispose();
  }

  updateRankAndScore(Map<String, dynamic> userData) async {
    //! implement Update
    int rand = Random().nextInt(2000);
    int rand2 = Random().nextInt(2000);

    List<dynamic> steps = userData["stepsCount"];

    users.doc(auth.currentUser!.email).set({
      "individualScore": rand,
      "individualRank": rand2,
      "rankScoreLastUpdated": Timestamp.now(),
      // "stepCountLastUpdated": Timestamp(10, 12),
    }, SetOptions(merge: true));
  }

  updateStepCount(Map<String, dynamic> userData, var lastupdated) async {
    //! implement Update
    int rand = Random().nextInt(200);
    int rand2 = Random().nextInt(200);

    // List<dynamic> steps = userData["stepsCount"];
    List<Object> list = [
      {
        "date": Timestamp.now(),
        "steps": rand,
      }
    ];

    var collection = FirebaseFirestore.instance.collection('Users');
    collection
        .doc(auth.currentUser!.email) // <-- Document ID
        .set({
          'stepsCount': FieldValue.arrayUnion(list),
          "stepCountLastUpdated": Timestamp.now(),
        }, SetOptions(merge: true)) // <-- Add data
        .then((_) => print('Steps Count Recorded'))
        .catchError((error) => print('Add failed: $error'));

    // users.doc(auth.currentUser!.email).set({
    //   "individualScore": rand,
    //   "individualRank": rand2,
    //   "rankScoreLastUpdated": Timestamp.now(),
    //   // "stepCountLastUpdated": Timestamp(10, 12),
    // }, SetOptions(merge: true));
    print("Step count updated");
  }

  Future<void> checkAndUpdateScores() async {
    print(auth.currentUser?.uid);
    var userQuerySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser?.email);

    userQuerySnapshot.get().then((value) {
      var userData = value.data();
      print(userData);
      bool neverUpdated = false;
      bool updatedToday = true;
      bool stepsCountUpdate = false;
      bool updatedThisHour = false;
      Timestamp? lastupdated;

      if (userData!["stepCountLastUpdated"] == null) {
        neverUpdated = true;
        print("Steps count neverUpdated $neverUpdated");
      } else {
        lastupdated = userData["stepCountLastUpdated"];

        var today = DateTime.now();
        var temp = today.subtract(Duration(hours: 1));
        var today_minus_one_hour = Timestamp.fromDate(temp);

        bool updatedThisHour = lastupdated!.seconds >=
                today_minus_one_hour.seconds ||
            (lastupdated.seconds == today_minus_one_hour.seconds &&
                lastupdated.nanoseconds < (today_minus_one_hour.nanoseconds));

        // var d = DateTime.parse(Timestamp(userData["lastUpdated"]));
        print("-----------------------");
        print(lastupdated);
        print(today);
        print(today_minus_one_hour);
        print("this is  $updatedThisHour");
        print("-----------------------");
      }

      //? to update the step count
      if (neverUpdated || !updatedThisHour) {
        print(
            "neverUpdeted $neverUpdated and updatedThisHour $updatedThisHour");
        print("this is called");
        updateStepCount(userData, lastupdated); //! to be implemented
      }
      // -------------------------------------------

      if (userData!["rankScoreLastUpdated"] == null) {
        neverUpdated = true;
        print("neverUpdated $neverUpdated");
      } else {
        Timestamp lastupdated = userData["rankScoreLastUpdated"];

        var today = DateTime.now();
        var today_timestamp = Timestamp.fromDate(DateTime(
          today.year,
          today.month,
          today.day,
        ));

        updatedToday = lastupdated.seconds >= today_timestamp.seconds;

        // var d = DateTime.parse(Timestamp(userData["lastUpdated"]));
        print("-----------------------");
        print(lastupdated);
        print(today);
        print(today_timestamp);
        print(updatedToday);
        print("-----------------------");
      }

      if (neverUpdated || !updatedToday) {
        updateRankAndScore(userData); //! to be implemented
      }
    });

    // return void;
  }

  Future<void> isDeviceConnected() async {
    var email = FirebaseAuth.instance.currentUser?.email;

    var users =
        await FirebaseFirestore.instance.collection("Users").doc(email).get();

    print("--------------------------");
    print(users.data()?[0]);
    print("--------------------------");

    var userAccountNo = "";

    var family = await FirebaseFirestore.instance
        .collection("family")
        .where("accountNo", isEqualTo: userAccountNo);
  }

  @override
  Widget build(BuildContext context) {
    // update();

    // print("update has been called");
    checkAndUpdateScores();
    final size = MediaQuery.of(context).size;

    final Color backgroundColor = Color.fromARGB(255, 239, 240, 243);

    // final Color supportTextColor = Color.fromARGB(164, 232, 234, 175);

    String? username = auth.currentUser?.displayName ?? "";

    return Scaffold(
      key: globalKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // flexibleSpace: Container(
        //   height: 10,
        //   color: Colors.red,
        // ),

        primary: true,
        forceMaterialTransparency: true,
        // bottomOpacity: 0.9,
        elevation: 40,
        leading: Icon(CupertinoIcons.question_circle),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        // backgroundColor: backgroundColor,
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
          IconButton(
              onPressed: () async {
                // await CustomSignOut();
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(builder: (context) => const LandingPage()),
                // );
              },
              icon: Icon(CupertinoIcons.bell))
        ],
        // foregroundColor: AppColors.mainTextColor1,
        title: Text(
          "Green Quotient",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: Builder(builder: (context) {
        double _percentStepCount = 40;
        int _stepCount = 40;
        int _stepGoal = 40;
        int _individualRank = 23232;
        int _powerConsumption = 232;
        bool _showAvg = false;
        return Stack(children: [
          SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
              children: [
                // SizedBox(
                //   height: 100,
                // ),
                // isDeviceConnected(),
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage("assets/images/dashboard_bg2.jpg"),
                          fit: BoxFit.cover)),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // width: ,
                        // margin: EdgeInsets.all(20),
                        padding: EdgeInsets.only(
                          top: 30,
                          left: 30,
                        ),
                        child: Text(
                          "Hi, ${username}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        // width: ,
                        // margin: EdgeInsets.all(20),
                        padding: EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          "Track your goals and electricity bills.",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Container(
                        // decoration: BoxDecoration(border: Border.all()),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        // width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      //<-- SEE HERE
                                      return Colors.white;
                                    },
                                  ),
                                  surfaceTintColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      //<-- SEE HERE
                                      return Colors
                                          .white; // Defer to the widget's default.
                                    }, //background color of button
                                  ),
                                  textStyle: MaterialStateProperty.resolveWith<
                                          TextStyle?>(
                                      (states) => TextStyle(
                                          fontFamily: 'Gotham',
                                          color: Colors.black,
                                          fontSize:
                                              13)), //border width and color
                                  elevation: MaterialStateProperty.resolveWith<
                                      double?>(
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
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.black12; //<-- SEE HERE
                                      }
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () => {isDeviceConnected()},
                                child: Text(
                                  "Steps Count",
                                  style: TextStyle(color: Colors.black),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.resolveWith<Size?>(
                                    (Set<MaterialState> states) {
                                      //<-- SEE HERE
                                      return Size(120,
                                          35); // Defer to the widget's default.
                                    }, //background color of button
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      //<-- SEE HERE
                                      return Colors
                                          .white; // Defer to the widget's default.
                                    }, //background color of button
                                  ),
                                  surfaceTintColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      //<-- SEE HERE
                                      return Colors
                                          .white; // Defer to the widget's default.
                                    }, //background color of button
                                  ),
                                  textStyle: MaterialStateProperty.resolveWith<
                                          TextStyle?>(
                                      (states) => TextStyle(
                                          fontFamily: 'Gotham',
                                          color: Colors.black,
                                          fontSize:
                                              13)), //border width and color
                                  elevation: MaterialStateProperty.resolveWith<
                                      double?>(
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
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.black12; //<-- SEE HERE
                                      }
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () => {},
                                child: Text(
                                  "Units Used",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // ?---------------------------------------------------------
                // ?---------------------------------------------------------

                Container(
                  //? Section 1 -- At Glance -- starting
                  // color: Colors.amber,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "At Glance",
                          style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                        ),
                        InkWell(
                            onTap: () => {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Details ",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                Icon(CupertinoIcons.arrow_right)
                              ],
                            ))
                      ]),
                ),
                atGlanceScrollView(),
                // ?---------------------------------------------------------
                // ?---------------------------------------------------------

                Container(
                  // ? Section 2 -- Consumption -- Starting
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Consumption",
                          style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                        ),
                        InkWell(
                            onTap: () => {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Details ",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                Icon(CupertinoIcons.arrow_right)
                              ],
                            ))
                      ]),
                ),
                Container(
                    // ? Section 2 -- Consumption -- Starting
                    height: 250,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/dashboard_bg3_landscape.jpg"),
                            fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 70),
                              blurRadius: 100,
                              blurStyle: BlurStyle.normal)
                        ]),
                    child: consumptionGraph()),

                Container(
                  // ? Section 3 -- Consumption -- Starting
                  // color: Colors.amber,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending Posts",
                          style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                        ),
                        InkWell(
                            onTap: () => {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "All Posts ",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                Icon(CupertinoIcons.arrow_right)
                              ],
                            ))
                      ]),
                ),
                Container(
                  // ? Section 3 -- Consumption -- Starting
                  color: Colors.transparent,
                  height: 350,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            margin: EdgeInsets.only(left: 15, right: 5),
                            elevation: 20,
                            child: Container(
                              width: 200,
                              height: 300,
                              decoration: BoxDecoration(
                                  // color: Color(0xff214D56),
                                  // color: Colors.amberAccent,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dashboard_bg13_portait.jpg"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            color: Colors.blue.shade50,
                                            backgroundBlendMode:
                                                BlendMode.softLight),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "Title of the first Post is really awesome",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 20,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 35,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "The discription of this post is also very impressive and very looooong",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontSize: 14,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 8, right: 7),
                                                width: 140,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors.white
                                                              .withOpacity(
                                                                  0.67); // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      surfaceTintColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors
                                                              .transparent; // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      textStyle: MaterialStateProperty
                                                          .resolveWith<
                                                                  TextStyle?>(
                                                              (states) => TextStyle(
                                                                  fontFamily:
                                                                      'Gotham',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13)), //border width and color
                                                      elevation:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  double?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          return 3; // Defer to the widget's default.
                                                        },
                                                      ), //elevation of button
                                                      shape: MaterialStateProperty
                                                          .resolveWith<
                                                                  RoundedRectangleBorder?>(
                                                              (Set<MaterialState>
                                                                  states) {
                                                        return RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28));
                                                      }),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors
                                                                .black12; //<-- SEE HERE
                                                          }
                                                          return null; // Defer to the widget's default.
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () => {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Read Full",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(CupertinoIcons
                                                            .arrow_up_right_square)
                                                      ],
                                                    )),
                                              ),
                                            ]),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.only(left: 15, right: 5),
                            elevation: 20,
                            child: Container(
                              width: 200,
                              height: 300,
                              decoration: BoxDecoration(
                                  // color: Color(0xff214D56),
                                  // color: Colors.amberAccent,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dashboard_bg14_portait.jpg"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            color: Colors.blue.shade50,
                                            backgroundBlendMode:
                                                BlendMode.softLight),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "Title of the first Post is really awesome",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 20,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 35,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "The discription of this post is also very impressive and very looooong",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontSize: 14,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 8, right: 7),
                                                width: 140,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors.white
                                                              .withOpacity(
                                                                  0.67); // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      surfaceTintColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors
                                                              .transparent; // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      textStyle: MaterialStateProperty
                                                          .resolveWith<
                                                                  TextStyle?>(
                                                              (states) => TextStyle(
                                                                  fontFamily:
                                                                      'Gotham',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13)), //border width and color
                                                      elevation:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  double?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          return 3; // Defer to the widget's default.
                                                        },
                                                      ), //elevation of button
                                                      shape: MaterialStateProperty
                                                          .resolveWith<
                                                                  RoundedRectangleBorder?>(
                                                              (Set<MaterialState>
                                                                  states) {
                                                        return RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28));
                                                      }),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors
                                                                .black12; //<-- SEE HERE
                                                          }
                                                          return null; // Defer to the widget's default.
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () => {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Read Full",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(CupertinoIcons
                                                            .arrow_up_right_square)
                                                      ],
                                                    )),
                                              ),
                                            ]),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.only(left: 25, right: 5),
                            elevation: 20,
                            child: Container(
                              width: 200,
                              height: 300,
                              decoration: BoxDecoration(
                                  // color: Color(0xff214D56),
                                  // color: Colors.amberAccent,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dashboard_bg15_portait.jpg"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            color: Colors.blue.shade50,
                                            backgroundBlendMode:
                                                BlendMode.softLight),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "Title of the first Post is really awesome",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 20,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 35,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "The discription of this post is also very impressive and very looooong",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontSize: 14,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 8, right: 7),
                                                width: 140,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors.white
                                                              .withOpacity(
                                                                  0.67); // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      surfaceTintColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors
                                                              .transparent; // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      textStyle: MaterialStateProperty
                                                          .resolveWith<
                                                                  TextStyle?>(
                                                              (states) => TextStyle(
                                                                  fontFamily:
                                                                      'Gotham',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13)), //border width and color
                                                      elevation:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  double?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          return 3; // Defer to the widget's default.
                                                        },
                                                      ), //elevation of button
                                                      shape: MaterialStateProperty
                                                          .resolveWith<
                                                                  RoundedRectangleBorder?>(
                                                              (Set<MaterialState>
                                                                  states) {
                                                        return RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28));
                                                      }),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors
                                                                .black12; //<-- SEE HERE
                                                          }
                                                          return null; // Defer to the widget's default.
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () => {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Read Full",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(CupertinoIcons
                                                            .arrow_up_right_square)
                                                      ],
                                                    )),
                                              ),
                                            ]),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.only(left: 15, right: 5),
                            elevation: 20,
                            child: Container(
                              width: 200,
                              height: 300,
                              decoration: BoxDecoration(
                                  color: Colors.black45,
                                  backgroundBlendMode: BlendMode.softLight,
                                  // color: Colors.amberAccent,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dashboard_bg16_portait.jpg"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            color: Colors.red.shade100,
                                            backgroundBlendMode:
                                                BlendMode.softLight),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "Title of the first Post is really awesome",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 20,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 35,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  "The discription of this post is also very impressive and very looooong",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontSize: 14,
                                                      fontFamily: "Gotham",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 8, right: 7),
                                                width: 140,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors.white
                                                              .withOpacity(
                                                                  0.67); // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      surfaceTintColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          //<-- SEE HERE
                                                          return Colors
                                                              .transparent; // Defer to the widget's default.
                                                        }, //background color of button
                                                      ),
                                                      textStyle: MaterialStateProperty
                                                          .resolveWith<
                                                                  TextStyle?>(
                                                              (states) => TextStyle(
                                                                  fontFamily:
                                                                      'Gotham',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13)), //border width and color
                                                      elevation:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  double?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          return 3; // Defer to the widget's default.
                                                        },
                                                      ), //elevation of button
                                                      shape: MaterialStateProperty
                                                          .resolveWith<
                                                                  RoundedRectangleBorder?>(
                                                              (Set<MaterialState>
                                                                  states) {
                                                        return RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28));
                                                      }),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors
                                                                .black12; //<-- SEE HERE
                                                          }
                                                          return null; // Defer to the widget's default.
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () => {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Read Full",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(CupertinoIcons
                                                            .arrow_up_right_square)
                                                      ],
                                                    )),
                                              ),
                                            ]),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                  // ? Section 4 -- New Challenges -- Starting
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "New Challenges",
                          style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                        ),
                        InkWell(
                            onTap: () => {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "View All ",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                Icon(CupertinoIcons.arrow_right)
                              ],
                            ))
                      ]),
                ),
                Container(
                  // ? Section 4 -- New Challenges -- Starting
                  color: Colors.transparent,
                  height: 300,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  margin: EdgeInsets.all(12),

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                      backgroundBlendMode: BlendMode.colorBurn,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: 0.9,
                                          filterQuality: FilterQuality.none,
                                          image: AssetImage(
                                              "assets/images/dashboard_bg5_landscape.jpg"))),
                                  child: Center(
                                    child: Text(
                                      "Activities",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Gotham",
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  // height: 110,
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue.shade50,
                                      backgroundBlendMode: BlendMode.softLight,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: 0.9,
                                          filterQuality: FilterQuality.none,
                                          image: AssetImage(
                                              "assets/images/dashboard_bg8_landscape.jpg"))),
                                  // height: 110,
                                  child: Center(
                                    child: Text(
                                      "Quiz",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Gotham",
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                      backgroundBlendMode: BlendMode.darken,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: 0.7,
                                          filterQuality: FilterQuality.none,
                                          image: AssetImage(
                                              "assets/images/dashboard_bg10_landscape.jpg"))),
                                  // height: 110,
                                  child: Center(
                                    child: Text(
                                      "Family Bonding",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Gotham",
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                      backgroundBlendMode: BlendMode.darken,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: 0.7,
                                          filterQuality: FilterQuality.none,
                                          image: AssetImage(
                                              "assets/images/dashboard_bg9_landscape.jpg"))),
                                  // height: 110,
                                  child: Center(
                                    child: Text(
                                      "Sustainability",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Gotham",
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]);
      }),
    );
  }

  Widget atGlanceScrollView() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 339,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
            // return CircularProgressIndicator.adaptive();
          }
          print("-------0000000000----------");
          // print((snapshot.data!["stepsCount"]).last["steps"].toString());
          bool isPending = false;
          try {
            if (snapshot.data!["requestPending"]) {
              isPending = true;
            }
          } catch (e) {
            print(e);
          }
          return Container(
            //? Section 1 -- At Glance -- Contents
            // color: Colors.lime.shade300,
            height: 339,
            child: SingleChildScrollView(
                // physics: ScrollPhysi,

                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.only(left: 15, right: 5),
                      elevation: 20,
                      child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            // color: Color(0xff214D56),
                            // color: Colors.amberAccent,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/dashboard_bg14_portait.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8)),
                        child: Stack(children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                      bottom: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: Colors.blue,
                                      color: Colors.blue.shade50,
                                      backgroundBlendMode: BlendMode.softLight,
                                    ),
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin:
                                          EdgeInsets.only(bottom: 0, right: 4),
                                      // width: 50,
                                      // height: 50,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            maximumSize: MaterialStateProperty
                                                .resolveWith<Size?>(
                                              (Set<MaterialState> states) {
                                                //<-- SEE HERE
                                                return Size(175,
                                                    50); // Defer to the widget's default.
                                              }, //background color of button
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                //<-- SEE HERE
                                                return Colors.white.withOpacity(
                                                    0.67); // Defer to the widget's default.
                                              }, //background color of button
                                            ),
                                            surfaceTintColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                //<-- SEE HERE
                                                return Colors
                                                    .transparent; // Defer to the widget's default.
                                              }, //background color of button
                                            ),
                                            textStyle: MaterialStateProperty
                                                .resolveWith<TextStyle?>(
                                                    (states) => TextStyle(
                                                        fontFamily: 'Gotham',
                                                        color: Colors.black,
                                                        fontSize:
                                                            13)), //border width and color
                                            elevation: MaterialStateProperty
                                                .resolveWith<double?>(
                                              (Set<MaterialState> states) {
                                                return 3; // Defer to the widget's default.
                                              },
                                            ), //elevation of button
                                            shape: MaterialStateProperty
                                                .resolveWith<
                                                        RoundedRectangleBorder?>(
                                                    (Set<MaterialState>
                                                        states) {
                                              return RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28));
                                            }),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return Colors
                                                      .black12; //<-- SEE HERE
                                                }
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () => {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Detailed Report",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Icon(CupertinoIcons
                                                  .arrow_up_right_square)
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    // color: Colors.black26,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              "Power Consumption",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "Gotham",
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlue
                                                    .withOpacity(0.67),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.show_chart_rounded,
                                                  color: Colors.white,
                                                ),
                                                (!isPending)
                                                    ? FutureBuilder(
                                                        future: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "family")
                                                            .where("accountNo",
                                                                isEqualTo: snapshot
                                                                        .data![
                                                                    "accountNo"])
                                                            .get(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return CircularProgressIndicator
                                                                .adaptive();
                                                          }

                                                          return FutureBuilder(
                                                              future: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Data")
                                                                  .doc(snapshot
                                                                          .data!
                                                                          .docs
                                                                          .first[
                                                                      "deviceId"])
                                                                  .get(),
                                                              builder: ((context,
                                                                  snapshot) {
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                    "...",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          "Gotham",
                                                                      color: Colors
                                                                          .white,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  );
                                                                }

                                                                print(((snapshot
                                                                            .data!["historicalData"])
                                                                        .last["units"])
                                                                    .toString());
                                                                print(((snapshot.data![
                                                                            "historicalData"])
                                                                        .last[
                                                                            "units"]
                                                                        .roundToDouble())
                                                                    .toString());
                                                                return Text(
                                                                  ((snapshot.data!["historicalData"])
                                                                              .last[
                                                                          "units"])
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        "Gotham",
                                                                    color: Colors
                                                                        .white,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                );
                                                              }));
                                                        })
                                                    : Text(
                                                        "NA",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "Gotham",
                                                          color: Colors.white,
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                Icon(
                                                  CupertinoIcons.arrow_up,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              ]),
                          (isPending)
                              ? Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      backgroundBlendMode: BlendMode.darken,
                                      color: Colors.black38),
                                  child: Center(
                                    child: Text(
                                      "Your request is still pending",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ))
                              : SizedBox(),
                        ]),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 20, right: 5),
                      elevation: 20,
                      child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            // color: Color(0xff214D56),
                            color: Colors.black12,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/dashboard_bg5_portait_compressed.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Colors.blue,
                                      color: Colors.blue.shade50,
                                      backgroundBlendMode: BlendMode.softLight),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Daily Steps Goal",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Gotham",
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            (snapshot.data!["stepsCount"])
                                                    .last["steps"]
                                                    .toString() +
                                                " / " +
                                                (snapshot.data!["stepsGoal"]
                                                        .toString() ??
                                                    "NA"),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Gotham",
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 8, right: 7),
                                          width: 120,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    //<-- SEE HERE
                                                    return Colors.white.withOpacity(
                                                        0.67); // Defer to the widget's default.
                                                  }, //background color of button
                                                ),
                                                surfaceTintColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    //<-- SEE HERE
                                                    return Colors
                                                        .transparent; // Defer to the widget's default.
                                                  }, //background color of button
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .resolveWith<TextStyle?>(
                                                        (states) => TextStyle(
                                                            fontFamily:
                                                                'Gotham',
                                                            color: Colors.black,
                                                            fontSize:
                                                                13)), //border width and color
                                                elevation: MaterialStateProperty
                                                    .resolveWith<double?>(
                                                  (Set<MaterialState> states) {
                                                    return 3; // Defer to the widget's default.
                                                  },
                                                ), //elevation of button
                                                shape: MaterialStateProperty
                                                    .resolveWith<
                                                            RoundedRectangleBorder?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                  return RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28));
                                                }),
                                                overlayColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .pressed)) {
                                                      return Colors
                                                          .black12; //<-- SEE HERE
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: () => {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Details",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Icon(CupertinoIcons
                                                      .arrow_up_right_square)
                                                ],
                                              )),
                                        ),
                                      ]),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 15, right: 5),
                      elevation: 20,
                      child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            // color: Color(0xff214D56),
                            // color: Colors.amberAccent,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/dashboard_bg9_portait.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Colors.blue,
                                      color: Colors.blue.shade50,
                                      backgroundBlendMode: BlendMode.softLight),
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    margin:
                                        EdgeInsets.only(bottom: 0, right: 4),
                                    width: 50,
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          maximumSize: MaterialStateProperty
                                              .resolveWith<Size?>(
                                            (Set<MaterialState> states) {
                                              //<-- SEE HERE
                                              return Size(160,
                                                  50); // Defer to the widget's default.
                                            }, //background color of button
                                          ),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              //<-- SEE HERE
                                              return Colors.white.withOpacity(
                                                  0.67); // Defer to the widget's default.
                                            }, //background color of button
                                          ),
                                          surfaceTintColor:
                                              MaterialStateProperty.resolveWith<
                                                  Color?>(
                                            (Set<MaterialState> states) {
                                              //<-- SEE HERE
                                              return Colors
                                                  .transparent; // Defer to the widget's default.
                                            }, //background color of button
                                          ),
                                          textStyle: MaterialStateProperty
                                              .resolveWith<TextStyle?>(
                                                  (states) => TextStyle(
                                                      fontFamily: 'Gotham',
                                                      color: Colors.black,
                                                      fontSize:
                                                          13)), //border width and color
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
                                                    BorderRadius.circular(28));
                                          }),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return Colors
                                                    .black12; //<-- SEE HERE
                                              }
                                              return null; // Defer to the widget's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () => {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Leaderboard",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Icon(CupertinoIcons
                                                .arrow_up_right_square)
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            "Individual Rank",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Gotham",
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          width: 130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.lightGreen
                                                  .withOpacity(0.67),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(
                                            bottom: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .chart_bar_alt_fill,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                snapshot.data!["individualRank"]
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Gotham",
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                CupertinoIcons.arrow_up,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 15, right: 5),
                      elevation: 20,
                      child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            // color: Color(0xff214D56),
                            // color: Colors.amberAccent,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/dashboard_bg10_portait.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8)),
                        child: Stack(
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      decoration: BoxDecoration(
                                          // color: Colors.blue,
                                          color: Colors.blue.shade50,
                                          backgroundBlendMode:
                                              BlendMode.softLight),
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(
                                            bottom: 0, right: 4),
                                        width: 50,
                                        height: 50,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              maximumSize: MaterialStateProperty
                                                  .resolveWith<Size?>(
                                                (Set<MaterialState> states) {
                                                  //<-- SEE HERE
                                                  return Size(160,
                                                      50); // Defer to the widget's default.
                                                }, //background color of button
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  //<-- SEE HERE
                                                  return Colors.white.withOpacity(
                                                      0.67); // Defer to the widget's default.
                                                }, //background color of button
                                              ),
                                              surfaceTintColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  //<-- SEE HERE
                                                  return Colors
                                                      .transparent; // Defer to the widget's default.
                                                }, //background color of button
                                              ),
                                              textStyle: MaterialStateProperty
                                                  .resolveWith<TextStyle?>(
                                                      (states) => TextStyle(
                                                          fontFamily: 'Gotham',
                                                          color: Colors.black,
                                                          fontSize:
                                                              13)), //border width and color
                                              elevation: MaterialStateProperty
                                                  .resolveWith<double?>(
                                                (Set<MaterialState> states) {
                                                  return 3; // Defer to the widget's default.
                                                },
                                              ), //elevation of button
                                              shape: MaterialStateProperty
                                                  .resolveWith<
                                                          RoundedRectangleBorder?>(
                                                      (Set<MaterialState>
                                                          states) {
                                                return RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28));
                                              }),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed)) {
                                                    return Colors
                                                        .black12; //<-- SEE HERE
                                                  }
                                                  return null; // Defer to the widget's default.
                                                },
                                              ),
                                            ),
                                            onPressed: () => {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Leaderboard",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Icon(CupertinoIcons
                                                    .arrow_up_right_square)
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                "Family Rank",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Gotham",
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              width: 130,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.lightGreen
                                                      .withOpacity(0.67),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .chart_bar_alt_fill,
                                                    color: Colors.white,
                                                  ),
                                                  (!isPending)
                                                      ? FutureBuilder(
                                                          future: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "family")
                                                              .where("accountNo",
                                                                  isEqualTo: snapshot
                                                                          .data![
                                                                      "accountNo"])
                                                              .get(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return CircularProgressIndicator
                                                                  .adaptive();
                                                            }

                                                            return Text(
                                                              snapshot
                                                                  .data!
                                                                  .docs
                                                                  .first[
                                                                      "familyRank"]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Gotham",
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          })
                                                      : Text(
                                                          "NA",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "Gotham",
                                                            color: Colors.white,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        )

                                                  // // "rank",
                                                  ,
                                                  Icon(
                                                    CupertinoIcons.arrow_up,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  )
                                ]),
                            (isPending)
                                ? Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        backgroundBlendMode: BlendMode.darken,
                                        color: Colors.black38),
                                    child: Center(
                                      child: Text(
                                        "Your request is still pending",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        }));
  }

  Widget consumptionGraph() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        bool isPending = false;
        try {
          if (snapshot.data!["requestPending"]) {
            isPending = true;
          }
        } catch (e) {
          print(e);
        }
        if (isPending) {
          return AspectRatio(
              aspectRatio: 1.70,
              child: Center(
                child: Text(
                  "Your request is still pending",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ));
        }

        return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("family")
                .where("accountNo", isEqualTo: snapshot.data!["accountNo"])
                .get(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("Data")
                      .doc(snapshot.data!.docs.first["deviceId"])
                      .get(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    // ? get needed data
                    // print(snapshot.data!["historicalData"]);
                    int maxLength = 12;
                    List<double> temp = [];
                    List<FlSpot> tempSpots = [];

                    for (var data
                        in snapshot.data!["historicalData"].reversed.toList()) {
                      print(data);
                      temp.add(data["units"]);

                      maxLength--;
                      if (maxLength <= 0) break;
                    }

                    temp = temp.reversed.toList();
                    double index = 0;

                    for (var units in temp) {
                      tempSpots.add(FlSpot(index, units));
                      index++;
                    }

                    return AspectRatio(
                      aspectRatio: 1.70,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                          left: 6,
                          top: 12,
                          bottom: 7,
                        ),
                        child: LineChart(
                          // _showAvg ? avgData() : mainData(),
                          recentConsumptionGraph(tempSpots),
                        ),
                      ),
                    );
                  }));
            }));
      },
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    // switch (value.toInt()) {
    //   case 2:
    //     text = const Text('', style: style);
    //     break;
    //   case 5:
    //     text = const Text('', style: style);
    //     break;
    //   case 8:
    //     text = const Text('', style: style);
    //     break;
    //   default:
    //     text = const Text('', style: style);
    //     break;
    // }

    int hour = DateTime.now().hour;
    // int hour = 7;

    int val = ((hour - (12 - value)) % 24).toInt();
    text = Text(
      val.toString(),
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = value.toString();
    // switch (value.toInt()) {
    //   case 1:
    //     text = ;
    //     break;
    //   case 3:
    //     text = '30k';
    //     break;
    //   case 5:
    //     text = '50k';
    //     break;
    //   default:
    //     return Container();
    // }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData recentConsumptionGraph(List<FlSpot> spots) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      // maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
