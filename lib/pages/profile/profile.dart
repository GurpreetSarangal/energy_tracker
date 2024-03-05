// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/pages/challenges/all_challenges.dart';
import 'package:energy_tracker/pages/profile/detailed_report.dart';
import 'package:energy_tracker/pages/profile/edit_profile.dart';
import 'package:energy_tracker/pages/profile/new_blog.dart';
import 'package:energy_tracker/pages/profile/steps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:energy_tracker/main.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

// import 'package:googleapis/compute/v1.dart';
int MinCntStPrFromD2D = 700;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

Future<String> _setTempOnFirebase() async {
  // await Firebase.initializeApp();
  // // fire.
  // await FirebaseFirestore.instance
  //     .collection("Users")
  //     .doc("gurpreetsarangal7@gmail.com")
  //     .set(
  //   {
  //     "updated": false,
  //   },
  //   SetOptions(merge: true),
  // );

  final completionMessage = "This is a temporary String";
  return completionMessage;
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isCheif = false;
  // DocumentSnapshot<Map<String, dynamic>>? _user;
  var userData;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    userData = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((value) => value.data());
  }

  // void addChallenges() {
  //   var list = [
  //     {
  //       "challengeId": "challenge_running",
  //       "heading": "Runner's Challenge",
  //       "description":
  //           "this is the description in which we are explaining what to do if somebody wants to complete this challenge",
  //       "scoreAwarede": 100,
  //     },
  //     {
  //       "challengeId": "challenge_dieting",
  //       "heading": "Dieting Challenge",
  //       "description":
  //           "this is the description in which we are explaining what to do if somebody wants to complete this challenge",
  //       "scoreAwarede": 150,
  //     },
  //     {
  //       "challengeId": "challenge_electricity_consumption",
  //       "heading": "Electricity Comsuption Challenge",
  //       "description":
  //           "this is the description in which we are explaining what to do if somebody wants to complete this challenge",
  //       "scoreAwarede": 200,
  //     },
  //     {
  //       "challengeId": "challenge_gardening",
  //       "heading": "Gardening Challenge",
  //       "description":
  //           "this is the description in which we are explaining what to do if somebody wants to complete this challenge",
  //       "scoreAwarede": 200,
  //     },
  //   ];

  //   for (var ch in list) {
  //     FirebaseFirestore.instance
  //         .collection("challenges")
  //         .doc("${ch["challengeId"]}")
  //         .set(ch);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String? email = FirebaseAuth.instance.currentUser!.email;
    bool isAdmin = false;

    if (email!.compareTo("gurpreetsarangal7@gmail.com") == 0) {
      isAdmin = true;
    }
    // getUser();
    return Scaffold(
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        leading: Icon(CupertinoIcons.question_circle),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        actions: [
          (isAdmin)
              ? IconButton(
                  onPressed: () async {

                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const newBlog()),
                    );
                  },
                  icon: Icon(CupertinoIcons.plus_app))
              : SizedBox(),
          IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const detailedReports()),
                );
              },
              icon: Icon(CupertinoIcons.graph_square)),
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context2) {
                    return AlertDialog(
                      title: Text("Do you really want to logout?"),
                      content: Text("After this you will have to login again!"),
                      actions: [
                        TextButton(
                            child: Text("OK"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await CustomSignOut();
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const LandingPage()),
                              );
                            }),
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
              },
              icon: Icon(CupertinoIcons.tray_arrow_up))
        ],
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.black26,
                image: DecorationImage(
                    image: AssetImage("assets/images/profile_page_bg.jpg"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12)),
            height: 150,
          ),
          generateBrief(),
          generateChallengesList(),
          generateFamilyList(),
          generateRequestsList(),
        ],
      )),
    );
  }

  Widget generateRequestsList() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!.data();
            print("This is insite requests item");
            print(user);

            bool isPending = false;
            try {
              if (snapshot.data!["requestPending"]) {
                isPending = true;
              }
            } catch (e) {
              print(e);
            }

            if (isPending) {
              return SizedBox();
            }
            // return Text("waiting for items");
            return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("family")
                    .where("accountNo", isEqualTo: user!["accountNo"])
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> memberArr =
                        snapshot.data!.docs.first["members"];
                    bool temp = false;
                    for (var mem in memberArr) {
                      if (mem["uid"] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        if (mem["isChief"] == true) {
                          temp = true;
                        }
                      }
                    }

                    // if (temp == false) {
                    //   return SizedBox();
                    // }

                    var fam = snapshot.data!.docs.first.data();
                    List<Widget> list = [
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                        height: 40,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Requests",
                                style: TextStyle(
                                    fontSize: 25, fontFamily: "Gotham"),
                              ),
                            ]),
                      ),
                    ];
                    for (var req in fam["request"]) {
                      print("Requests ------ ");
                      print(req);

                      var item = FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(req["fromEmail"])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print("inside the request user");
                              print(snapshot.data);
                              var reqUser = snapshot.data;
                              return Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                padding: EdgeInsets.only(left: 7.5, right: 7.5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black26, width: 1.5),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          // color: Colors.red,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/profile3_copy.png"),
                                              fit: BoxFit.fitHeight)),
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 0, left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${reqUser!["name"]}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Text(
                                            "${reqUser!["email"]}",
                                            style: TextStyle(
                                                fontSize: 12.5,
                                                color: Colors.black87),
                                          ),
                                          Text(
                                            "${reqUser!["individualRank"]}",
                                            style: TextStyle(
                                                fontSize: 12.5,
                                                color: Colors.black87),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            String uid = "NA";
                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(reqUser["email"])
                                                .get()
                                                .then((value) async {
                                              uid = value.data()!["uid"];
                                              print(uid);

                                              var family =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("family")
                                                      .where("accountNo",
                                                          isEqualTo:
                                                              value.data()![
                                                                  "accountNo"])
                                                      .get()
                                                      .then((value) {
                                                return value.docs.first.data();
                                              });

                                              print(family);

                                              List<dynamic> data =
                                                  family["members"];
                                              // FirebaseFirestore.instance.collection("family").doc(family["familyName"]).set(

                                              // )
                                              data.add({
                                                "isChief": false,
                                                "uid": uid,
                                              });

                                              var payload = {
                                                "members": data,
                                              };

                                              await FirebaseFirestore.instance
                                                  .collection("family")
                                                  .doc(family["familyName"])
                                                  .set(payload,
                                                      SetOptions(merge: true));

                                              var requests = family["request"];

                                              var newRequests = [];

                                              for (var req in requests) {
                                                if (req["fromEmail"] !=
                                                    value.data()!["email"]) {
                                                  newRequests.add(req);
                                                }
                                              }

                                              payload = {
                                                "request": newRequests
                                              };

                                              family["memebers"] = data;
                                              family["request"] = newRequests;

                                              print(
                                                  "-----=====--------========---------");
                                              print(family);
                                              print(
                                                  "-----=====--------========---------");

                                              FirebaseFirestore.instance
                                                  .collection("family")
                                                  .doc(family["familyName"])
                                                  .set(payload,
                                                      SetOptions(merge: true));
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(value.data()!["email"])
                                                  .set({
                                                "isRequested": false,
                                                "requestPending": false
                                              }, SetOptions(merge: true));
                                            });

                                            setState(() {});

                                            // print(uid);
                                          },
                                          icon: Icon(
                                            CupertinoIcons.checkmark_alt,
                                            color: Colors.green.shade400,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            var accountNo =
                                                snapshot.data!["accountNo"];

                                            var family = await FirebaseFirestore
                                                .instance
                                                .collection("family")
                                                .where("accountNo",
                                                    isEqualTo: accountNo)
                                                .get()
                                                .then((value) {
                                              print(value);
                                              return value.docs.first.data();
                                            });

                                            // print(family);

                                            var newRequest = [];
                                            for (var serverReq
                                                in family["request"]) {
                                              if (serverReq["fromEmail"] !=
                                                  req["fromEmail"]) {
                                                newRequest.add(serverReq);
                                              }
                                            }
                                            family["request"] = newRequest;

                                            print(
                                                "-----=====--------========---------");
                                            print(family);
                                            print(
                                                "-----=====--------========---------");

                                            await FirebaseFirestore.instance
                                                .collection("family")
                                                .doc(family["familyName"])
                                                .set(
                                                  family,
                                                );

                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(req["fromEmail"])
                                                .set({
                                              "accountNo": -1,
                                              "isRequested": false
                                            }, SetOptions(merge: true));
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            CupertinoIcons.clear_thick,
                                            color: Colors.red.shade400,
                                          ))
                                    ],
                                  ))
                                ]),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                          });
                      list.add(item);
                    }

                    if (list.length == 1) {
                      var defaultItem = Container(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        decoration: BoxDecoration(
                            color: Colors.lightGreen.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.lightGreen.shade200, width: 1.5)),
                        child: Row(children: [
                          // Expanded(
                          //     flex: 2,
                          //     child: FutureBuilder(
                          //       future: FirebaseStorage.instance
                          //           .ref()
                          //           .child('challenges')
                          //           .child('${ch["challengeId"]}.jpg')
                          //           .getDownloadURL(),
                          //       builder: getChallengeImage,
                          //     )),
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  // ? navigate to challenges page
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "You have no pending requests.",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      // Text("${ch[]}"),
                                    ],
                                  ),
                                ),
                              ))
                        ]),
                      );

                      list.add(defaultItem);
                    }

                    return Column(
                      children: list,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                });
          } else {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }

  Widget generateFamilyList() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!["accountNo"] == -1) {
            List<Widget> list = [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Family",
                        style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                      ),
                      // InkWell(
                      //     onTap: () => {},
                      //     child: Row(
                      //       mainAxisAlignment:
                      //           MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           "Details ",
                      //           style: TextStyle(
                      //               decoration: TextDecoration.underline),
                      //         ),
                      //         Icon(CupertinoIcons.arrow_right)
                      //       ],
                      //     ))
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200, width: 1.5)),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          // ? navigate to challenges page
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your request has been rejected",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                              // Text("${ch[]}"),
                            ],
                          ),
                        ),
                      ))
                ]),
              )
            ];

            return Column(
              children: list,
            );
          }

          print(snapshot.data!.data());

          bool isPending = false;
          try {
            if (snapshot.data!["requestPending"]) {
              isPending = true;
            }
          } catch (e) {
            print(e);
          }

          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("family")
                  .where("accountNo", isEqualTo: snapshot.data!["accountNo"])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var members = snapshot.data!.docs.first.data()["members"];
                  print(snapshot.data!.docs.first.data());
                  // return Center(
                  //     // child: CircularProgressIndicator.adaptive(),
                  //     child: Text("wait"));

                  List<Widget> list = [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 40,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Family",
                              style:
                                  TextStyle(fontSize: 25, fontFamily: "Gotham"),
                            ),
                            // InkWell(
                            //     onTap: () => {},
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text(
                            //           "Details ",
                            //           style: TextStyle(
                            //               decoration: TextDecoration.underline),
                            //         ),
                            //         Icon(CupertinoIcons.arrow_right)
                            //       ],
                            //     ))
                          ]),
                    ),
                  ];

                  if (isPending) {
                    list.add(Container(
                      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.red.shade200, width: 1.5)),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {
                                // ? navigate to challenges page
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your request is still pending",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    // Text("${ch[]}"),
                                  ],
                                ),
                              ),
                            ))
                      ]),
                    ));

                    return Column(
                      children: list,
                    );
                  }

                  for (var mem in members) {
                    var item = FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("Users")
                            .where("uid", isEqualTo: mem["uid"])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print("this is inside the member item");
                            var memData = snapshot.data!.docs.first.data();
                            print(snapshot.data!.docs.first.data());
                            return Container(
                              margin:
                                  EdgeInsets.only(top: 15, left: 15, right: 15),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black26, width: 1.5),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        // color: Colors.red,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/profile3_copy.png"),
                                            fit: BoxFit.fitHeight)),
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                Expanded(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${memData["name"]}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Text(
                                              "${memData["email"]}",
                                              style: TextStyle(
                                                  fontSize: 12.5,
                                                  color: Colors.black87),
                                            ),
                                            Text(
                                              "${memData["individualRank"]}",
                                              style: TextStyle(
                                                  fontSize: 12.5,
                                                  color: Colors.black87),
                                            )
                                          ]),
                                    ))
                              ]),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                        });

                    list.add(item);
                  }
                  return Column(
                    children: list,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              });

          // return Text("got");
        } else {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Widget generateChallengesList() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .get(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);

          var challengesData;
          if (snapshot.hasData) {
            print("this is printed in generateList");
            userData = snapshot.data;
            print(userData["challenges"]);
          } else {
            return CircularProgressIndicator();
          }
          challengesData = userData["challenges"];
          // int length = challengesData.length;

          List<Widget> list = [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Challenges",
                      style: TextStyle(fontSize: 25, fontFamily: "Gotham"),
                    ),
                    InkWell(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Details ",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                        Icon(CupertinoIcons.arrow_right)
                      ],
                    ))
                  ]),
            ),
          ];
          for (Map<String, dynamic> ch in challengesData) {
            // var itemcolor;

            var item = Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26, width: 1.5)),
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child('challenges')
                          .child('${ch["challengeId"]}.jpg')
                          .getDownloadURL(),
                      builder: getChallengeImage,
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${ch["heading"]}"),
                          // Text("${ch[]}"),
                          Text("${ch["score"]}%"),
                        ],
                      ),
                    ))
              ]),
            );
            list.add(item);
            // length--;
          }
          // print("Length of list ${list.length}");
          if (list.length == 1) {
            var defaultItem = Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              decoration: BoxDecoration(
                  color: Colors.lightGreen.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.lightGreen.shade200, width: 1.5)),
              child: Row(children: [
                // Expanded(
                //     flex: 2,
                //     child: FutureBuilder(
                //       future: FirebaseStorage.instance
                //           .ref()
                //           .child('challenges')
                //           .child('${ch["challengeId"]}.jpg')
                //           .getDownloadURL(),
                //       builder: getChallengeImage,
                //     )),
                Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () {
                        // ? navigate to challenges page
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) =>
                        //   ),
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Accept new challenges!!",
                              style: TextStyle(fontSize: 20),
                            ),
                            // Text("${ch[]}"),
                            // Text("Click Here"),
                          ],
                        ),
                      ),
                    ))
              ]),
            );

            list.add(defaultItem);
          }

          return Column(
            children: list,
          );
        });
  }

  Widget getChallengeImage(context, AsyncSnapshot<dynamic> snapshot) {
    String url = "didn't got";
    if (snapshot.hasData) {
      url = snapshot.data;
      return Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }

  Widget generateBrief() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get(),
        builder: (context, snapshot) {
          String steps;
          String stepsGoal;
          num accountNo;
          String completed = "NA";
          bool isPending = false;
          bool isRejected = false;
          bool _stepGoalNotSet = false;
          String unitsToday = "NA";
          String unitsCurrMonth = "NA";
          String unitsLastMonth = "NA";

          if (!snapshot.hasData) {
            return Container(
              height: 350,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 1.5)),
                    height: 50,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  Expanded(
                      child:
                          Center(child: CircularProgressIndicator.adaptive())),
                ],
              ),
            );
          }

          try {
            steps = snapshot.data!["stepsCount"].last["steps"].toString();
          } catch (_) {
            steps = "NA";
          }
          try {
            stepsGoal = snapshot.data!["stepsGoal"].toString();
          } on TypeError catch (_) {
            stepsGoal = "NA";
            completed = "NA";
            _stepGoalNotSet = true;
          }

          if (stepsGoal != "NA") {
            completed =
                "${((int.parse(steps) / int.parse(stepsGoal)) * 100).toPrecision(3).toString()}%";
          }

          accountNo = snapshot.data!["accountNo"];

          if (accountNo == -1) {
            isRejected = true;
          }

          try {
            if (snapshot.data!["requestPending"]) {
              isPending = true;
            }
          } catch (e) {
            print(e);
          }

          return Column(
            children: [
              Container(
                // height: 100,
                // color: Colors.black,
                margin: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            // color: Colors.red,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/profile3_copy.png"),
                                fit: BoxFit.fitHeight)),
                        height: 60,
                        width: 60,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        height: 75,
                        // width: 70,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    auth.currentUser!.displayName
                                            .toString()
                                            .capitalize ??
                                        auth.currentUser!.displayName
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .get(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        var userAccountNo =
                                            snapshot.data!.get("accountNo");
                                        print("------------");
                                        print(userAccountNo);
                                        print("------------");
                                        if (userAccountNo == -1) {
                                          return SizedBox();
                                        }
                                        return FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection("family")
                                              .where("accountNo",
                                                  isEqualTo: userAccountNo)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              // print("_user ${_user!.data()}");
                                              var members = snapshot
                                                  .data!.docs.first
                                                  .data()["members"];

                                              print("in title");

                                              // print(members!.docs.first.data());
                                              for (var mem in members) {
                                                if (mem["isChief"] == true &&
                                                    mem["uid"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid) {
                                                  return Icon(
                                                    CupertinoIcons.rosette,
                                                    color: Colors.blueAccent,
                                                  );
                                                }
                                              }
                                            }
                                            return SizedBox();
                                          },
                                        );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              Text(
                                auth.currentUser!.email.toString(),
                                style: TextStyle(
                                    fontSize: 11.5, color: Colors.black87),
                              ),
                              Text(
                                "Acc No: ${snapshot.data!["accountNo"].toString()}",
                                style: TextStyle(
                                    fontSize: 12.5, color: Colors.black87),
                              ),
                            ]),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(90),
                            // color: Colors.red,
                            // image: DecorationImage(
                            //     image: AssetImage("assets/images/profile3_copy.png")),
                            ),
                        height: 70,
                        width: 70,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                //<-- SEE HERE
                                return Colors.lightGreen
                                    .shade900; // Defer to the widget's default.
                              }, //background color of button
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                //<-- SEE HERE
                                return Colors
                                    .white; // Defer to the widget's default.
                              }, //background color of button
                            ),
                          ),
                          child: Text("Edit Profile"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => editProfile()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              (isRejected)
                  ? Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your request for account number has been rejected",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            Text(
                              "Try changing it in profile settings.",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            )
                          ]),
                    )
                  : SizedBox(),

              Container(
                // height: 200,
                margin: EdgeInsets.all(15),
                // padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black26, width: 1.5),
                      bottom: BorderSide(color: Colors.black26, width: 1.5)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    steps,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Steps",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.black26, width: 1.5),
                                      right: BorderSide(
                                          color: Colors.black26, width: 1.5))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(stepsGoal,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("Steps Goal",
                                      style: TextStyle(fontSize: 15))
                                ],
                              ),
                            )),
                            Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(completed,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("Completed",
                                      style: TextStyle(fontSize: 15))
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      (!isPending)
                          ? FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("family")
                                  .where("accountNo",
                                      isEqualTo: snapshot.data!["accountNo"])
                                  .get(),
                              builder: ((context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black26,
                                                    width: 1.5))),
                                      ),
                                      Container(
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                            Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                            Center(
                                                child: CircularProgressIndicator
                                                    .adaptive()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection("Data")
                                        .doc(snapshot
                                            .data!.docs.first["deviceId"])
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black26,
                                                          width: 1.5))),
                                            ),
                                            Container(
                                              height: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator
                                                              .adaptive()),
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator
                                                              .adaptive()),
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator
                                                              .adaptive()),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      List<dynamic> data =
                                          snapshot.data!["historicalData"];

                                      double todayUnits = 0;
                                      double thisMonthUnits = 0;
                                      double lastMonthUnits = 0;
                                      int todayDate = DateTime.now().day;
                                      int currMonth = DateTime.now().month;
                                      int currYear = DateTime.now().year;

                                      for (var rec in data.reversed.toList()) {
                                        if (rec["date"] == todayDate &&
                                            rec["month"] == currMonth &&
                                            rec["year"] == currYear) {
                                          todayUnits += rec["units"];
                                          thisMonthUnits += todayUnits;
                                        } else if (rec["month"] == currMonth &&
                                            rec["year"] == currYear) {
                                          thisMonthUnits += rec["units"];
                                        } else if ((rec["month"] ==
                                                    currMonth - 1 &&
                                                rec["year"] == currYear) ||
                                            (rec["month"] == 12 &&
                                                rec["year"] == currYear - 1)) {
                                          lastMonthUnits += rec["units"];
                                        } else {
                                          break;
                                        }
                                      }

                                      print(todayUnits);
                                      print(thisMonthUnits);
                                      print(lastMonthUnits);

                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.black26,
                                                        width: 1.5))),
                                          ),
                                          Container(
                                            height: 60,
                                            margin: EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        todayUnits
                                                            .toPrecision(3)
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text("Units Today",
                                                        style: TextStyle(
                                                            fontSize: 15))
                                                  ],
                                                )),
                                                Expanded(
                                                    child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          left: BorderSide(
                                                              color: Colors
                                                                  .black26,
                                                              width: 1.5),
                                                          right: BorderSide(
                                                              color: Colors
                                                                  .black26,
                                                              width: 1.5))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          thisMonthUnits
                                                              .toPrecision(3)
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      Text("Units Month",
                                                          style: TextStyle(
                                                              fontSize: 15))
                                                    ],
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        lastMonthUnits
                                                            .toPrecision(3)
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text("Last Month",
                                                        style: TextStyle(
                                                            fontSize: 15))
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }))
                          : SizedBox()
                    ]),
              ),
// -------
            ],
          );
        });
  }
}
