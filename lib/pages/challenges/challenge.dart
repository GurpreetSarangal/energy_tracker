import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

String challengeId = "";

class ChallengeDetails extends StatefulWidget {
  const ChallengeDetails({super.key});

  // final String challengeId;

  @override
  State<ChallengeDetails> createState() => _ChallengeDetailsState();
}

class _ChallengeDetailsState extends State<ChallengeDetails> {
  Future<void> removeChallenge(String challengeId) async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      return value;
    });
    var chalengesList = user.data()!["challenges"];

    var newList = [];

    for (var chlng in chalengesList) {
      if (chlng["challengeId"] == challengeId) {
        continue;
      }

      newList.add(chlng);
    }

    // print(newList);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(
      {"challenges": newList},
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    challengeId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("challenges")
            .doc(challengeId)
            .get(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

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
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                toolbarHeight: 80,
                // actions: [
                //   IconButton(
                //       onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
                //   IconButton(
                //       onPressed: () async {},
                //       icon: Icon(CupertinoIcons.gear_alt))
                // ],
                title: Text(
                  "Challenge Details",
                  style: TextStyle(
                      fontFamily: "Epilogue", fontWeight: FontWeight.w600),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          height: 200,
                          child: FutureBuilder(
                            future: FirebaseStorage.instance
                                .ref()
                                .child('challenges')
                                .child('${challengeId}.jpg')
                                .getDownloadURL(),
                            builder: ((context, snapshotImgURL) {
                              print(snapshotImgURL.data);
                              if (snapshotImgURL.hasData) {
                                return Container(
                                  // height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(snapshotImgURL.data!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.black54,
                                        backgroundBlendMode: BlendMode.darken),
                                    child: Center(
                                        child: Text(
                                      snapshot.data!["heading"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: "Gotham",
                                        fontWeight: FontWeight.bold,
                                        // decorationStyle: TextDecorationStyle.wavy,
                                        // decoration: TextDecoration.underline,
                                        // decorationColor: Colors.white,
                                      ),
                                    )),
                                  ),
                                );
                              }

                              return Center(child: CircularProgressIndicator());
                            }),
                          )),
                      // Expanded(flex: 1, child: Container())
                      Container(
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            height: 40,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 25, fontFamily: "Gotham"),
                                  ),
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                            ),
                            child: Text(
                              (snapshot.data!["description"]
                                      .toString()
                                      .capitalizeFirst ??
                                  "No Description"),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .get(),
                              builder: ((context, snapshotUser) {
                                if (!snapshotUser.hasData) {
                                  return Container(
                                    height: 170,
                                    child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive()),
                                  );
                                }

                                bool isAlreadyAccepted = false;
                                for (var chall
                                    in snapshotUser.data!["challenges"]) {
                                  if (chall["challengeId"] ==
                                      snapshot.data!["challengeId"]) {
                                    isAlreadyAccepted = true;
                                    break;
                                  }
                                }

                                if (isAlreadyAccepted) {
                                  return Container(
                                    margin:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8,
                                            ),
                                            height: 60,
                                            width: 177,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    //<-- SEE HERE
                                                    return Colors.blueGrey
                                                        .shade100; // Defer to the widget's default.
                                                  }, //background color of button
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .resolveWith<TextStyle?>(
                                                        (states) => TextStyle(
                                                            fontFamily:
                                                                'Gotham')), //border width and color
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
                                                      return const Color
                                                          .fromARGB(
                                                          255,
                                                          100,
                                                          157,
                                                          100); //<-- SEE HERE
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: null,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Accepted ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blueGrey.shade300,
                                                        fontSize: 18,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Icon(
                                                    CupertinoIcons
                                                        .checkmark_alt,
                                                    color: Colors
                                                        .blueGrey.shade300,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8,
                                            ),
                                            width: 175,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    //<-- SEE HERE
                                                    return Colors.red
                                                        .shade100; // Defer to the widget's default.
                                                  }, //background color of button
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .resolveWith<TextStyle?>(
                                                        (states) => TextStyle(
                                                            fontFamily:
                                                                'Gotham')), //border width and color
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
                                                      return Colors.pink
                                                          .shade200; //<-- SEE HERE
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: () async {
                                                await removeChallenge(
                                                    challengeId);
                                                Navigator.of(context).pop();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Remove ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .pink.shade500,
                                                        fontSize: 18,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Icon(
                                                    CupertinoIcons.xmark,
                                                    color: Colors.pink.shade500,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                } else {
                                  return Container(
                                    margin:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            height: 60,
                                            width: 170,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    //<-- SEE HERE
                                                    return Colors.lightGreen
                                                        .shade100; // Defer to the widget's default.
                                                  }, //background color of button
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .resolveWith<TextStyle?>(
                                                        (states) => TextStyle(
                                                            fontFamily:
                                                                'Gotham')), //border width and color
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
                                                      return const Color
                                                          .fromARGB(
                                                          255,
                                                          100,
                                                          157,
                                                          100); //<-- SEE HERE
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: () async {
                                                // TODO: Add this challenge to user's challenges list

                                                await addChallenge(challengeId);
                                                setState(() {});
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Accept ",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green.shade800,
                                                        fontSize: 20,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Icon(
                                                    CupertinoIcons
                                                        .checkmark_alt,
                                                    color:
                                                        Colors.green.shade800,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            height: 60,
                                            width: 175,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    //<-- SEE HERE
                                                    return Colors.red
                                                        .shade100; // Defer to the widget's default.
                                                  }, //background color of button
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .resolveWith<TextStyle?>(
                                                        (states) => TextStyle(
                                                            fontFamily:
                                                                'Gotham')), //border width and color
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
                                                      return Colors.pink
                                                          .shade200; //<-- SEE HERE
                                                    }
                                                    return null; // Defer to the widget's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Decline ",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .pink.shade500,
                                                        fontSize: 20,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Icon(
                                                    CupertinoIcons.xmark,
                                                    color: Colors.pink.shade500,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                }
                              })),
                        ]),
                      )
                    ],
                  )),
                ],
              ));
        }));
  }

  Future<void> addChallenge(String challengeId) async {
    Map<String, dynamic> newChallenge = {
      "challengeId": challengeId,
    };

    var challengeDetails = await FirebaseFirestore.instance
        .collection("challenges")
        .doc(challengeId)
        .get()
        .then((value) => value.data());

    newChallenge["heading"] = challengeDetails!["heading"];
    newChallenge["score"] = 0;

    var allChallenges = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) => value["challenges"]);

    allChallenges.add(newChallenge);
    // print(allChallenges);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({"challenges": allChallenges}, SetOptions(merge: true));
  }
}
