// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
// import 'package:googleapis/sheets/v4.dart';

class detailedReports extends StatefulWidget {
  const detailedReports({super.key});

  @override
  State<detailedReports> createState() => _detailedReportsState();
}

class _detailedReportsState extends State<detailedReports> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  late final TextEditingController _goal;
  final _goalForm = GlobalKey<FormState>();

  @override
  void initState() {
    _goal = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        actions: const [
          // IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
          // IconButton(
          //     onPressed: () async {}, icon: Icon(CupertinoIcons.gear_alt))
        ],
        title: Text(
          "Detailed Reports",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }

                var individualRank = snapshot.data!["individualRank"];
                var individualScore = snapshot.data!["individualScore"];
                bool is_requested = true;
                try {
                  is_requested = snapshot.data!["isRequested"];
                } catch (_) {
                  is_requested = false;
                }

                var stepsCount = snapshot.data!["stepsCount"];
                int totalSteps = 0;
                DateTime dtFirst =
                    (snapshot.data!["stepsCount"].first["date"] as Timestamp)
                        .toDate();

                int currMonth = DateTime.now().month;
                int currYear = DateTime.now().year;

                for (var data in stepsCount) {
                  var tempDate = (data["date"] as Timestamp).toDate();
                  if (currMonth == tempDate.month &&
                      currYear == tempDate.year) {
                    totalSteps += (data["steps"] as int);
                  }
                }

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 40,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Individual Rank",
                              style:
                                  TextStyle(fontSize: 25, fontFamily: "Gotham"),
                            ),
                            Text(
                              individualRank.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Gotham",
                                  color: Colors.green.shade600),
                            ),
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 40,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Individual Score",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: "Gotham",
                              ),
                            ),
                            Text(
                              individualScore.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Gotham",
                                  color: Colors.green.shade600),
                            ),
                          ]),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    //   height: 40,
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           "Total Steps of month",
                    //           style: TextStyle(
                    //             fontSize: 25,
                    //             fontFamily: "Gotham",
                    //           ),
                    //         ),
                    //         Text(
                    //           totalSteps.toString(),
                    //           style: TextStyle(
                    //               fontSize: 25,
                    //               fontFamily: "Gotham",
                    //               color: Colors.green.shade600),
                    //         ),
                    //       ]),
                    // ),
                    // (is_requested)
                    //     ? SizedBox()
                    //     : FutureBuilder(
                    //         future: FirebaseFirestore.instance
                    //             .collection("family")
                    //             .where("accountNo",
                    //                 isEqualTo: snapshot.data!["accountNo"])
                    //             .get(),
                    //         builder: ((context, snapshot) {
                    //           if (!snapshot.hasData) {
                    //             return Container(
                    //               height: 40,
                    //               child: Center(
                    //                   child:
                    //                       CircularProgressIndicator.adaptive()),
                    //             );
                    //           }

                    //           var familyRank =
                    //               snapshot.data!.docs.first["familyRank"];

                    //           return Container(
                    //             margin: EdgeInsets.only(
                    //                 left: 15, right: 15, top: 15),
                    //             height: 40,
                    //             child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Text(
                    //                     "Family Rank",
                    //                     style: TextStyle(
                    //                       fontSize: 25,
                    //                       fontFamily: "Gotham",
                    //                     ),
                    //                   ),
                    //                   Text(
                    //                     familyRank.toString(),
                    //                     style: TextStyle(
                    //                         fontSize: 25,
                    //                         fontFamily: "Gotham",
                    //                         color: Colors.green.shade600),
                    //                   ),
                    //                 ]),
                    //           );
                    //         }))
                  ],
                );
              },
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 0.5)),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            //   height: 40,
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "Steps Count this Month",
            //           style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
            //         ),
            //       ]),
            // ),
            // FutureBuilder(
            //   future: FirebaseFirestore.instance
            //       .collection("Users")
            //       .doc(FirebaseAuth.instance.currentUser!.email)
            //       .get(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const SizedBox(
            //         height: 600,
            //         width: double.infinity,
            //         child: Center(child: CircularProgressIndicator.adaptive()),
            //       );
            //     }

            //     print("got Data");

            //     var stepsData = snapshot.data!["stepsCount"];
            //     return Container(
            //         // ? Section 2 -- Consumption -- Starting
            //         height: 250,
            //         margin: EdgeInsets.all(15),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(21),
            //             // color: Colors.amber,
            //             image: DecorationImage(
            //                 image: AssetImage(
            //                     "assets/images/dashboard_bg3_landscape.jpg"),
            //                 fit: BoxFit.cover),
            //             boxShadow: const [
            //               BoxShadow(
            //                   color: Colors.black12,
            //                   offset: Offset(0, 70),
            //                   blurRadius: 100,
            //                   blurStyle: BlurStyle.normal)
            //             ]),
            //         child: stepsGraph(stepsData));
            //   },
            // ),
            // Container(
            //   margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            //   height: 80,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Set a Daily Step Goal",
            //         style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
            //       ),
            //     ],
            //   ),
            // ),
            // Form(
            //   key: _goalForm,
            //   child: Column(
            //     children: [
            //       FutureBuilder(
            //           future: FirebaseFirestore.instance
            //               .collection("Users")
            //               .doc(FirebaseAuth.instance.currentUser!.email)
            //               .get(),
            //           builder: ((context, snapshot) {
            //             if (!snapshot.hasData) {
            //               return SizedBox(
            //                 height: 40,
            //               );
            //             }

            //             var _goalNumber = "NA";
            //             try {
            //               _goalNumber = (snapshot.data!["stepsGoal"] as String);
            //             } catch (_) {}
            //             _goal.text = _goalNumber;
            //             return Container(
            //               margin: const EdgeInsets.only(
            //                   left: 20, right: 20, top: 15),
            //               padding: EdgeInsets.only(left: 10, right: 10),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(12),
            //                 color: Colors.white.withOpacity(0.5),
            //               ),
            //               child: TextFormField(
            //                 controller: _goal,
            //                 keyboardType: TextInputType.number,
            //                 obscureText: false,
            //                 enableSuggestions: false,
            //                 autocorrect: false,
            //                 decoration: InputDecoration(
            //                   labelText: "Daily Goal",
            //                   fillColor: Colors.white,
            //                   // border: InputBorder.none
            //                   // border: OutlineInputBorder(
            //                   //   borderRadius: BorderRadius.circular(8.0),
            //                   //   borderSide: const BorderSide(),
            //                   // ),
            //                   //fillColor: Colors.green
            //                 ),
            //                 validator: (value) {
            //                   if (value == null || value.isEmpty) {
            //                     return "Life is nothing without a goal";
            //                   } else {
            //                     return null;
            //                   }
            //                 },
            //                 style: const TextStyle(
            //                   fontFamily: "Epilogue",
            //                 ),
            //               ),
            //             );
            //           })),
            //       InkWell(
            //         onTap: () async {
            //           if (_goalForm.currentState!.validate()) {
            //             var data = {"stepsGoal": int.parse(_goal.text)};

            //             await FirebaseFirestore.instance
            //                 .collection("Users")
            //                 .doc(FirebaseAuth.instance.currentUser!.email)
            //                 .set(data, SetOptions(merge: true));
            //           }
            //         },
            //         child: Container(
            //           height: 40,
            //           width: 90,
            //           margin: EdgeInsets.all(15),
            //           padding: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               color: Colors.green.shade300,
            //               borderRadius: BorderRadius.circular(10)),
            //           child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 Text(
            //                   "Save",
            //                   style: TextStyle(fontSize: 18),
            //                 ),
            //                 Icon(CupertinoIcons.checkmark_alt)
            //               ]),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              height: 80,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Electricity Consumption\nthis Month",
                      style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                    ),
                  ]),
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child:
                          Center(child: CircularProgressIndicator.adaptive()),
                    );
                  }

                  var stepsData = snapshot.data!["stepsCount"];
                  return Container(
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
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 70),
                                blurRadius: 100,
                                blurStyle: BlurStyle.normal)
                          ]),
                      child: consumptionGraph());
                }),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              // height: 100,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Set a Monthly Consumption \nGoal",
                    style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                  ),
                ],
              ),
            ),
            Form(
              key: _goalForm,
              child: Column(
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .get(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: 40,
                        );
                      }

                      var _goalNumber = "NA";
                      try {
                        print(snapshot.data!.data());
                        _goalNumber = snapshot.data!["unitsGoal"].toString();
                        print("Goal Number $_goalNumber");
                      } catch (_) {}
                      _goal.text = _goalNumber;
                      return Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: TextFormField(
                          controller: _goal,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Monthly Goal (in Units)",
                            fillColor: Colors.white,
                            // border: InputBorder.none
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(8.0),
                            //   borderSide: const BorderSide(),
                            // ),
                            //fillColor: Colors.green
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Life is nothing without a goal";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                            fontFamily: "Epilogue",
                          ),
                        ),
                      );
                    }),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_goalForm.currentState!.validate()) {
                        var data = {"unitsGoal": int.parse(_goal.text)};

                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .set(data, SetOptions(merge: true));
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 90,
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Save",
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(CupertinoIcons.checkmark_alt)
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepsGraph(List stepsData) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("Users").get(),
      builder: (context, snapshot) {
        // return AspectRatio(
        //     aspectRatio: 1.70,
        //     child: Center(
        //       child: Text(
        //         "Your request is still pending",
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ));

        // ? get needed data
        // print(snapshot.data!["historicalData"]);
        if (!snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 12,
                left: 6,
                top: 12,
                bottom: 7,
              ),
            ),
          );
        }
        List<double> daysWise = [];
        List<double> dates = [];
        List<FlSpot> tempSpots = [];
        DateTime dtFirst = (stepsData.first["date"] as Timestamp).toDate();
        int prevDate = 0;
        // snapshot.data!["historicalData"].first["date"];
        int prevMonth = DateTime.now().month;
        // snapshot.data!["stepsCount"].first["month"];
        // int prevMonth = DateTime.now().month - 1;
        int prevYear = DateTime.now().year;
        // snapshot.data!["stepsCount"].first["year"];
        // print(snapshot.data!["stepsCount"].first["date"]);
        print(dtFirst);

        print(prevDate);
        print(prevMonth);
        print(prevYear);

        int currDate = 0;
        int currMonth = prevMonth;
        int currYear = prevYear;
        double tempUnits = 0;
        int bottomInterval = 7;
        int leftInterval = 1;

        int max = 0;

        for (var data in stepsData) {
          print(data);
          DateTime dtCurr = (data["date"] as Timestamp).toDate();

          currDate = dtCurr.day;
          currMonth = dtCurr.month;
          currYear = dtCurr.year;

          if (currYear > prevYear ||
              (currYear == prevYear && currMonth > prevMonth) ||
              (currYear == prevYear &&
                  currMonth == prevMonth &&
                  currDate > prevDate)) {
            prevDate = currDate;
            prevMonth = currMonth;
            prevYear = currYear;

            dates.add(double.parse(currDate.toString()));
            daysWise.add(data["steps"].toDouble());
            print("steps last added");
            max = (max < data["steps"]) ? data["steps"] : max;
          } else if (currYear == prevYear &&
              currMonth == prevMonth &&
              currDate == prevDate) {
            // daysWise.last = data["units"];
            daysWise[daysWise.length - 1] = data["steps"].toDouble();
            max = (max < data["steps"]) ? data["steps"] : max;
            print("steps last updated");
          }
        }
        print("Max $max");
        leftInterval = max ~/ 5;
        print("LeftInterval $leftInterval");
        // leftInterval = 5000;

        print(daysWise);
        print(dates);

        // daysWise = daysWise.reversed.toList();
        int index = 0;

        for (index = 0; index < daysWise.length; index++) {
          tempSpots.add(FlSpot(dates[index], daysWise[index]));
        }
        // for (var units in daysWise) {
        //   tempSpots.add(FlSpot(index, units));
        //   index++;
        // }

        print("Steps ${tempSpots}");

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
              recentConsumptionGraph(tempSpots, leftInterval, bottomInterval),
            ),
          ),
        );
      },
    );
  }

  Widget consumptionGraph() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState != ConnectionState.done) {
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

                    List<double> daysWise = [];
                    List<double> dates = [];
                    List<FlSpot> tempSpots = [];
                    int prevDate = 0;
                    // snapshot.data!["historicalData"].first["date"];
                    int prevMonth =
                        snapshot.data!["historicalData"].first["month"];
                    // int prevMonth = DateTime.now().month - 1;
                    int prevYear =
                        snapshot.data!["historicalData"].first["year"];

                    print(prevDate);
                    print(prevMonth);
                    print(prevYear);

                    int currDate = 0;
                    int currMonth = prevMonth;
                    int currYear = prevYear;
                    double tempUnits = 0;

                    for (var data in snapshot.data!["historicalData"]) {
                      print(data);
                      currDate = data["date"];
                      currMonth = data["month"];
                      currYear = data["year"];

                      if (currYear > prevYear ||
                          (currYear == prevYear && currMonth > prevMonth) ||
                          (currYear == prevYear &&
                              currMonth == prevMonth &&
                              currDate > prevDate)) {
                        prevDate = currDate;
                        prevMonth = currMonth;
                        prevYear = currYear;

                        dates.add(double.parse(currDate.toString()));
                        daysWise.add(data["units"]);
                        print("last added");
                      } else if (currYear == prevYear &&
                          currMonth == prevMonth &&
                          currDate == prevDate) {
                        // daysWise.last = data["units"];
                        daysWise[daysWise.length - 1] = data["units"];
                        print("last updated");
                      }
                    }

                    print(daysWise);
                    print(dates);

                    // daysWise = daysWise.reversed.toList();
                    int index = 0;

                    for (index = 0; index < daysWise.length; index++) {
                      tempSpots.add(FlSpot(dates[index], daysWise[index]));
                    }
                    // for (var units in daysWise) {
                    //   tempSpots.add(FlSpot(index, units));
                    //   index++;
                    // }

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
                          recentConsumptionGraph(tempSpots, 20, 7),
                        ),
                      ),
                    );
                  }));
            }));
      },
    );
  }

  LineChartData recentConsumptionGraph(List<FlSpot> spots,
      [int leftInterval = 1, int bottomInterval = 1]) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        // drawVerticalLine: true,
        horizontalInterval: 1000,
        verticalInterval: 1000,
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
            interval: bottomInterval.toDouble(),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: leftInterval.toDouble(),
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 45,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      // maxX: 11,
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

  Widget bottomTitleWidgets(double val, TitleMeta meta) {
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

    // int hour = DateTime.now().hour;
    // int hour = 7;

    // int val = ((hour - (12 - value)) % 24).toInt();
    // if (val.toInt() % 7 == 0) {
    text = Text(
      val.toInt().toString(),
      style: style,
    );
    // } else {
    //   text = Text(
    //     "",
    //     style: style,
    //   );
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, {int precision = 2}) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text = value.toPrecision(precision).toString();
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
    // if (value == 0 || value == meta.appliedInterval || value == meta.max) {
    return Text(text, style: style, textAlign: TextAlign.left);
    // }

    return Text("", style: style, textAlign: TextAlign.left);
  }
}
