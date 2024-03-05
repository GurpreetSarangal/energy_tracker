import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_tracker/pages/profile/blog_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class newBlog extends StatefulWidget {
  const newBlog({super.key});

  @override
  State<newBlog> createState() => _newBlogState();
}

class _newBlogState extends State<newBlog> {
  late final TextEditingController _heading;
  late final TextEditingController _content;
  final blogForm = GlobalKey<FormState>();
  String dafaultImagePath = "blogs/blog_image_temp${Random().nextInt(3)}.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _heading = TextEditingController();
    _content = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _heading.dispose();
    _content.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        // leading: Icon(CupertinoIcons.question_circle),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        title: Text(
          "New Blog",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: blogForm,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              // Container(),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.5),
                ),
                child: TextFormField(
                  controller: _heading,
                  decoration: const InputDecoration(
                    labelText: 'Heading',
                    alignLabelWithHint: true, // This align the label to the top
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: null,
                  // expands: true,
                  textCapitalization: TextCapitalization.sentences,
                  textAlignVertical: const TextAlignVertical(
                      y: -1), // This align the input text to the top
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.5),
                ),
                child: TextFormField(
                  controller: _content,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true, // This align the label to the top
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  // textAlignVertical: const TextAlignVertical(
                  //     y: -1), // This align the input text to the top
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Content of blog is required";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          //<-- SEE HERE
                          return Colors.green.shade100;
                        },
                      ),
                      surfaceTintColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          //<-- SEE HERE
                          return Colors.white; // Defer to the widget's default.
                        }, //background color of button
                      ),
                      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                        (states) => TextStyle(
                          fontFamily: 'Gotham',
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ), //border width and color
                      elevation: MaterialStateProperty.resolveWith<double?>(
                        (Set<MaterialState> states) {
                          return 3; // Defer to the widget's default.
                        },
                      ), //elevation of button
                      shape: MaterialStateProperty.resolveWith<
                          RoundedRectangleBorder?>((Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28));
                      }),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black12; //<-- SEE HERE
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () async {
                      if (blogForm.currentState!.validate()) {
                        var uuid = Uuid();
                        var payload = {
                          "blogId": uuid.v1(),
                          "heading": _heading.text,
                          "description": _content.text,
                          "image": dafaultImagePath,
                        };

                        await FirebaseFirestore.instance
                            .collection("blogs")
                            .doc(payload["blogId"])
                            .set(payload);

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const blogImage(),
                              settings:
                                  RouteSettings(arguments: payload["blogId"])),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Save ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green.shade800,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.add,
                            size: 18,
                            color: Colors.green.shade800,
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
