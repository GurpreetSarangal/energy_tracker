import 'dart:math';

import 'package:energy_tracker/pages/profile/profile.dart';
import 'package:energy_tracker/pages/register/date_of_birth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/admin/reports_v1.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
// import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:health/health.dart';

void main() => runApp(const StepsPage());

class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  late String _timeString;
  int _getSteps = 0;
  int initKcals = 0;
  double initMiles = 0.0;
  int initMinutes = 0;
  double progressValue = 0.0;
  bool mounted = true;

  // StreamSubscription<StepCount>? _subscription;

  @override
  void initState() {
    // _listenToSteps();

    // _timeString = _formatDateTime(DateTime.now());
    // Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    super.initState();
  
  }

  HealthFactory health = HealthFactory();

  Future fetchStepDate() async {
    int? steps;

    var types = [
      HealthDataType.STEPS,
    ];

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    var permissions = [HealthDataAccess.READ];

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error ");
      }

      print("total number of steps: $steps");

      setState(() {
        _getSteps = (steps == null) ? 0 : steps;
      });
    } else {
      print("authorization not granted");
    }
  }

  // String _formatDateTime(DateTime dateTime) {
  //   return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  // }

  // void _getTime() {
  //   final DateTime now = DateTime.now();
  //   final String formattedDateTime = _formatDateTime(now);
  //   setState(() {
  //     _timeString = formattedDateTime;
  //   });
  // }

  // void _listenToSteps() {
  //   _subscription = Pedometer.stepCountStream.listen(
  //     _onStepCount,
  //     onError: _onError,
  //     onDone: _onDone,
  //     cancelOnError: true,
  //   );
  //   _subscription!.resume();
  //   print(_subscription.toString());
  // }

  // void _onStepCount(StepCount event) {
  //   setState(() {
  //     initSteps = event.steps;

  //     print("Step Count: ${event.steps}");
  //   });
  // }

  // void _onDone() {} // Handle when stream is done if needed

  // void _onError(error) {
  //   print("An error occurred while fetching step count: $error");
  // }

  @override
  void dispose() {
    // _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        leading: Icon(CupertinoIcons.question_circle),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        title: Text(
          "Detailed Reports",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(children: [
        Center(
          child: Text(
            '$_getSteps',
            style: const TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 100.0,
            ),
          ),
        ),
      ]),
    );
  }
}

int registerOneOffTask() {
  int variable = DateTime.timestamp().microsecondsSinceEpoch;
  print("inside register one off task ${variable}");
  return (variable % 15000) + MinCntStPrFromD2D;
}

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

// class StepsPage extends StatefulWidget {
//   const StepsPage({super.key});

//   @override
//   State<StepsPage> createState() => _StepsPageState();
// }

// class _StepsPageState extends State<StepsPage> {
// late Stream<StepCount> _stepCountStream;
// late Stream<PedestrianStatus> _pedestrianStatusStream;
// String _status = '?', _steps = '?';

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     print("This is end of init in steps page");
//   }

// void onStepCount(StepCount event) {
//   print("-----------001100100101010---------");
//   print(event);
//   print("-----------000111000111-------");
//   // setState(() {
//   //   _steps = event.steps.toString();
//   // });
// }

// void onPedestrianStatusChanged(PedestrianStatus event) {
  // print(event);
  // setState(() {
  //   _status = event.status;
  // });
// }

// void onPedestrianStatusError(error) {
//   print('onPedestrianStatusError: $error');
  // setState(() {
  //   _status = 'Pedestrian Status not available';
  // });
//   print(_status);
// }

// void onStepCountError(error) {
//   print('onStepCountError: $error');
//   // setState(() {
//   //   _steps = 'Step Count not available';
//   // });
// }

// void initPlatformState() async {
//   // bool mounted = true;
//   await Permission.activityRecognition.request();
//   _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
//   _pedestrianStatusStream
//       .listen(onPedestrianStatusChanged)
//       .onError(onPedestrianStatusError);

//   _stepCountStream = Pedometer.stepCountStream;
//   _stepCountStream.listen(onStepCount).onError(onStepCountError);

//   // if (!mounted) {
//   //   print("not mounted");
//   //   return;
//   // }
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       primary: true,
//       forceMaterialTransparency: true,
//       elevation: 40,
//       title: const Text('Pedometer Example'),
//       systemOverlayStyle: SystemUiOverlayStyle.dark,
//       toolbarHeight: 80,
//     ),
//     body: StreamBuilder<Object>(
//         stream: Pedometer.pedestrianStatusStream,
//         builder: (context, snapshot) {
//           print("----===-=-=-=-=--------");
//           print(snapshot.data);
//           print("----===-=-=-=-=--------");
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   'Steps Taken',
//                   style: TextStyle(fontSize: 30),
//                 ),
//                 Text(
//                   _steps,
//                   style: TextStyle(fontSize: 60),
//                 ),
//                 Divider(
//                   height: 100,
//                   thickness: 0,
//                   color: Colors.white,
//                 ),
//                 Text(
//                   'Pedestrian Status',
//                   style: TextStyle(fontSize: 30),
//                 ),
//                 Icon(
//                   _status == 'walking'
//                       ? Icons.directions_walk
//                       : _status == 'stopped'
//                           ? Icons.accessibility_new
//                           : Icons.error,
//                   size: 100,
//                 ),
//                 Center(
//                   child: Text(
//                     _status,
//                     style: _status == 'walking' || _status == 'stopped'
//                         ? TextStyle(fontSize: 30)
//                         : TextStyle(fontSize: 20, color: Colors.red),
//                   ),
//                 )
//               ],
//             ),
//           );
//         }),
//   );
// }
