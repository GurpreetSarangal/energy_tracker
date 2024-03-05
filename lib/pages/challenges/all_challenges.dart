import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/pages/challenges/challenge.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllChallenges extends StatefulWidget {
  const AllChallenges({super.key});

  @override
  State<AllChallenges> createState() => _AllChallengesState();
}

class _AllChallengesState extends State<AllChallenges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        leading: Icon(CupertinoIcons.question_circle),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        // actions: [
        //   IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
        //   IconButton(
        //       onPressed: () async {}, icon: Icon(CupertinoIcons.gear_alt))
        // ],
        title: Text(
          "Challenges",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("challenges").get(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          List<Widget> list = [];
          for (var challenge in snapshot.data!.docs) {
            print(challenge.data());
            var item = InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ChallengeDetails(),
                    settings: RouteSettings(
                      arguments: challenge["challengeId"],
                    ),
                  ),
                );
              },
              child: Container(
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
                            .child('${challenge["challengeId"]}.jpg')
                            .getDownloadURL(),
                        builder: getChallengeImage,
                      )),
                  Expanded(
                      flex: 3,
                      child: Container(
                        height: 100,
                        // decoration: BoxDecoration(border: Border.all()),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${challenge["heading"].toString().capitalize}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            // Text("${challenge[]}"),
                            Text(
                              "${challenge["description"].toString().capitalizeFirst}",
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("Score Awarded: ${challenge["scoreAwarded"]}"),
                          ],
                        ),
                      ))
                ]),
              ),
            );
            list.add(item);
            // list.add(item);
            // list.add(item);
          }
          return SingleChildScrollView(
            child: Column(children: list),
          );
        }),
      ),
    );
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
}
