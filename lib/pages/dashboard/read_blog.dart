import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class readBlog extends StatefulWidget {
  const readBlog({super.key});

  @override
  State<readBlog> createState() => _readBlogState();
}

class _readBlogState extends State<readBlog> {
  String blogId = "";

  @override
  Widget build(BuildContext context) {
    blogId = ModalRoute.of(context)!.settings.arguments as String;
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
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,

        title: Text(
          "Blog",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("blogs").doc(blogId).get(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 300,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          var blogData = snapshot.data!;
          return Column(
            children: [
              FutureBuilder(
                future: FirebaseStorage.instance
                    .ref()
                    .child(blogData["image"])
                    .getDownloadURL(),
                builder: ((context, snapshotImgURL) {
                  if (!snapshotImgURL.hasData) {
                    return Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black54,
                      ),
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  return Container(
                    margin: EdgeInsets.all(15),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 200,
                    child: Container(
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
                            color: Colors.black45,
                            backgroundBlendMode: BlendMode.darken),
                        child: Center(
                          child: Text(
                            (snapshot.data!["heading"] as String).capitalize!,
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
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  blogData["description"],
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          );
        }),
      )),
    );
  }
}
