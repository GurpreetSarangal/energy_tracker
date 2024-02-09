import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/navigation_bar.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class addressPage extends StatefulWidget {
  const addressPage({super.key});

  @override
  State<addressPage> createState() => _addressPageState();
}

class _addressPageState extends State<addressPage> {
  final _addressForm = GlobalKey<FormState>();
  late final TextEditingController _pincode;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _country;

  @override
  void initState() {
    _pincode = TextEditingController();
    _city = TextEditingController();
    _state = TextEditingController();
    _country = TextEditingController();
    _country.text = "India";
    super.initState();
  }

  @override
  void dispose() {
    _pincode.dispose();
    _city.dispose();
    _state.dispose();
    _country.dispose();
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
          // alignment: const Alignment(0, 1),
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
                              "Address",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                            )),
                        Form(
                            key: _addressForm,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Text(
                                      "Enter your Address",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 15,
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    child: TextFormField(
                                      controller: _pincode,
                                      enableSuggestions: true,
                                      autocorrect: true,
                                      decoration: InputDecoration(
                                          labelText: "Pincode",
                                          fillColor: const Color.fromARGB(
                                              255, 161, 101, 101),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Pincode cannot be empty";
                                        } else {
                                          // _gotCorrectAccountNo = true;
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
                                      left: 20,
                                      right: 20,
                                      top: 15,
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    child: TextFormField(
                                      controller: _city,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          labelText: "City",
                                          fillColor: const Color.fromARGB(
                                              255, 161, 101, 101),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Cannot be empty";
                                        } else {
                                          // _gotCorrectAccountNo = true;
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.streetAddress,
                                      style: const TextStyle(
                                        fontFamily: "Epilogue",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 15,
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    child: TextFormField(
                                      controller: _state,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          labelText: "State",
                                          fillColor: const Color.fromARGB(
                                              255, 161, 101, 101),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Cannot be empty";
                                        } else {
                                          // _gotCorrectAccountNo = true;
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.streetAddress,
                                      style: const TextStyle(
                                        fontFamily: "Epilogue",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 15,
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    child: TextFormField(
                                      controller: _country,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          labelText: "Country",
                                          fillColor: const Color.fromARGB(
                                              255, 161, 101, 101),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Cannot be empty";
                                        } else {
                                          // _gotCorrectAccountNo = true;
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.streetAddress,
                                      style: const TextStyle(
                                        fontFamily: "Epilogue",
                                      ),
                                    ),
                                  ),
                                ])),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 85,
                          margin:
                              EdgeInsets.only(bottom: 78, left: 20, right: 20),
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
                                elevation:
                                    MaterialStateProperty.resolveWith<double?>(
                                  (Set<MaterialState> states) {
                                    return 3;
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
                                if (_addressForm.currentState?.validate() ??
                                    false) {
                                  var data = {
                                    "address": {
                                      "pincode":
                                          _pincode.text.toLowerCase().trim(),
                                      "city": _city.text.toLowerCase().trim(),
                                      "state": _state.text.toLowerCase().trim(),
                                      "country":
                                          _country.text.toLowerCase().trim()
                                    }
                                  };

                                  dynamic u = await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.email)
                                      .get();

                                  u = u.data();
                                  print(u["accountNo"]);
                                  print((u["accountNo"]).runtimeType);

                                  Map<String, dynamic>? documentData;

                                  await FirebaseFirestore.instance
                                      .collection('family')
                                      .where("accountNo",
                                          isEqualTo: u["accountNo"])
                                      .get()
                                      .then((event) {
                                    if (!event.docs.isEmpty) {
                                      documentData = event.docs.first
                                          .data(); //if it is a single document
                                      print(documentData);
                                    }
                                  }).catchError((e) =>
                                          print("error fetching data: $e"));

                                  print(documentData);

                                  await FirebaseFirestore.instance
                                      .collection("family")
                                      .doc(documentData?['familyName'])
                                      .set(data, SetOptions(merge: true));

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Registered Completed"),
                                        content: Text(
                                            "Now let's proceed to dashboard"),
                                      );
                                    },
                                  );

                                  Future.delayed(Duration(seconds: 3),
                                      () async {
                                    await Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => NavigationMenu(),
                                      ),
                                    );
                                  });
                                }
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
                      ]))))
    ]));
  }
}
