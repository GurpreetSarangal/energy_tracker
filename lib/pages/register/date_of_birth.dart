import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/cloudsearch/v1.dart';
import 'package:googleapis/people/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({super.key});

  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  bool _gotCorrectDate = false;
  final _DateOfBirthForm = GlobalKey<FormState>();
  late final TextEditingController _DOB;
  // late final TextEditingController _gender;
  String? _gender;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final googleSignin = GoogleSignIn(scopes: <String>[
    PeopleServiceApi.userBirthdayReadScope,
    PeopleServiceApi.userGenderReadScope,
  ]);
  DateTime today = DateTime.now();

  @override
  void initState() {
    _DOB = TextEditingController();
    // _gender = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _DOB.dispose();
    // _gender.dispose();
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
                              "Date of Birth and Gender",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                            )),
                        Form(
                            key: _DateOfBirthForm,
                            child: Column(
                              children: [
                                Text(
                                  "Enter your electricity account number",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(fontSize: 14),
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
                                    readOnly: true,
                                    onTap: () async =>
                                        await _selectDate(context),
                                    controller: _DOB,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_month),
                                        labelText: "Select Your Date of Birth",
                                        fillColor: const Color.fromARGB(
                                            255, 161, 101, 101),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please provide your date of birth";
                                      } else if (!_gotCorrectDate) {
                                        return "Enter Valid Date";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.datetime,
                                    style: const TextStyle(
                                      fontFamily: "Epilogue",
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    iconSize: 30,
                                    elevation: 0,
                                    alignment: AlignmentDirectional.center,
                                    // underline:,
                                    icon: Icon(Icons.arrow_drop_down_rounded),
                                    onChanged: (val) {
                                      setState(() {
                                        _gender = val;
                                      });
                                    },
                                    // borderRadius: BorderRadius.circular(12),
                                    // value: _gender,
                                    items: <String>[
                                      'Male',
                                      'Female',
                                      'Others',
                                      'Rather Not Say'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    hint: _gender == ""
                                        ? Text('Gender')
                                        : Text(
                                            _gender ?? "Gender",
                                            // style: TextStyle(color: Colors.blue),
                                            style: const TextStyle(
                                              fontFamily: "Epilogue",
                                            ),
                                          ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  height: 40,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("If registered using    ",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(fontSize: 14)),
                                      Icon(
                                        MyFlutterApp.google,
                                        size: 16,
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Click here",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 46, 82, 46),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        onPressed: () async {
                                          await loginWithGoogle();
                                          _fetchGenderAndBirthday();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
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
                                // print(_DOB);
                                // print(_gender);
                                if (!(_DateOfBirthForm.currentState
                                            ?.validate() ??
                                        false) ||
                                    (_gender == null)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        showCloseIcon: true,
                                        backgroundColor: Colors.redAccent,
                                        content:
                                            Text("Verify your DOB and Gender")),
                                  );
                                } else {
                                  final data = {
                                    "dob": _DOB.text,
                                    "gender": _gender,
                                  };

                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.email)
                                      .set(data, SetOptions(merge: true));
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Saved"),
                                        content: Text(
                                            "Your date of birth and gender preference are saved. Let's move to one last step."),
                                      );
                                    },
                                  );

                                  // Future.delayed(Duration(seconds: 3), () {
                                  //   Navigator.push(
                                  //     context,
                                  //     CupertinoPageRoute(
                                  //       builder: (context) => DateOfBirth(),
                                  //     ),
                                  //   );
                                  // });
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

  loginWithGoogle() async {
    await googleSignin.signIn();
  }

  _fetchGenderAndBirthday() async {
    var httpClient = (await googleSignin.authenticatedClient())!;

    var peopleApi = PeopleServiceApi(httpClient);

    final Person person = await peopleApi.people.get(
      'people/me',
      personFields:
          'birthdays,genders', // add more fields with comma separated and no space
    );

    /// Gender
    final String gender = person.genders![0].formattedValue!;

    /// Birthdate
    final date = person.birthdays![0].date!;
    final DateTime birthdayDateTime = DateTime(
      date.year ?? 0,
      date.month ?? 0,
      date.day ?? 0,
    );

    print(gender);
    print(birthdayDateTime);

    setState(() {
      _gotCorrectDate = true;
      _DOB.text = birthdayDateTime.toLocal().toString().split(' ')[0];
      _gender = gender;
    });
  }

  _selectDate(BuildContext context) async {
    // showModalBottomSheet(

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: today,
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
      setState(() {
        _DOB.text = date?.toLocal().toString().split(' ')[0] ?? _DOB.text;
        _gotCorrectDate = true;
        _DateOfBirthForm.currentState?.validate();
      });
    } else {
      setState(() {
        _DOB.text = date?.toLocal().toString().split(' ')[0] ?? _DOB.text;
        _gotCorrectDate = false;
        _DateOfBirthForm.currentState?.validate();
      });
    }
    // context: context,
    // builder: (BuildContext builder) {
    //   return Container(
    //     height: MediaQuery.of(context).copyWith().size.height / 3,
    //     color: const Color.fromARGB(255, 0, 0, 0),
    //     child: CupertinoDatePicker(
    //         mode: CupertinoDatePickerMode.date,
    //         onDateTimeChanged: (picked) {
    //           if (picked != null &&
    //               (picked.day < today.day ||
    //                   picked.month <= today.month ||
    //                   picked.year <= today.year)) {
    //             print(picked);
    //             print(today);
    //             setState(() {
    //               _DOB.text = picked.toLocal().toString().split(' ')[0];
    //             });
    //           }
    //         },
    //         initialDateTime: today,
    //         minimumYear: 1950,
    //         maximumYear: today.year),
    //   );
    // });
  }
}
