// import 'package:energy_tracker/firebase_options.dart';
import 'package:energy_tracker/loginMethods/google_sign_in.dart';
// import 'package:energy_tracker/main.dart';
// import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/Login/login_page.dart';
// import 'package:energy_tracker/pages/dashboard/temp.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'dart:async';
// import 'dart:math';
// import 'package:';

// import 'package:google_fonts/google_fonts.dart';

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class Dashboard extends StatefulWidget {
  // late User? user;
  Dashboard({super.key});
  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];

  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withOpacity(0);
  final Color barColor = Color.fromARGB(200, 20, 77, 90);
  final Color touchedBarColor = Color.fromARGB(255, 200, 200, 42);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int touchedIndex = -1;
  // late User? user;

  // _DashboardState(this.user);

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isPlaying = false;
  final Duration animDuration = const Duration(milliseconds: 50);

  String dropdownValueBill = "Monthly";
  String dropdownValueSteps = "Monthly";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color backgroundColor = Color(0xff214D56);
    final Color mainTextColor = Color.fromARGB(199, 232, 234, 175);
    final Color supportTextColor = Color.fromARGB(164, 232, 234, 175);
    // final temp = MediaQuery.of(context).;
    String? username = auth.currentUser?.displayName ?? "";
    // String? username = user?.displayName ?? "";

    // if (user == null) {
    //   Navigator.pop(context);
    // }

    return Container(
      //
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //     colors: [
          //       const Color(0xffC1E6DA),
          //       const Color(0xFF426FA0),
          //     ],
          // begin: AlignmentDirectional(0.07, -1),
          // end: AlignmentDirectional(-0.07, 1),
          // stops: [0.0, 1.0],
          // tileMode: TileMode.clamp),
          ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.mainTextColor1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Green Quotient",
                style: TextStyle(
                    fontFamily: "Epilogue", fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () async {
                  CustomSignOut();
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  // padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/profile3_copy.png"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(90)),
                ),
              )
            ],
          ),

          // shape: ,
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 16,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      // color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                  child: Text(
                    'Dashboard',
                    // style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
                Text(
                  'Hello World',
                  // style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                Text(
                  'Hello World',
                  // style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
          ),
        ),
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // Heading
                  height: size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Color(0xff214D56),
                    // image: DecorationImage(
                    //     image: AssetImage("assets/images/390.jpg"),
                    //     fit: BoxFit.cover),

                    // border: Border.all(
                    //   color: Color(0xff5b8bca),
                    //   width: 2,
                    // ),

                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        // decoration: BoxDecoration(border: Border.all()),
                        // height: 60,
                        // margin: EdgeInsets.only(top: 45),
                        padding: EdgeInsets.only(right: 12, left: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi, " + username,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: AppColors.mainTextColor1,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Epilogue"),
                                ),
                                Text(
                                  "Dashboard",
                                  style: TextStyle(
                                      color: supportTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Epilogue"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // bills chart
                  // height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Bills",
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30),
                            ),
                            DropdownButton<String>(
                              // Step 3.
                              value: dropdownValueBill,
                              elevation: 8,
                              // Step 4.
                              items: <String>[
                                'Monthly',
                                // 'Yearly',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: backgroundColor),
                                  ),
                                );
                              }).toList(),
                              // Step 5.
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueBill = newValue!;
                                });
                              },
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        padding: EdgeInsets.only(left: 12),
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // steps count chart
                  // height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Steps Count",
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30),
                            ),
                            DropdownButton<String>(
                              // Step 3.
                              value: dropdownValueSteps,
                              elevation: 8,
                              // Step 4.
                              items: <String>[
                                'Weekly',
                                'Monthly',
                                // 'Yearly',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: backgroundColor),
                                  ),
                                );
                              }).toList(),
                              // Step 5.
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueSteps = newValue!;
                                });
                              },
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        padding: EdgeInsets.only(left: 12),
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Goals",
                            style: TextStyle(
                                color: backgroundColor,
                                fontFamily: "Epilogue",
                                fontWeight: FontWeight.w700,
                                fontSize: 30),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    // border: Border.all(),
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(40))),
                                width: 175,
                                height: 250,
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "",
                                      style: TextStyle(
                                          color: mainTextColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          // border: Border.all(),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/profile3_copy.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(90)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      borderData: FlBorderData(border: Border.all(width: 0)),
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: TextStyle(
                    color: AppColors.contentColorGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          axisNameSize: 15,
          sideTitles:
              SideTitles(showTitles: true, reservedSize: 55, interval: 75),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 20,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      // borderData: FlBorderData(show: true, border: Border.symmetric()),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 28, 63, 48),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;
      case 1:
        text = const Text('FEB', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('APR', style: style);
        break;
      case 4:
        text = const Text('MAY', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 6:
        text = const Text('JUL', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(i, 100, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(i, 123.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(i, 239, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(i, 300.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(i, 245, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(i, 324.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(i, 450.5, isTouched: i == touchedIndex);
          case 7:
            return makeGroupData(i, 133.5, isTouched: i == touchedIndex);
          case 8:
            return makeGroupData(i, 254.5, isTouched: i == touchedIndex);
          case 9:
            return makeGroupData(i, 323.5, isTouched: i == touchedIndex);
          case 10:
            return makeGroupData(i, 272.5, isTouched: i == touchedIndex);
          case 11:
            return makeGroupData(i, 351.5, isTouched: i == touchedIndex);

          default:
            return throw Error();
        }
      });

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 12,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    if (y < 200) {
      barColor = AppColors.contentColorGreen;
    } else if (y < 300) {
      barColor = AppColors.contentColorYellow;
    } else {
      barColor = AppColors.contentColorRed;
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 0.5 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor.darken(80))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
