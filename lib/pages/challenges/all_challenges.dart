import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class allChallenges extends StatefulWidget {
  const allChallenges({super.key});

  @override
  State<allChallenges> createState() => _allChallengesState();
}

class _allChallengesState extends State<allChallenges> {
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
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
          IconButton(
              onPressed: () async {}, icon: Icon(CupertinoIcons.gear_alt))
        ],
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
          var list = [];
          for (var challenge in snapshot.data!.docs) {
            print(challenge.data());
            var item = Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: ,
            )
          }
          return Center();
        }),
      ),
    );
  }
}
