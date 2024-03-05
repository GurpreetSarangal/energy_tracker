import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class blogImage extends StatefulWidget {
  const blogImage({super.key});

  @override
  State<blogImage> createState() => _blogImageState();
}

List<CameraDescription> cameras = [];

class _blogImageState extends State<blogImage> {
  bool _gotImage = false;
  File? _image;
  CameraController? _controller;
  String? path;
  final ImagePicker _imagePicker = ImagePicker();
  String blogId = "";
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    // _accountNumber = TextEditingController();
    // final File imageFile = File(path ?? "");

    _initializeVision();
  }

  void _initializeVision() async {
    try {
      if (cameras.isEmpty) {
        cameras = await availableCameras();
        print(cameras);
      }

      // String pattern =
      //     r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
      // RegExp regEx = RegExp(pattern);

      _controller = await CameraController(cameras[0], ResolutionPreset.medium);
      _controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e) {
      print("error in _initializeVision() -> $e");
    }
  }

  Future getImageGallery() async {
    final image =
        await ImagePicker().pickImage(source: ImageSource.gallery) ?? XFile("");
    setState(() {
      _image = File(image.path);
      // print();
      if (_image?.path == "") {
        _gotImage = false;
      } else {
        _gotImage = true;
      }
    });
  }

  Future getImageCamera() async {
    final image =
        await _imagePicker.pickImage(source: ImageSource.camera) ?? XFile("");
    setState(() {
      _image = File(image.path);
      // print();
      if (_image?.path == "") {
        _gotImage = false;
      } else {
        _gotImage = true;
      }
    });
  }

  GlobalKey globalKey = GlobalKey();

  Future<void> pickImageAndProcess() async {
    try {
      print("----------in picked()------------------");
      await getImageGallery();
      print("----------after getImage()------------------");
      if (_gotImage) {
        // print("----------in clicked()------------------");

        InputImage _img = InputImage.fromFile(_image ?? File(""));
        // await _processImage(_img);

        // print("the value of num $_num");
        // _accountNumber.text = _num.toString();
        // if (_accountNumber.text.length >= 10) {
        //   _gotCorrectAccountNo = true;
        // }

        // Future<String> _ocrText =
        //     await FlutterTesseractOcr.extractText(_image.path);
        // String _ocrText = await FlutterTesseractOcr.extractText(
        //   _image.path,
        //   language: "eng",
        // );
        // print("-----------------------");
        // print(_ocrText);
        print("----------in clicked2()------------------");
      } else {
        print("-----------------------");
        print("no image");
        print("-----------------------");
      }
      // setState(() {
      //   // _accountNumberForm.currentState!.validate();
      // });
    } catch (e) {
      print("-------------------------------------");
      print("error in _clicked() -> $e");
      print("-------------------------------------");
    }

    // Checking whether the controller is initialized
  }

  @override
  void dispose() {
    _controller?.dispose();

    // _textRecognizer.close();
    super.dispose();
  }

  Future uploadFile() async {
    if (_image == null) return;
    final fileName = basename(_image!.path);
    final destination = 'blogs/$blogId.jpg';

    try {
      await storage.ref().child(destination).putFile(_image!);
      var data = await FirebaseFirestore.instance
          .collection("blogs")
          .doc(blogId)
          .get();

      var payload = data.data();
      payload!["image"] = destination;
      await FirebaseFirestore.instance
          .collection("blogs")
          .doc(blogId)
          .set(payload);
      // throw FirebaseException(plugin: "ajdka");

      showDialog(
        context: globalKey.currentContext!,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text("Image is uploaded"),
            content: Text("Upload completed. \nPlease click continue. "),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  // Navigator.of(globalKey.currentContext!).pop();
                  Navigator.of(globalKey.currentContext!).pop();
                  Navigator.of(globalKey.currentContext!).pop();
                  Navigator.of(globalKey.currentContext!).pop();
                },
              ),
            ],
          );
        },
      );
    } on FirebaseException catch (e) {
      print('error occured ${e}');
      showDialog(
        context: globalKey.currentContext!,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text("Error in Uploading"),
            content: Text(
                "The image was not uploaded. \nPlease continue without image. "),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(globalKey.currentContext!).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    blogId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        primary: true,
        forceMaterialTransparency: true,
        elevation: 40,
        // leading: Icon(CupertinoIcons.question_circle),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 80,
        title: Text(
          "Select Image for Blog",
          style: TextStyle(fontFamily: "Epilogue", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: pickImageAndProcess,
                  child: Text(
                    "Pick",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context2) {
                        return AlertDialog(
                          title: Text(
                              "Do you really want to continue without image"),
                          content: Text(
                              "you will still have default image with your blog"),
                          actions: [
                            TextButton(
                                child: Text("OK"),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
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
                  child: Text(
                    "Without Image",
                  ),
                ),
              ],
            ),
            _gotImage
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        child: InkWell(
                          child: Text(
                            "Preview Image",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        child: Center(child: Image.file(_image ?? File(""))),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await uploadFile();
                          },
                          child: Text("Save Image"))
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
