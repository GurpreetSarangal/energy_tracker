import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:choice/choice.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => _editProfileState();
}

String _oldAccountNo = "";

class _editProfileState extends State<editProfile> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _accountNo;
  late final TextEditingController _dob;
  late final TextEditingController _gender;
  late final TextEditingController _city;
  late final TextEditingController _country;
  late final TextEditingController _state;
  late final TextEditingController _pincode;
  late final TextEditingController _deviceId;
  bool _gotCorrectDate = true;
  bool _isCorrectLength = true;
  final _editForm = GlobalKey<FormState>();
  String _genderString = '';
  List<String> choices = [
    'Male',
    'Female',
    'Others',
    'Rather Not Say',
  ];
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _accountNo = TextEditingController();
    _dob = TextEditingController();
    _gender = TextEditingController();
    _city = TextEditingController();
    _country = TextEditingController();
    _state = TextEditingController();
    _pincode = TextEditingController();
    _deviceId = TextEditingController();
    super.initState();

    init_data();
  }

  Future<void> init_data() async {
    var userData = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    _accountNo.text = userData.data()!["accountNo"];
    _gender.text = userData.data()!["gender"];
    _dob.text = userData.data()!["dob"];
  }

  void setSelectedValue(List<String> value) {
    setState(() {
      // _accountNo = _accountNo;
      _genderString = value[0];
      _gender.text = _genderString;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _accountNo.dispose();
    _dob.dispose();
    _gender.dispose();
    _city.dispose();
    _country.dispose();
    _state.dispose();
    _pincode.dispose();
    _deviceId.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("inside build $_oldAccountNo");

    return Scaffold(
      key: globalKey,
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
        actions: [
          // IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
          // IconButton(
          //     onPressed: () async {}, icon: Icon(CupertinoIcons.gear_alt))
        ],
        title: Text(
          "Edit Profile",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: generateUI(),
    );
  }

  Future<dynamic> user = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .get();

  Widget generateUI() {
    return FutureBuilder(
        future: user,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          _name.text = snapshot.data!["name"];
          _email.text = snapshot.data!["email"];
          _accountNo.text = snapshot.data!["accountNo"].toString();
          String accNo = snapshot.data!["accountNo"].toString();
          _dob.text = snapshot.data!["dob"];
          // _gender.text = snapshot.data!["gender"];
          var accountNoWidget;

          // if (_oldAccountNo.compareTo("") == 0) {
          //   _oldAccountNo = _accountNo.text;
          //   print("inside generateUI if condition $_oldAccountNo");
          // } else {
          //   _accountNo.text = _oldAccountNo;
          //   print("inside generateUI else condition $_oldAccountNo");
          // }
          bool isRejected = false;

          print("------12222222---------22222222222---------2");
          // print(_name.text);
          // print(_email.text);
          // print(_accountNo.text);
          // print(accNo);
          // print(_dob.text);
          // print(_gender.text);
          // print(isRejected);
          print(snapshot.data!.data());

          if (accNo.compareTo("-1") == 0) {
            isRejected = true;
            accountNoWidget = Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.5),
              ),
              child: TextFormField(
                // onEditingComplete: () {
                //   if (int.parse(_accountNo.text) != -1) {
                //     SnackBar snackBar = SnackBar(
                //       content: const Text(
                //           '',
                //           style: TextStyle(fontSize: 20)),
                //       backgroundColor: Colors.black38,
                //       dismissDirection: DismissDirection.up,
                //       behavior: SnackBarBehavior.floating,
                //       margin: EdgeInsets.only(
                //           bottom: MediaQuery.of(context).size.height - 150,
                //           left: 10,
                //           right: 10),
                //     );

                //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //   }
                // },
                onChanged: (val) {
                  print(val);
                  print(val.length);
                  if (val.length < 10) {
                    _isCorrectLength = false;
                  } else {
                    _isCorrectLength = true;
                  }
                },
                controller: _accountNo,
                obscureText: false,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Account No",
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Account Number cannot be empty";
                  } else if (!_isCorrectLength) {
                    return "minimum 10 digits";
                  } else {
                    return RegExp(r"^[0-9]+$").hasMatch(value)
                        ? null
                        : "Only numbers without any sign";
                    // return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontFamily: "Epilogue",
                ),
              ),
            );
          } else {
            accountNoWidget = Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.5),
              ),
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  if (int.parse(_accountNo.text) != -1) {
                    SnackBar snackBar = SnackBar(
                      content: const Text('Cannot be changed',
                          style: TextStyle(fontSize: 20)),
                      backgroundColor: Colors.red.shade300,
                      dismissDirection: DismissDirection.up,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 150,
                          left: 10,
                          right: 10),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                onChanged: (val) {
                  if (val.length <= 10) {
                    _isCorrectLength = true;
                  } else {
                    _isCorrectLength = false;
                  }
                },
                controller: _accountNo,
                obscureText: false,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Account No",
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Account Number cannot be empty";
                  } else if (_isCorrectLength) {
                    return "minimum 10 digits";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontFamily: "Epilogue",
                ),
              ),
            );
          }

          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("family")
                  .where("accountNo", isEqualTo: int.parse(accNo))
                  .get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _editForm,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/profile3_copy.png"))),
                            height: 100,
                            width: 100,
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
                              controller: _name,
                              obscureText: false,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: "Full Name",
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
                                  return "Name cannot be empty";
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: TextFormField(
                              onTap: () {
                                SnackBar snackBar = SnackBar(
                                  content: const Text(
                                      'Cannot change your email!!',
                                      style: TextStyle(fontSize: 20)),
                                  backgroundColor: Colors.black38,
                                  dismissDirection: DismissDirection.up,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height -
                                              150,
                                      left: 10,
                                      right: 10),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              controller: _email,
                              readOnly: true,
                              obscureText: false,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "email cannot be empty";
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
                          accountNoWidget,
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: TextFormField(
                              readOnly: true,
                              onTap: () async => await _selectDate(context),
                              controller: _dob,
                              obscureText: false,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: "Date Of Birth",
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "email cannot be empty";
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Choice<String>.prompt(
                              title: 'Gender',
                              value: [_genderString],
                              onChanged: setSelectedValue,
                              itemCount: choices.length,
                              itemBuilder: (state, i) {
                                return RadioListTile(
                                  value: choices[i],
                                  groupValue: state.single,
                                  onChanged: (value) {
                                    state.select(choices[i]);
                                  },
                                  title: ChoiceText(
                                    choices[i],
                                    highlight: state.search?.value,
                                  ),
                                );
                              },
                              promptDelegate: ChoicePrompt.delegatePopupDialog(
                                maxHeightFactor: .5,
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                              ),
                              anchorBuilder: ChoiceAnchor.create(inline: true),
                            ),

                            // child: DropdownButton(
                            //   value: (_gender.text).toString(),
                            //   isExpanded: false,
                            //   isDense: true,
                            //   iconSize: 30,
                            //   elevation: 0,
                            //   alignment: AlignmentDirectional.bottomCenter,
                            //   dropdownColor: Colors.black54,
                            //   enableFeedback: true,

                            //   // underline:,
                            //   icon: Icon(Icons.arrow_drop_down_rounded),
                            //   onChanged: (val) {
                            //     print("Gender String $_genderString");
                            //     // setState(() {
                            //     _genderString = val ?? "";
                            //     _gender.text = _genderString;
                            //     // });
                            //   },
                            //   // borderRadius: BorderRadius.circular(12),
                            //   // value: _genderString,
                            //   items: <String>[
                            //     'Male',
                            //     'Female',
                            //     'Others',
                            //     'Rather Not Say'
                            //   ].map((String value) {
                            //     return DropdownMenuItem<String>(
                            //       value: value,
                            //       child: Text(
                            //         value,
                            //         style: TextStyle(color: Colors.white),
                            //       ),
                            //     );
                            //   }).toList(),
                            //   hint: (_genderString.compareTo("") == 0)
                            //       ? Text('Gender')
                            //       : Text(
                            //           _gender.text ?? "Gender",
                            //           // style: TextStyle(color: Colors.blue),
                            //           style: const TextStyle(
                            //             fontFamily: "Epilogue",
                            //           ),
                            //         ),
                            // ),
                            // Container(
                            //   margin: const EdgeInsets.only(
                            //       left: 20, right: 20, top: 15),
                            //   padding: EdgeInsets.only(left: 10, right: 10),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(12),
                            //     color: Colors.white.withOpacity(0.5),
                            //   ),
                            //   child: DropdownButton(
                            //     value: (_gender.text).toString(),
                            //     isExpanded: false,
                            //     isDense: true,
                            //     iconSize: 30,
                            //     elevation: 0,
                            //     alignment: AlignmentDirectional.bottomCenter,
                            //     dropdownColor: Colors.black54,
                            //     enableFeedback: true,

                            //     // underline:,
                            //     icon: Icon(Icons.arrow_drop_down_rounded),
                            //     onChanged: (val) {
                            //       print("Gender String $_genderString");
                            //       // setState(() {
                            //       _genderString = val ?? "";
                            //       _gender.text = _genderString;
                            //       // });
                            //     },
                            //     // borderRadius: BorderRadius.circular(12),
                            //     // value: _genderString,
                            //     items: <String>[
                            //       'Male',
                            //       'Female',
                            //       'Others',
                            //       'Rather Not Say'
                            //     ].map((String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Text(
                            //           value,
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //       );
                            //     }).toList(),
                            //     hint: (_genderString.compareTo("") == 0)
                            //         ? Text('Gender')
                            //         : Text(
                            //             _gender.text ?? "Gender",
                            //             // style: TextStyle(color: Colors.blue),
                            //             style: const TextStyle(
                            //               fontFamily: "Epilogue",
                            //             ),
                            //           ),
                            //   ),
                            // TextFormField(
                            //   controller: _genderString,
                            //   obscureText: false,
                            //   enableSuggestions: false,
                            //   autocorrect: false,
                            //   decoration: const InputDecoration(
                            //     labelText: "Gender",
                            //     fillColor: Colors.white,
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return "email cannot be empty";
                            //     }
                            //      else {
                            //       return null;
                            //     }
                            //   },
                            //   keyboardType: TextInputType.emailAddress,
                            //   style: const TextStyle(
                            //     fontFamily: "Epilogue",
                            //   ),
                            // ),
                          ),
                          (!isRejected)
                              ? FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection("family")
                                      .where("accountNo",
                                          isEqualTo: int.parse(accNo))
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 30, left: 30, right: 30),
                                            height: 50,
                                            child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 30, left: 30, right: 30),
                                            height: 50,
                                            child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 30, left: 30, right: 30),
                                            height: 50,
                                            child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 30, left: 30, right: 30),
                                            height: 50,
                                            child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                          ),
                                        ],
                                      );
                                    }
                                    _city.text = snapshot
                                        .data!.docs.first["address"]["city"];
                                    _state.text = snapshot
                                        .data!.docs.first["address"]["state"];
                                    _country.text = snapshot
                                        .data!.docs.first["address"]["country"];
                                    _pincode.text = snapshot
                                        .data!.docs.first["address"]["pincode"];

                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, top: 15),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: TextFormField(
                                            controller: _city,
                                            obscureText: false,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            decoration: const InputDecoration(
                                              labelText: "City",
                                              fillColor: Colors.white,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "email cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                              fontFamily: "Epilogue",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, top: 15),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: TextFormField(
                                            controller: _state,
                                            obscureText: false,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            decoration: const InputDecoration(
                                              labelText: "State",
                                              fillColor: Colors.white,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "email cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                              fontFamily: "Epilogue",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, top: 15),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: TextFormField(
                                            controller: _country,
                                            obscureText: false,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            decoration: const InputDecoration(
                                              labelText: "Country",
                                              fillColor: Colors.white,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "email cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                              fontFamily: "Epilogue",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, top: 15),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: TextFormField(
                                            controller: _pincode,
                                            obscureText: false,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            decoration: const InputDecoration(
                                              labelText: "Pincode",
                                              fillColor: Colors.white,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "email cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                              fontFamily: "Epilogue",
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 15),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _city,
                                        obscureText: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          labelText: "City",
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "email cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                          fontFamily: "Epilogue",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 15),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _state,
                                        obscureText: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          labelText: "State",
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "email cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                          fontFamily: "Epilogue",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 15),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _country,
                                        obscureText: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          labelText: "Country",
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "email cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                          fontFamily: "Epilogue",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 15),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: TextFormField(
                                        controller: _pincode,
                                        obscureText: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          labelText: "Pincode",
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "email cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                          fontFamily: "Epilogue",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: 60,
                                    width: 175,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            //<-- SEE HERE
                                            return Colors.red
                                                .shade100; // Defer to the widget's default.
                                          }, //background color of button
                                        ),
                                        textStyle: MaterialStateProperty
                                            .resolveWith<TextStyle?>((states) =>
                                                TextStyle(
                                                    fontFamily:
                                                        'Gotham')), //border width and color
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
                                                  .pink.shade200; //<-- SEE HERE
                                            }
                                            return null; // Defer to the widget's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Cancel ",
                                            style: TextStyle(
                                                color: Colors.pink.shade500,
                                                fontSize: 20,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Icon(
                                            CupertinoIcons.xmark,
                                            color: Colors.pink.shade500,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: 60,
                                    width: 170,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            //<-- SEE HERE
                                            return Colors.lightGreen
                                                .shade100; // Defer to the widget's default.
                                          }, //background color of button
                                        ),
                                        textStyle: MaterialStateProperty
                                            .resolveWith<TextStyle?>((states) =>
                                                TextStyle(
                                                    fontFamily:
                                                        'Gotham')), //border width and color
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
                                              return const Color.fromARGB(255,
                                                  100, 157, 100); //<-- SEE HERE
                                            }
                                            return null; // Defer to the widget's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () async {
                                        // TODO: Add this challenge to user's challenges list

                                        // await addChallenge(challengeId);
                                        // setState(() {});
                                        if (_editForm.currentState!.validate())
                                          ;
                                        {
                                          var data = {
                                            "name": _name.text,
                                            "email": _email.text,
                                            "accountNo": _accountNo.text,
                                            "dob": _dob.text,
                                            "gender": _gender.text,
                                            "city": _city.text,
                                            "state": _state.text,
                                            "country": _country.text,
                                            "pincode": _pincode.text,
                                          };

                                          await saveChanges(data, context);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Save ",
                                            style: TextStyle(
                                                color: Colors.green.shade800,
                                                fontSize: 20,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Icon(
                                            CupertinoIcons.checkmark_alt,
                                            color: Colors.green.shade800,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                        ]),
                      ),
                    )
                  ],
                );
              }));
        }));
  }

  saveChanges(var data, var tempContext) async {
    print(data);

    var indivdualInfo = {
      "name": data["name"],
      "dob": data["dob"],
      "gender": data["gender"],
    };

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(indivdualInfo, SetOptions(merge: true));

    var families = await FirebaseFirestore.instance
        .collection("family")
        .where("accountNo", isEqualTo: int.parse(data["accountNo"]))
        .get();

    if (families.docs.length > 0) {
      print("Already Registered");
      var famData = families.docs.first.data();
      var context = globalKey.currentContext;
      showDialog(
        context: context ?? tempContext,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text("Account already registered"),
            content: Text("Do you want to send request to cheifs of family?"),
            actions: [
              TextButton(
                  child: Text("OK"),
                  onPressed: () async {
                    Navigator.of(context2).pop();

                    famData["request"].add({
                      "fromEmail": FirebaseAuth.instance.currentUser!.email,
                      "dateRequested": DateTime.now()
                    });

                    print(famData);

                    await FirebaseFirestore.instance
                        .collection("family")
                        .doc(famData["familyName"])
                        .set(famData, SetOptions(merge: true));

                    var userUpdates = {
                      "accountNo": int.parse(data["accountNo"]),
                      "isRequested": true,
                    };

                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .set(userUpdates, SetOptions(merge: true));

                    showDialog(
                      context: context ?? tempContext,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text("Account Registered"),
                          content: Text(
                              "Your Accound has been registered successfully. Moving to Next Step"),
                        );
                      },
                    );
                    // Navigator.of(context).pop();

                    // Future.delayed(const Duration(seconds: 3), () {
                    //   Navigator.push(
                    //     context ?? tempContext,
                    //     CupertinoPageRoute(
                    //       builder: (context) => const DateOfBirth(),
                    //     ),
                    //   );
                    // });
                  }),
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context ?? tempContext).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print("none family");
    }
  }

  _selectDate(BuildContext context) async {
    // showModalBottomSheet(
    DateTime today = DateTime.now();
    String dob = _dob.text;
    int year = int.parse(dob.split("-")[0]);
    int mon = int.parse(dob.split("-")[1]);
    int day = int.parse(dob.split("-")[2]);
    var initDate = DateTime(year, mon, day);

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(today.year - 150),
      lastDate: DateTime(2025),
      // initialEntryMode: DatePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // This will change to light theme.
          child: child ?? Text("temp"),
        );
      },
    );

    if (date != null && (date.compareTo(today) < 0)) {
      // setState(() {
      _dob.text = date.toLocal().toString().split(' ')[0];
      _gotCorrectDate = true;
      _editForm.currentState?.validate();
      // });
    } else {
      // setState(() {
      _dob.text = date?.toLocal().toString().split(' ')[0] ?? _dob.text;
      _gotCorrectDate = false;
      _editForm.currentState?.validate();
      // });
    }
  }
}
