// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'dart:io';
// import 'dart:js_interop';
import 'package:camera/camera.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:energy_tracker/pages/register/date_of_birth.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

List<CameraDescription> cameras = [];

class AccountNo extends StatefulWidget {
  const AccountNo({super.key});
  // final User? user;

  @override
  State<AccountNo> createState() => _AccountNoState();
}

class _AccountNoState extends State<AccountNo> {
  bool _gotImage = false;
  bool _gotCorrectAccountNo = false;
  File? _image;
  late final TextEditingController _accountNumber;
  final _accountNumberForm = GlobalKey<FormState>();
  CameraController? _controller;
  String? path;

  final ImagePicker _imagePicker = ImagePicker();

  bool _isBusy = false;
  String _text = "";

  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  CustomPaint _customPaint = CustomPaint();

  int _num = 0;

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _accountNumber = TextEditingController();
    final File imageFile = File(path ?? "");

    _initializeVision();
  }

  void _initializeVision() async {
    try {
      if (cameras.isEmpty) {
        cameras = await availableCameras();
        print(cameras);
      }

      String pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
      RegExp regEx = RegExp(pattern);

      _controller = await CameraController(cameras[0], ResolutionPreset.medium);
      _controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e) {
      print("error in _initializeVision() -> $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    _textRecognizer.close();
    super.dispose();
  }

  Future getImageCamera() async {
    final image =
        await _imagePicker.pickImage(source: ImageSource.camera) ?? XFile("");
    setState(() {
      _image = File(image.path);
      // print();
      if (_image?.path == "") {
        _gotImage = false;
      } else {
        _gotImage = true;
      }
    });
  }

  Future getImageGallery() async {
    final image =
        await ImagePicker().pickImage(source: ImageSource.gallery) ?? XFile("");
    setState(() {
      _image = File(image.path);
      // print();
      if (_image?.path == "") {
        _gotImage = false;
      } else {
        _gotImage = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _dbUsers = db.collection("Users");

    

    

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
              height: double.infinity,
              width: double.infinity,
              color: Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),
              child: SingleChildScrollView(
                  child: Container(
                      height: size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 40),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "Electricity Account Number",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                              )),
                          Form(
                            key: _accountNumberForm,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: _gotImage && !_gotCorrectAccountNo
                                      ? Text(
                                          "Consider verifying your account number",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.red),
                                        )
                                      : Text(
                                          "Enter your electricity account number",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(fontSize: 14),
                                        ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: TextFormField(
                                    controller: _accountNumber,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        labelText: "Enter your Account Number",
                                        fillColor: const Color.fromARGB(
                                            255, 161, 101, 101),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email cannot be empty";
                                      } else if (value.length < 10) {
                                        return "Atleast 10 digits";
                                      } else {
                                        _gotCorrectAccountNo = true;
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontFamily: "Epilogue",
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "OR",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(fontSize: 14),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: clickImageAndProcess,
                                      child: Container(
                                          height: 70,
                                          // width: 250,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.camera_alt,
                                                size: 30,
                                                // fill: 0.2,
                                                color: Colors.black87,
                                              ),
                                              Text("Camera")
                                            ],
                                          )),
                                    ),
                                    InkWell(
                                      onTap: pickImageAndProcess,
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 15,
                                              bottom: 15),
                                          height: 70,
                                          width: 200,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: 150,
                                                child: Text(
                                                  "Pick an Image of electricity bill from gallery",
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                                _gotImage
                                    ? Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: InkWell(
                                              onTap: reProcess,
                                              child: Text(
                                                "Preview Image",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 300,
                                            child:
                                                Image.file(_image ?? File("")),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 85,
                            margin: EdgeInsets.only(
                                bottom: 78, left: 20, right: 20),
                            width: 300,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      return const Color.fromARGB(
                                          255, 46, 82, 46);
                                    }, //background color of button
                                  ),
                                  textStyle: MaterialStateProperty
                                      .resolveWith<TextStyle?>((states) =>
                                          TextStyle(fontFamily: 'Gotham')),
                                  elevation: MaterialStateProperty.resolveWith<
                                      double?>(
                                    (Set<MaterialState> states) {
                                      return 3;
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
                                        return const Color.fromARGB(
                                            255, 100, 157, 100);
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                onPressed: () async {
                                  _onSubmit(context);
                                },
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 236, 236, 236),
                                      fontSize: 20,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w800),
                                )),
                          )
                        ],
                      ))))
        ],
      ),
    );
  }

  Future<void> reProcess() async {
    if (_gotImage) {
      InputImage inputImage = InputImage.fromFile(_image ?? File(""));
      await _processImage(inputImage);
      print("the value of num $_num");
      _accountNumber.text = _num.toString();
      print("reprocessed");
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    print("outside try");
    try {
      // if (!_canProcess) return;
      print("value of $_isBusy");
      // if (_isBusy) return;
      print("inside try");
      // _isBusy = true;

      final first_stage_regex = RegExp(
          r'A[C|O|U|N|A|D|L]{3,}T [N|M|H][O|0|J| |D]{1,}:[0-9| |I|O|:]{8,}');
      int no_of_matches = 0;
      int iterations = 0;
      RecognizedText recognizedText;
      List<String> _list = [];

      recognizedText = await _textRecognizer.processImage(inputImage);

      List<TextBlock> temp = recognizedText.blocks;
      temp.forEach((element) {
        bool match = first_stage_regex.hasMatch(element.text);
        print(element.text);
        print(match);
        print("=============");

        if (match) {
          ++no_of_matches;
          _list.add(element.text);
        }
      });
      // ++iterations;
      // print("No of Matches: $no_of_matches");
      // }
      final secondStageRegex = RegExp(r'[0-9]{8,}');
      final fromI = RegExp(r'I');
      const replace1 = '1';
      final fromO = RegExp(r'O');
      final fromU = RegExp(r'U');
      final fromColon = RegExp(r':');
      const replace0 = '0';

      print("After Second Stage");
      List<String?> _list2 = [];

      for (var element in _list) {
        bool match = secondStageRegex.hasMatch(element);
        print(element);
        print(match);
        print("=============");

        if (match) {
          ++no_of_matches;

          _list2.add(secondStageRegex.stringMatch(element));
        } else {
          element = element.replaceAll(fromI, replace1);
          element = element.replaceAll(fromO, replace0);
          element = element.replaceAll(fromU, replace0);
          element = element.replaceAll(fromColon, replace1);
          print("replaced $element");
          print("Performed fixes");
          match = secondStageRegex.hasMatch(element);
          if (match) {
            ++no_of_matches;

            _list2.add(secondStageRegex.stringMatch(element));
          }
        }
      }

      try {
        _num = int.parse(_list2[0] ?? "0");
      } on RangeError catch (e) {
        print("Exception thrown");

        throw Exception("Recognition was unsuccessfull. Please try again.");
      }
      print("Total selected strings: $_list2");
    } catch (e) {
      _gotImage = false;
      print("error in _processImage() -> $e");
    }
  }

  Future<void> clickImageAndProcess() async {
    try {
      print("----------in clicked()------------------");
      await getImageCamera();
      print("----------after getImage()------------------");
      if (_gotImage) {
        // print("----------in clicked()------------------");

        InputImage _img = InputImage.fromFile(_image ?? File(""));
        await _processImage(_img);

        print("the value of num $_num");
        _accountNumber.text = _num.toString();
        if (_accountNumber.text.length >= 10) {
          _gotCorrectAccountNo = true;
        }

        // Future<String> _ocrText =
        //     await FlutterTesseractOcr.extractText(_image.path);
        // String _ocrText = await FlutterTesseractOcr.extractText(
        //   _image.path,
        //   language: "eng",
        // );
        // print("-----------------------");
        // print(_ocrText);
        print("----------in clicked2()------------------");
      } else {
        print("-----------------------");
        print("no image");
        print("-----------------------");
      }
      setState(() {
        _accountNumberForm.currentState!.validate();
      });
    } catch (e) {
      print("-------------------------------------");
      print("error in _clicked() -> $e");
      print("-------------------------------------");
    }
  }

  Future<void> pickImageAndProcess() async {
    try {
      print("----------in picked()------------------");
      await getImageGallery();
      print("----------after getImage()------------------");
      if (_gotImage) {
        // print("----------in clicked()------------------");

        InputImage _img = InputImage.fromFile(_image ?? File(""));
        await _processImage(_img);

        print("the value of num $_num");
        _accountNumber.text = _num.toString();
        if (_accountNumber.text.length >= 10) {
          _gotCorrectAccountNo = true;
        }

        // Future<String> _ocrText =
        //     await FlutterTesseractOcr.extractText(_image.path);
        // String _ocrText = await FlutterTesseractOcr.extractText(
        //   _image.path,
        //   language: "eng",
        // );
        // print("-----------------------");
        // print(_ocrText);
        print("----------in clicked2()------------------");
      } else {
        print("-----------------------");
        print("no image");
        print("-----------------------");
      }
      setState(() {
        _accountNumberForm.currentState!.validate();
      });
    } catch (e) {
      print("-------------------------------------");
      print("error in _clicked() -> $e");
      print("-------------------------------------");
    }

    // Checking whether the controller is initialized
  }

  Future<bool> _alreadyRegistered(String accountNo) async {
    var users = await FirebaseFirestore.instance.collection("Users").get();
    bool _isAlreadyRegistered = false;
    // print();
    for (var element in users.docs) {
      var data = element.data();

      // print(data["accountNo"] + ' == $accountNo');
      print((data["accountNo"]).runtimeType);
      if (data["accountNo"] == int.parse(accountNo)) {
        _isAlreadyRegistered = true;
        break;
      }
    }
    return _isAlreadyRegistered;
  }

  Future<void> _sendRequestToFamily(
      BuildContext context, String accountNo) async {
    // TODO : add function to send request to family
    var users = await FirebaseFirestore.instance.collection("Users");

    Map<String, dynamic> data = {
      "accountNo": int.parse(_accountNumber.text),
      "uid": FirebaseAuth.instance.currentUser?.uid,
      "name": FirebaseAuth.instance.currentUser?.displayName,
      "email": FirebaseAuth.instance.currentUser?.email,
      "challenges": [],
      "individualRank": 0,
      "individualScore": 0,
      "stepsCount": []
    };
    final _dbUsers = db.collection("Users");
    _dbUsers.doc(data["email"]).set(data);
  }

  void _showDialogForRequest(BuildContext context, String accountNo) {
    final navigatorKey = GlobalKey<NavigatorState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account already registered"),
          content: Text("Do you want to send request to cheif of family?"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop();
                await _sendRequestToFamily(context, accountNo);
                showDialog(
                  context: navigatorKey.currentContext ?? context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Account Registered"),
                      content: Text(
                          "Your Accound has been registered successfully. Moving to Next Step"),
                    );
                  },
                );

                Future.delayed(Duration(seconds: 3), () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DateOfBirth(),
                    ),
                  );
                });
              },
            ),
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_accountNumberForm.currentState!.validate()) {
      print("account number is valid");

      if (await _alreadyRegistered(_accountNumber.text)) {
        print("Your Account is already registered. Send Request to Family ");
        _showDialogForRequest(context, _accountNumber.text);
        // await _sendRequestToFamily(_accountNumber.text);
        // SnackBar(
        //   showCloseIcon: true,
        //   // backgroundColor: Colors.,
        //   content: Text("Account Number already registered."),
        // );
      } else {
        Map<String, dynamic> data = {
          "accountNo": int.parse(_accountNumber.text),
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "name": FirebaseAuth.instance.currentUser?.displayName,
          "email": FirebaseAuth.instance.currentUser?.email,
          "challenges": [],
          "individualRank": 0,
          "individualScore": 0,
          "stepsCount": []
        };
        final _dbUsers = db.collection("Users");
        _dbUsers.doc(data["email"]).set(data);

        Map<String, dynamic> data2 = {
          "accountNo": int.parse(_accountNumber.text),
          "historicalData": [],
          "familyRank": 0,
          "address": {
            "locality": "",
            "city": "",
            "state": "",
            "country": "",
            "postalCode": "",
          },
          "comminityChallenges": [],
          "familyName": data["name"] + '-' + data["accountNo"].toString(),
          "members": [
            {
              "uid": data["uid"],
              "isChief": true,
            }
          ]
        };

        print("data2 is being sent");
        final _dbFamily = db.collection("family");
        _dbFamily
            .doc(data["name"] + ' - ' + data["accountNo"].toString())
            .set(data2);
        print("data2 is sent");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Account Registered"),
              content: Text(
                  "Your Accound has been registered successfully. Moving to Next Step"),
            );
          },
        );

        Future.delayed(Duration(seconds: 3), () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => DateOfBirth(),
            ),
          );
        });
        // SnackBar(
        //   showCloseIcon: true,
        //   // backgroundColor: Colors.,
        //   content: Text("Account Number registered."),
        // );
      }
    } else {
      print("account number is not valid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.redAccent,
            content: Text("Verify your Account Number")),
      );
    }
  }
}
