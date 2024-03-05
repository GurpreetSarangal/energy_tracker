import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/pages/dashboard/read_blog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        leading: IconButton(
          icon: Icon(CupertinoIcons.question_circle),
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        // actions: [
        //   // IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.search)),
        //   // IconButton(
        //   //     onPressed: () async {}, icon: Icon(CupertinoIcons.gear_alt))
        // ],
        title: Text(
          "Community Page",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            height: 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Leaderboard",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Gotham",
                    ),
                  ),
                ]),
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("Users")
                .orderBy("individualScore", descending: true)
                .get(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 600,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }

              var list = snapshot.data!.docs;
              int index = 0;
              List<Widget> items = [];

              for (var user in list) {
                var item;
                print(
                    '${user.data()["name"]} - ${user.data()["individualScore"]} - ${user.data()["email"]}');
                if (index == 0) {
                  item = Container(
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.amber.shade500,
                        border: Border.all(
                            color: Colors.amber.shade600, width: 1.5),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Container(
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
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${(user["name"] as String).capitalize}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Text(
                                  "${user["email"]}",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.5,
                                  ),
                                ),
                                Text(
                                  "${user["individualScore"]}",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.5,
                                  ),
                                )
                              ]),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Icon(
                              CupertinoIcons.star_circle,
                              size: 30,
                              color: Colors.white,
                            ),
                          ))
                    ]),
                  );
                } else if (index <= 2) {
                  item = Container(
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 1.5),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${user["name"]}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(
                                    "${user["email"]}",
                                    style: TextStyle(
                                        fontSize: 12.5, color: Colors.black87),
                                  ),
                                  Text(
                                    "${user["individualRank"]}",
                                    style: TextStyle(
                                        fontSize: 12.5, color: Colors.black87),
                                  )
                                ]),
                          ))
                    ]),
                  );
                } else {
                  break;
                }

                items.add(item);
                index++;
              }
              return Column(
                children: items,
              );
            }),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            height: 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Blogs",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Gotham",
                    ),
                  ),
                ]),
          ),
          Container(
              // ? Section 3 -- Consumption -- Starting
              color: Colors.transparent,
              height: 350,
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection("blogs").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  List<Widget> cardsRow = [];

                  for (var doc in snapshot.data!.docs.toList()) {
                    print(doc.data());
                    var blogData = doc.data();
                    var blogItem = FutureBuilder(
                        future: FirebaseStorage.instance
                            .ref()
                            .child(doc.data()["image"])
                            .getDownloadURL(),
                        builder: (context, snapshot2) {
                          String url = "didn't got";
                          if (snapshot2.hasData) {
                            url = snapshot2.data!;

                            return Card(
                              margin: EdgeInsets.only(left: 15, right: 5),
                              elevation: 20,
                              child: Container(
                                width: 200,
                                height: 300,
                                decoration: BoxDecoration(
                                    // color: Color(0xff214D56),
                                    // color: Colors.amberAccent,
                                    image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black38, BlendMode.darken)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          decoration: BoxDecoration(
                                              // color: Colors.blue,
                                              color: Colors.blue.shade50,
                                              backgroundBlendMode:
                                                  BlendMode.softLight),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Text(
                                                    blogData["heading"],
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 20,
                                                        fontFamily: "Gotham",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 35,
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Text(
                                                    blogData["description"],
                                                    style: TextStyle(
                                                        overflow:
                                                            TextOverflow.fade,
                                                        fontSize: 14,
                                                        fontFamily: "Gotham",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8, right: 7),
                                                  width: 140,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color?>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            //<-- SEE HERE
                                                            return Colors.white
                                                                .withOpacity(
                                                                    0.67); // Defer to the widget's default.
                                                          }, //background color of button
                                                        ),
                                                        surfaceTintColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color?>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            //<-- SEE HERE
                                                            return Colors
                                                                .transparent; // Defer to the widget's default.
                                                          }, //background color of button
                                                        ),
                                                        textStyle: MaterialStateProperty
                                                            .resolveWith<
                                                                    TextStyle?>(
                                                                (states) => TextStyle(
                                                                    fontFamily:
                                                                        'Gotham',
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        13)), //border width and color
                                                        elevation:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    double?>(
                                                          (Set<MaterialState>
                                                              states) {
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          28));
                                                        }),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color?>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .pressed)) {
                                                              return Colors
                                                                  .black12; //<-- SEE HERE
                                                            }
                                                            return null; // Defer to the widget's default.
                                                          },
                                                        ),
                                                      ),
                                                      onPressed: () => {
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        readBlog(),
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments:
                                                                      blogData[
                                                                          "blogId"],
                                                                ),
                                                              ),
                                                            )
                                                          },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Read Full",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Icon(CupertinoIcons
                                                              .arrow_up_right_square)
                                                        ],
                                                      )),
                                                ),
                                              ]),
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                        });

                    cardsRow.add(blogItem);
                  }

                  if (cardsRow.isEmpty) {
                    var defaultItem = Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26, width: 1.5),
                      ),
                      // height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Upcoming Blogs will be Posted Here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Epilogue",
                            ),
                          ),
                          Text(
                            "Stay tuned !!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Epilogue"),
                          ),
                        ],
                      ),
                    );
                    cardsRow.add(defaultItem);
                  }

                  return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cardsRow,
                      ));
                },
              )),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            height: 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Community Posts",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Gotham",
                    ),
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26, width: 1.5),
            ),
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "This Feature is coming soon",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Epilogue",
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
